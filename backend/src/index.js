import "dotenv/config";
import express from "express";
import { getDatabase, hasDatabaseConfig } from "./db.js";
import { complaintSchema, maxAttachmentBytes, statusSchema } from "./validation.js";

const app = express();
const port = Number(process.env.PORT) || 4173;
const corsOrigins = new Set(
  (process.env.CORS_ORIGINS ?? '')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean),
);

app.disable("x-powered-by");
app.use((req, res, next) => {
  const origin = req.header('origin');
  if (origin) {
    res.vary('Origin');
    if (corsOrigins.has(origin)) {
      res.setHeader('Access-Control-Allow-Origin', origin);
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, OPTIONS');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-Admin-Key');
      res.setHeader('Access-Control-Max-Age', '600');
    }
  }
  if (req.method === 'OPTIONS') return res.sendStatus(204);
  return next();
});
app.use(express.json({ limit: "6mb" }));

function requireAdmin(req, res, next) {
  const configured = process.env.ADMIN_API_KEY;
  const supplied = req.header("x-admin-key");
  if (!configured) return res.status(503).json({ error: "ADMIN_API_KEY belum diatur di server." });
  if (!supplied || supplied !== configured) return res.status(401).json({ error: "Kunci admin tidak benar." });
  return next();
}

app.get("/api/health", async (_req, res) => {
  if (!hasDatabaseConfig()) return res.status(503).json({ status: "configuration_required", database: "not_configured" });
  try {
    await getDatabase()`SELECT 1`;
    return res.json({ status: "ok", database: "connected" });
  } catch (error) {
    console.error("Pemeriksaan Neon gagal:", error.message);
    return res.status(503).json({ status: "database_unavailable", database: "disconnected" });
  }
});

app.get("/api/stats", async (_req, res) => {
  try {
    const sql = getDatabase();
    const [counts] = await sql`SELECT COUNT(*)::integer AS total, COUNT(*) FILTER (WHERE status = 'in_review')::integer AS processing, COUNT(*) FILTER (WHERE status = 'resolved')::integer AS completed FROM complaints`;
    return res.json(counts);
  } catch (error) {
    if (!hasDatabaseConfig()) return res.status(503).json({ error: "Basis data belum dikonfigurasi." });
    console.error("Statistik pengaduan gagal:", error.message);
    return res.status(503).json({ error: "Statistik belum dapat dimuat." });
  }
});

app.post("/api/complaints", async (req, res) => {
  const parsed = complaintSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: "Periksa kembali isian laporan.", details: parsed.error.flatten().fieldErrors });
  const input = parsed.data;
  let attachmentBytes = null;
  if (input.attachment) {
    attachmentBytes = Buffer.from(input.attachment.data, "base64");
    if (attachmentBytes.length > maxAttachmentBytes) return res.status(413).json({ error: "Ukuran lampiran maksimal 4 MB." });
    if (attachmentBytes.length === 0) return res.status(400).json({ error: "File lampiran kosong." });
    const fileExtension = input.attachment.name.toLowerCase().split(".").pop();
    const expectedExtension = { "image/jpeg": ["jpg", "jpeg"], "image/png": ["png"], "application/pdf": ["pdf"] }[input.attachment.mime];
    const validSignature = { "image/jpeg": attachmentBytes.subarray(0, 3).equals(Buffer.from([0xff, 0xd8, 0xff])), "image/png": attachmentBytes.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])), "application/pdf": attachmentBytes.subarray(0, 5).toString("ascii") === "%PDF-" }[input.attachment.mime];
    if (!expectedExtension.includes(fileExtension) || !validSignature) return res.status(400).json({ error: "Isi file dan ekstensi harus cocok dengan tipe JPG, PNG, atau PDF." });
  }

  const id = crypto.randomUUID();
  try {
    const sql = getDatabase();
    await sql`INSERT INTO complaints (id, full_name, neighbourhood, contact, category, title, description, attachment_name, attachment_mime, attachment_data)
      VALUES (${id}::uuid, ${input.fullName}, ${input.neighbourhood}, ${input.contact || null}, ${input.category}, ${input.title}, ${input.description}, ${input.attachment?.name ?? null}, ${input.attachment?.mime ?? null}, ${attachmentBytes})`;
    return res.status(201).json({ id, status: "received", createdAt: new Date().toISOString() });
  } catch (error) {
    if (!hasDatabaseConfig()) return res.status(503).json({ error: "Basis data belum dikonfigurasi." });
    console.error("Pengaduan gagal disimpan:", error.message);
    return res.status(503).json({ error: "Laporan belum tersimpan. Silakan coba kembali sebentar lagi." });
  }
});

app.get("/api/complaints/:id", async (req, res) => {
  if (!/^[\da-f-]{36}$/i.test(req.params.id)) return res.status(404).json({ error: "Kode pelacakan tidak ditemukan." });
  try {
    const sql = getDatabase();
    const [complaint] = await sql`SELECT id, category, title, status, admin_note, created_at, updated_at FROM complaints WHERE id = ${req.params.id}::uuid`;
    if (!complaint) return res.status(404).json({ error: "Kode pelacakan tidak ditemukan." });
    return res.json(complaint);
  } catch (error) {
    if (!hasDatabaseConfig()) return res.status(503).json({ error: "Basis data belum dikonfigurasi." });
    console.error("Pemeriksaan status gagal:", error.message);
    return res.status(503).json({ error: "Status belum dapat dimuat." });
  }
});

app.get("/api/admin/complaints", requireAdmin, async (req, res) => {
  try {
    const sql = getDatabase();
    const complaints = await sql`SELECT id, full_name, neighbourhood, contact, category, title, description, status, admin_note, attachment_name, attachment_mime, created_at, updated_at FROM complaints ORDER BY created_at DESC LIMIT 100`;
    return res.json(complaints);
  } catch (error) {
    console.error("Daftar admin gagal dimuat:", error.message);
    return res.status(503).json({ error: "Daftar pengaduan belum dapat dimuat." });
  }
});

app.get("/api/admin/complaints/:id/attachment", requireAdmin, async (req, res) => {
  try {
    const sql = getDatabase();
    const [file] = await sql`SELECT attachment_name, attachment_mime, encode(attachment_data, 'base64') AS attachment_base64 FROM complaints WHERE id = ${req.params.id}::uuid AND attachment_data IS NOT NULL`;
    if (!file) return res.status(404).json({ error: "Lampiran tidak ditemukan." });
    return res.json(file);
  } catch (error) {
    console.error("Lampiran gagal dimuat:", error.message);
    return res.status(503).json({ error: "Lampiran belum dapat dimuat." });
  }
});

app.patch("/api/admin/complaints/:id", requireAdmin, async (req, res) => {
  const parsed = statusSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: "Status atau catatan tidak valid." });
  try {
    const sql = getDatabase();
    const [updated] = await sql`UPDATE complaints SET status = ${parsed.data.status}, admin_note = ${parsed.data.adminNote || null}, updated_at = NOW() WHERE id = ${req.params.id}::uuid RETURNING id, status, admin_note, updated_at`;
    if (!updated) return res.status(404).json({ error: "Pengaduan tidak ditemukan." });
    return res.json(updated);
  } catch (error) {
    console.error("Pembaruan pengaduan gagal:", error.message);
    return res.status(503).json({ error: "Perubahan belum dapat disimpan." });
  }
});

app.use((_req, res) => {
  return res.status(404).json({ error: "Endpoint tidak ditemukan." });
});

const server = app.listen(port, "0.0.0.0", () => console.log(`Layanan Kelurahan Cepoko aktif pada port ${port}.`));
for (const signal of ["SIGINT", "SIGTERM"]) {
  process.on(signal, () => server.close(() => process.exit(0)));
}

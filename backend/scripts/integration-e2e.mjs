import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import "dotenv/config";
import { getDatabase } from "../src/db.js";
import { setTimeout as delay } from "node:timers/promises";

if (!process.env.DATABASE_URL || !process.env.ADMIN_API_KEY) throw new Error("Isi DATABASE_URL dan ADMIN_API_KEY di .env sebelum menjalankan pengujian Neon.");

const port = 4318;
const host = `http://127.0.0.1:${port}`;
const adminHeaders = { "x-admin-key": process.env.ADMIN_API_KEY };
const child = spawn(process.execPath, ["src/index.js"], { env: { ...process.env, PORT: String(port) }, stdio: "ignore", windowsHide: true });
let reportId;

try {
  let running = false;
  for (let attempt = 0; attempt < 30; attempt += 1) {
    try { await fetch(`${host}/api/health`); running = true; break; } catch { await delay(200); }
  }
  assert.ok(running, "server lokal harus aktif");

  const healthResponse = await fetch(`${host}/api/health`);
  assert.equal(healthResponse.status, 200, "API lokal harus terhubung ke Neon");

  const creation = await fetch(`${host}/api/complaints`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      fullName: "Penguji Lokal",
      neighbourhood: "RT 99 / RW 99",
      contact: "uji-lokal@example.invalid",
      category: "Infrastruktur",
      title: "Uji integrasi sementara",
      description: "Laporan ini dibuat sementara untuk menguji layanan dan segera dihapus.",
      attachment: { name: "bukti-uji.pdf", mime: "application/pdf", data: Buffer.from("%PDF-1.7 local integration test").toString("base64") },
    }),
  });
  const created = await creation.json();
  assert.equal(creation.status, 201, `pengaduan harus tersimpan: ${created.error || ""}`);
  reportId = created.id;

  const trackingResponse = await fetch(`${host}/api/complaints/${reportId}`);
  const tracking = await trackingResponse.json();
  assert.equal(trackingResponse.status, 200);
  assert.equal(tracking.status, "received");
  assert.equal(tracking.title, "Uji integrasi sementara");
  assert.ok(!("full_name" in tracking), "informasi pribadi tak boleh masuk ke endpoint publik");

  const unauthorized = await fetch(`${host}/api/admin/complaints`);
  assert.equal(unauthorized.status, 401, "panel admin wajib menolak akses tanpa kunci");

  const inboxResponse = await fetch(`${host}/api/admin/complaints`, { headers: adminHeaders });
  const inbox = await inboxResponse.json();
  assert.equal(inboxResponse.status, 200);
  assert.ok(inbox.some((row) => row.id === reportId && row.full_name === "Penguji Lokal"));

  const fileResponse = await fetch(`${host}/api/admin/complaints/${reportId}/attachment`, { headers: adminHeaders });
  const file = await fileResponse.json();
  assert.equal(fileResponse.status, 200);
  assert.equal(Buffer.from(file.attachment_base64, "base64").toString("ascii"), "%PDF-1.7 local integration test");

  const updateResponse = await fetch(`${host}/api/admin/complaints/${reportId}`, {
    method: "PATCH", headers: { ...adminHeaders, "content-type": "application/json" },
    body: JSON.stringify({ status: "in_review", adminNote: "Laporan diteruskan untuk ditinjau." }),
  });
  assert.equal(updateResponse.status, 200);

  const updatedTrackingResponse = await fetch(`${host}/api/complaints/${reportId}`);
  const updatedTracking = await updatedTrackingResponse.json();
  assert.equal(updatedTracking.status, "in_review");
  assert.equal(updatedTracking.admin_note, "Laporan diteruskan untuk ditinjau.");

  const statsResponse = await fetch(`${host}/api/stats`);
  assert.equal(statsResponse.status, 200);
  const stats = await statsResponse.json();
  assert.ok(stats.total >= 1 && stats.processing >= 1, "statistik mencerminkan laporan uji selama dijalankan");

  console.log("E2E Neon lulus: sambungan, submit, lampiran, pelacakan privat, akses admin, perubahan status, dan statistik.");
} finally {
  if (reportId) await getDatabase()`DELETE FROM complaints WHERE id = ${reportId}::uuid`;
  child.kill();
}

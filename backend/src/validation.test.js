import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { complaintSchema, maxAttachmentBytes, statusSchema } from "./validation.js";

const goodReport = {
  fullName: "Rina Warga",
  neighbourhood: "RT 02 / RW 04",
  category: "Infrastruktur",
  title: "Lampu jalan padam",
  description: "Lampu jalan di depan balai warga padam sejak kemarin sore.",
};

describe("validasi pengaduan", () => {
  it("menerima laporan lengkap dan menormalkan isian", () => {
    const result = complaintSchema.parse({ ...goodReport, fullName: " Rina Warga ", attachment: { name: "bukti.png", mime: "image/png", data: "iVBORw0KGgo=" } });
    assert.equal(result.fullName, "Rina Warga");
    assert.deepEqual(result.attachment, { name: "bukti.png", mime: "image/png", data: "iVBORw0KGgo=" });
  });

  it("menolak uraian singkat, kategori tak dikenal, dan MIME lampiran terlarang", () => {
    assert.equal(complaintSchema.safeParse({ ...goodReport, description: "Pendek" }).success, false);
    assert.equal(complaintSchema.safeParse({ ...goodReport, category: "Lainnya" }).success, false);
    assert.equal(complaintSchema.safeParse({ ...goodReport, attachment: { name: "code.js", mime: "text/javascript", data: "YWJj" } }).success, false);
  });

  it("menetapkan batas lampiran empat megabita", () => assert.equal(maxAttachmentBytes, 4 * 1024 * 1024));
});

describe("pembaruan admin", () => {
  it("memvalidasi status dan merapikan catatan admin", () => {
    const result = statusSchema.parse({ status: "in_review", adminNote: "  Sedang ditinjau.  " });
    assert.equal(result.adminNote, "Sedang ditinjau.");
    assert.equal(statusSchema.safeParse({ status: "segera diproses" }).success, false);
  });
});

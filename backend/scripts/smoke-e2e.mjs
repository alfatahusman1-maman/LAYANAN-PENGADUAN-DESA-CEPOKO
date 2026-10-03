import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { setTimeout as delay } from "node:timers/promises";

const port = 4317;
const host = `http://127.0.0.1:${port}`;
const child = spawn(process.execPath, ["src/index.js"], {
  env: { ...process.env, PORT: String(port) },
  stdio: "ignore",
  windowsHide: true,
});

try {
  let running = false;
  for (let attempt = 0; attempt < 30; attempt += 1) {
    try {
      await fetch(host);
      running = true;
      break;
    } catch {
      await delay(200);
    }
  }
  assert.ok(running, "server must start locally");

  const unknownRoute = await fetch(`${host}/api/not-a-route`);
  assert.equal(unknownRoute.status, 404);
  assert.match((await unknownRoute.json()).error, /Endpoint tidak ditemukan/);

  const invalid = await fetch(`${host}/api/complaints`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ fullName: "A", title: "A", description: "pendek" }),
  });
  assert.equal(invalid.status, 400, "invalid reports should be rejected before database access");

  const unknown = await fetch(`${host}/api/complaints/not-a-tracking-code`);
  assert.equal(unknown.status, 404);
  console.log("Smoke test lokal lulus: server API aktif, validasi laporan berjalan, dan pencarian kode dilindungi.");
} finally {
  child.kill();
}

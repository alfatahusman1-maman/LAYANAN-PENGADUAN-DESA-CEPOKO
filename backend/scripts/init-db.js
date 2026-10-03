import "dotenv/config";
import { readFile } from "node:fs/promises";
import { getDatabase } from "../src/db.js";

const sql = getDatabase();
const schema = await readFile(new URL("../src/schema.sql", import.meta.url), "utf8");
const statements = schema.split(";").map((part) => part.trim()).filter(Boolean);
for (const statement of statements) await sql.query(statement);
console.log("Tabel pengaduan Neon telah siap.");

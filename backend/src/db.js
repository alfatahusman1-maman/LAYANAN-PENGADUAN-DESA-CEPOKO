import "dotenv/config";
import { neon } from "@neondatabase/serverless";

export function getDatabase() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("DATABASE_URL belum diatur. Tambahkan koneksi Neon ke .env.local.");
  }
  return neon(connectionString);
}

export function hasDatabaseConfig() {
  return Boolean(process.env.DATABASE_URL);
}

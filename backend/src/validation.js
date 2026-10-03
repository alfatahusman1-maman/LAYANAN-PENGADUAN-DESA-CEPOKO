import { z } from "zod";

export const categories = ["Infrastruktur", "Keamanan", "Administrasi", "Layanan publik"];
export const statuses = ["received", "in_review", "resolved", "declined"];
export const maxAttachmentBytes = 4 * 1024 * 1024;

export const complaintSchema = z.object({
  fullName: z.string().trim().min(2).max(120),
  neighbourhood: z.string().trim().min(1).max(30),
  contact: z.string().trim().max(120).optional().default(""),
  category: z.enum(categories),
  title: z.string().trim().min(5).max(160),
  description: z.string().trim().min(15).max(4000),
  attachment: z.object({
    name: z.string().trim().min(1).max(160),
    mime: z.enum(["image/jpeg", "image/png", "application/pdf"]),
    data: z.string().regex(/^[A-Za-z0-9+/]*={0,2}$/),
  }).optional(),
});

export const statusSchema = z.object({ status: z.enum(statuses), adminNote: z.string().trim().max(1500).optional().default("") });

CREATE TABLE IF NOT EXISTS complaints (
  id UUID PRIMARY KEY,
  full_name TEXT NOT NULL,
  neighbourhood TEXT NOT NULL,
  contact TEXT,
  category TEXT NOT NULL CHECK (category IN ('Infrastruktur', 'Keamanan', 'Administrasi', 'Layanan publik')),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'received' CHECK (status IN ('received', 'in_review', 'resolved', 'declined')),
  admin_note TEXT,
  attachment_name TEXT,
  attachment_mime TEXT,
  attachment_data BYTEA,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS complaints_created_at_idx ON complaints (created_at DESC);
CREATE INDEX IF NOT EXISTS complaints_status_idx ON complaints (status);

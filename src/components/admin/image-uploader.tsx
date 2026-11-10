"use client";

import { useId, useState, type ChangeEvent } from "react";
import { createClient } from "@/lib/supabase/client";
import { FormField } from "./form-field";

const RULES = {
  image: {
    accept: "image/jpeg,image/png,image/webp,image/avif",
    types: ["image/jpeg", "image/png", "image/webp", "image/avif"],
    maxBytes: 2 * 1024 * 1024,
    hint: "JPG, PNG, WebP, atau AVIF, maksimal 2 MB",
  },
  document: {
    accept: "application/pdf",
    types: ["application/pdf"],
    maxBytes: 5 * 1024 * 1024,
    hint: "PDF, maksimal 5 MB",
  },
} as const;

type ImageUploaderProps = {
  name: string; // nama field di form (berisi URL publik)
  label: string;
  folder: string; // contoh: "projects/<id>"
  kind?: keyof typeof RULES;
  defaultValue?: string | null;
  error?: string;
};

function safeFileName(name: string) {
  return (
    name
      .toLowerCase()
      .replace(/[^a-z0-9.]+/g, "-")
      .replace(/^-+|-+$/g, "") || "file"
  );
}

export function ImageUploader({
  name,
  label,
  folder,
  kind = "image",
  defaultValue = null,
  error,
}: ImageUploaderProps) {
  const inputId = useId();
  const rules = RULES[kind];
  const [value, setValue] = useState(defaultValue ?? "");
  const [uploading, setUploading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function handleChange(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    e.target.value = ""; // supaya file yang sama bisa dipilih ulang
    if (!file) return;

    setMessage(null);

    if (!(rules.types as readonly string[]).includes(file.type)) {
      setMessage(`Tipe file tidak didukung. ${rules.hint}.`);
      return;
    }
    if (file.size > rules.maxBytes) {
      const sizeMb = (file.size / 1024 / 1024).toFixed(1);
      const maxMb = rules.maxBytes / 1024 / 1024;
      setMessage(`Ukuran file ${sizeMb} MB melebihi batas ${maxMb} MB.`);
      return;
    }

    setUploading(true);
    const supabase = createClient();
    const path = `${folder}/${Date.now()}-${safeFileName(file.name)}`;

    const { error: uploadError } = await supabase.storage
      .from("media")
      .upload(path, file, { contentType: file.type, upsert: false });

    if (uploadError) {
      setMessage("Upload gagal. Coba lagi.");
      setUploading(false);
      return;
    }

    const { data } = supabase.storage.from("media").getPublicUrl(path);
    setValue(data.publicUrl);
    setUploading(false);
  }

  return (
    <FormField
      id={inputId}
      label={label}
      hint={rules.hint}
      error={error ?? message ?? undefined}
    >
      <input type="hidden" name={name} value={value} />

      {value && kind === "image" && (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          src={value}
          alt={`Pratinjau ${label}`}
          className="h-32 w-32 rounded-md border object-cover"
        />
      )}
      {value && kind === "document" && (
        <a
          href={value}
          target="_blank"
          rel="noopener noreferrer"
          className="block text-sm underline"
        >
          Buka file
        </a>
      )}

      <input
        id={inputId}
        type="file"
        accept={rules.accept}
        disabled={uploading}
        onChange={handleChange}
        className="block w-full text-sm file:mr-3 file:rounded-md file:border file:bg-white file:px-3 file:py-1.5 file:text-sm"
      />

      {uploading && <p className="text-xs text-gray-500">Mengunggah...</p>}

      {value && !uploading && (
        <button
          type="button"
          onClick={() => setValue("")}
          className="text-xs text-red-600 underline"
        >
          Hapus {kind === "image" ? "gambar" : "file"}
        </button>
      )}
    </FormField>
  );
}

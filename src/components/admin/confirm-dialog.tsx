"use client";

import { useRef } from "react";

type ConfirmDialogProps = {
  triggerLabel: string;
  title: string;
  description: string;
  confirmLabel?: string;
  action: (formData: FormData) => void | Promise<void>;
  hiddenFields?: Record<string, string>;
};

export function ConfirmDialog({
  triggerLabel,
  title,
  description,
  confirmLabel = "Ya, hapus",
  action,
  hiddenFields = {},
}: ConfirmDialogProps) {
  const ref = useRef<HTMLDialogElement>(null);

  return (
    <>
      <button
        type="button"
        onClick={() => ref.current?.showModal()}
        className="text-sm text-red-600 underline"
      >
        {triggerLabel}
      </button>

      <dialog
        ref={ref}
        className="m-auto w-full max-w-sm rounded-lg p-6 backdrop:bg-black/40"
      >
        <h2 className="text-lg font-semibold">{title}</h2>
        <p className="mt-2 text-sm text-gray-600">{description}</p>

        <form action={action} className="mt-6 flex justify-end gap-2">
          {Object.entries(hiddenFields).map(([name, value]) => (
            <input key={name} type="hidden" name={name} value={value} />
          ))}
          <button
            type="button"
            onClick={() => ref.current?.close()}
            className="rounded-md border px-3 py-1.5 text-sm"
          >
            Batal
          </button>
          <button
            type="submit"
            className="rounded-md bg-red-600 px-3 py-1.5 text-sm text-white"
          >
            {confirmLabel}
          </button>
        </form>
      </dialog>
    </>
  );
}

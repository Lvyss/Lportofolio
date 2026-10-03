import type { Metadata } from "next";
import type { ReactNode } from "react";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { logout } from "@/lib/actions/auth";
import { AdminSidebar } from "@/components/admin/sidebar";

export const metadata: Metadata = {
  title: "Admin",
  robots: { index: false, follow: false },
};

export default async function ProtectedLayout({
  children,
}: {
  children: ReactNode;
}) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/admin/login");

  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/admin/login");

  return (
    <div className="flex min-h-screen flex-col md:flex-row">
      <aside className="border-b md:w-56 md:border-b-0 md:border-r">
        <div className="px-6 py-4 text-sm font-semibold">Admin Panel</div>
        <AdminSidebar />
        <form action={logout} className="p-3">
          <button
            type="submit"
            className="w-full rounded-md border px-3 py-2 text-sm"
          >
            Logout
          </button>
        </form>
      </aside>
      <div className="flex-1 p-6">{children}</div>
    </div>
  );
}

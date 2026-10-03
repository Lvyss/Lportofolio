import { LayoutDashboard, UserRound, FolderKanban, type LucideIcon } from "lucide-react";

export type AdminNavItem = { href: string; label: string; icon: LucideIcon };

export const adminNav: AdminNavItem[] = [
  { href: "/admin", label: "Dashboard", icon: LayoutDashboard },
  { href: "/admin/profile", label: "Profile", icon: UserRound },
  { href: "/admin/projects", label: "Projects", icon: FolderKanban },
];

import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { 
  LayoutDashboard, 
  MapPin, 
  Tags, 
  CalendarCheck, 
  Users, 
  Star, 
  LogOut,
  Menu,
  X,
  Plane
} from 'lucide-react';
import { cn } from '@/src/lib/utils';
import { Button } from '@/src/components/ui/button';
import { useAuth } from '@/src/contexts/AuthContext';
import { Sheet, SheetContent, SheetTrigger } from '@/src/components/ui/sheet';
import { isSupabaseConfigured } from '@/src/lib/supabase';

const navItems = [
  { icon: LayoutDashboard, label: 'Dashboard', href: '/' },
  { icon: MapPin, label: 'Destinations', href: '/destinations' },
  { icon: Tags, label: 'Categories', href: '/categories' },
  { icon: CalendarCheck, label: 'Bookings', href: '/bookings' },
  { icon: Users, label: 'Users', href: '/users' },
  { icon: Star, label: 'Reviews', href: '/reviews' },
];

export const Sidebar = ({ className }: { className?: string }) => {
  const { signOut } = useAuth();
  const navigate = useNavigate();

  const handleSignOut = async () => {
    await signOut();
    navigate('/login');
  };

  return (
    <div className={cn("flex flex-col h-full bg-card border-r", className)}>
      <div className="p-6 flex items-center gap-2">
        <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center text-primary-foreground">
          <Plane className="w-5 h-5" />
        </div>
        <span className="font-bold text-xl tracking-tight">Wanderlust</span>
      </div>

      <nav className="flex-1 px-4 space-y-1">
        {navItems.map((item) => (
          <NavLink
            key={item.href}
            to={item.href}
            className={({ isActive }) => cn(
              "flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors",
              isActive 
                ? "bg-primary text-primary-foreground" 
                : "text-muted-foreground hover:bg-accent hover:text-accent-foreground"
            )}
          >
            <item.icon className="w-4 h-4" />
            {item.label}
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t">
        <Button 
          variant="ghost" 
          className="w-full justify-start gap-3 text-muted-foreground hover:text-destructive"
          onClick={handleSignOut}
        >
          <LogOut className="w-4 h-4" />
          Sign Out
        </Button>
      </div>
    </div>
  );
};

export const Layout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="flex h-screen bg-background overflow-hidden">
      {/* Desktop Sidebar */}
      <Sidebar className="hidden md:flex w-64" />

      {/* Main Content */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <header className="h-16 border-b bg-card flex items-center justify-between px-4 md:px-8">
          <div className="flex items-center gap-4">
            <Sheet>
              <SheetTrigger className="md:hidden inline-flex items-center justify-center rounded-md p-2 text-muted-foreground hover:bg-accent hover:text-accent-foreground">
                <Menu className="w-5 h-5" />
              </SheetTrigger>
              <SheetContent side="left" className="p-0 w-64">
                <Sidebar />
              </SheetContent>
            </Sheet>
            <div className="flex items-center gap-3">
              <h1 className="text-lg font-semibold md:text-xl">Admin Dashboard</h1>
              {!isSupabaseConfigured && (
                <span className="px-2 py-0.5 bg-blue-100 text-blue-700 text-[10px] font-bold uppercase tracking-wider rounded-full border border-blue-200">
                  Demo Mode
                </span>
              )}
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            {/* Dark mode toggle could go here */}
          </div>
        </header>

        <main className="flex-1 overflow-y-auto p-4 md:p-8">
          <div className="max-w-7xl mx-auto space-y-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};

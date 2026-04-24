import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase, isSupabaseConfigured } from '@/src/lib/supabase';
import { Button } from '@/src/components/ui/button';
import { Input } from '@/src/components/ui/input';
import { Label } from '@/src/components/ui/label';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/src/components/ui/card';
import { Plane, Loader2, Info } from 'lucide-react';
import { toast } from 'sonner';

export const LoginPage = () => {
  const [email, setEmail] = useState(isSupabaseConfigured ? '' : 'admin@example.com');
  const [password, setPassword] = useState(isSupabaseConfigured ? '' : 'admin123');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      // Check if user is admin
      const { data: profile, error: profileError } = await supabase
        .from('users')
        .select('role')
        .eq('id', data.user.id)
        .single();

      if (profileError || profile?.role !== 'admin') {
        await supabase.auth.signOut();
        toast.error('Access denied. Admin role required.');
        return;
      }

      toast.success('Logged in successfully');
      navigate('/');
    } catch (error: any) {
      toast.error(error.message || 'Failed to login');
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    setLoading(true);
    try {
      if (!isSupabaseConfigured) {
        toast.error('Google login requires Supabase to be configured.');
        return;
      }
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: window.location.origin,
        },
      });

      if (error) throw error;
    } catch (error: any) {
      toast.error(error.message || 'Failed to login with Google');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col md:flex-row bg-background">
      {/* Left side: Premium Branding */}
      <div className="hidden md:flex flex-1 relative bg-zinc-950 overflow-hidden items-center justify-center">
        <div
          className="absolute inset-0 opacity-[0.03]"
          style={{ backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")` }}
        />
        <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-br from-primary/30 via-transparent to-transparent opacity-80" />
        <div className="absolute bottom-0 right-0 w-[500px] h-[500px] bg-primary/10 rounded-full blur-[150px]" />

        <div className="relative z-10 text-center space-y-8 max-w-lg px-8">
          <div className="w-24 h-24 bg-primary rounded-3xl flex items-center justify-center mx-auto shadow-[0_0_60px_-15px_rgba(255,184,0,0.5)] animate-in zoom-in duration-1000">
            <Plane className="w-12 h-12 text-primary-foreground" />
          </div>
          <div className="space-y-4 animate-in slide-in-from-bottom-8 fade-in duration-1000 delay-150">
            <h1 className="text-5xl text-white font-extrabold tracking-tight">
              D-Travel <span className="text-primary">Admin</span>
            </h1>
            <p className="text-zinc-400 text-lg leading-relaxed">
              Pusat kendali eksekutif untuk manajemen destinasi, pemesanan, dan pelanggan.
            </p>
          </div>
        </div>
      </div>

      {/* Right side: Login Form */}
      <div className="flex-1 flex items-center justify-center p-6 sm:p-12 animate-in fade-in slide-in-from-right-12 duration-700">
        <div className="w-full max-w-[420px] space-y-8">
          <div className="text-center md:text-left">
            <div className="md:hidden w-14 h-14 bg-primary rounded-2xl flex items-center justify-center text-primary-foreground mb-6 mx-auto shadow-lg shadow-primary/30">
              <Plane className="w-7 h-7" />
            </div>
            <h2 className="text-3xl font-extrabold tracking-tight">Selamat Datang</h2>
            <p className="text-muted-foreground mt-2 text-sm md:text-base">
              Masukkan kredensial Anda untuk mengakses dasbor.
            </p>

            {!isSupabaseConfigured && (
              <div className="mt-6 p-4 bg-amber-500/10 border border-amber-500/20 rounded-2xl text-sm flex gap-3 animate-in fade-in slide-in-from-top-4 duration-500">
                <Info className="w-5 h-5 shrink-0 text-amber-500" />
                <div className="space-y-1.5 text-left w-full">
                  <p className="font-semibold text-amber-600 dark:text-amber-400">Mode Demo Aktif</p>
                  <p className="text-amber-700/80 dark:text-amber-200/80">Supabase belum dikonfigurasi. Gunakan akses ini untuk masuk:</p>
                  <div className="mt-2 font-mono text-xs bg-background/80 px-3 py-2.5 rounded-lg border border-amber-500/20 text-foreground w-full break-all">
                    Email: admin@example.com<br />
                    Pass: admin123
                  </div>
                </div>
              </div>
            )}
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            <div className="space-y-5">
              <div className="space-y-2">
                <Label htmlFor="email" className="font-semibold text-sm">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="admin@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="h-12 px-4 rounded-xl bg-muted/40 border-transparent focus:border-primary focus:bg-background transition-all duration-300"
                  required
                />
              </div>
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <Label htmlFor="password" className="font-semibold text-sm">Password</Label>
                  <span className="text-xs text-primary font-medium cursor-pointer hover:underline transition-all">Lupa password?</span>
                </div>
                <Input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="h-12 px-4 rounded-xl bg-muted/40 border-transparent focus:border-primary focus:bg-background transition-all duration-300"
                  required
                />
              </div>
            </div>

            <Button
              className="w-full h-12 rounded-xl font-bold text-base shadow-lg shadow-primary/20 hover:shadow-primary/40 transition-all active:scale-[0.98]"
              type="submit"
              disabled={loading}
            >
              {loading ? <Loader2 className="mr-2 h-5 w-5 animate-spin" /> : null}
              Sign In
            </Button>

            <div className="relative w-full my-8">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t border-border" />
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-background px-4 text-muted-foreground font-medium tracking-wider">
                  Atau login dengan
                </span>
              </div>
            </div>

            <Button
              type="button"
              variant="outline"
              className="w-full h-12 rounded-xl flex items-center justify-center gap-3 font-medium hover:bg-muted/50 border-input transition-all"
              disabled={loading}
              onClick={handleGoogleLogin}
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" className="w-5 h-5">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                <path d="M1 1h22v22H1z" fill="none" />
              </svg>
              Google
            </Button>
          </form>
        </div>
      </div>
    </div>
  );
};

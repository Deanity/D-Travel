import React, { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/src/components/ui/card';
import { Users, MapPin, CalendarCheck, DollarSign, TrendingUp, Clock } from 'lucide-react';
import { supabase } from '@/src/lib/supabase';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  AreaChart,
  Area
} from 'recharts';
import { format } from 'date-fns';
import { Badge } from '@/src/components/ui/badge';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/src/components/ui/table';
import { Skeleton } from '@/src/components/ui/skeleton';

export const DashboardPage = () => {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalDestinations: 0,
    totalBookings: 0,
    totalRevenue: 0,
  });
  const [recentBookings, setRecentBookings] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    setLoading(true);
    try {
      const [
        { count: usersCount },
        { count: destinationsCount },
        { count: bookingsCount },
        { data: paymentsData },
        { data: bookingsData }
      ] = await Promise.all([
        supabase.from('users').select('*', { count: 'exact', head: true }).is('deleted_at', null),
        supabase.from('destinations').select('*', { count: 'exact', head: true }).is('deleted_at', null),
        supabase.from('bookings').select('*', { count: 'exact', head: true }).is('deleted_at', null),
        supabase.from('payments').select('amount').eq('status', 'success').is('deleted_at', null),
        supabase.from('bookings')
          .select(`
            *,
            users (name),
            destinations (name)
          `)
          .is('deleted_at', null)
          .order('created_at', { ascending: false })
          .limit(5)
      ]);

      const revenue = paymentsData?.reduce((acc, curr) => acc + curr.amount, 0) || 0;

      setStats({
        totalUsers: usersCount || 0,
        totalDestinations: destinationsCount || 0,
        totalBookings: bookingsCount || 0,
        totalRevenue: revenue,
      });

      setRecentBookings(bookingsData || []);
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const statCards = [
    { title: 'Total Users', value: stats.totalUsers, icon: Users, color: 'text-blue-500', bg: 'bg-blue-500/10' },
    { title: 'Total Destinations', value: stats.totalDestinations, icon: MapPin, color: 'text-emerald-500', bg: 'bg-emerald-500/10' },
    { title: 'Total Bookings', value: stats.totalBookings, icon: CalendarCheck, color: 'text-purple-500', bg: 'bg-purple-500/10' },
    { title: 'Total Revenue', value: `$${stats.totalRevenue.toLocaleString()}`, icon: DollarSign, color: 'text-orange-500', bg: 'bg-orange-500/10' },
  ];

  // Mock data for charts
  const chartData = [
    { name: 'Jan', bookings: 40, revenue: 2400 },
    { name: 'Feb', bookings: 30, revenue: 1398 },
    { name: 'Mar', bookings: 20, revenue: 9800 },
    { name: 'Apr', bookings: 27, revenue: 3908 },
    { name: 'May', bookings: 18, revenue: 4800 },
    { name: 'Jun', bookings: 23, revenue: 3800 },
    { name: 'Jul', bookings: 34, revenue: 4300 },
  ];

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex flex-col gap-2">
        <h2 className="text-3xl font-bold tracking-tight">Overview</h2>
        <p className="text-muted-foreground">Welcome back! Here's what's happening with your platform today.</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {loading ? (
          Array(4).fill(0).map((_, i) => (
            <Card key={i}>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-4 w-4 rounded-full" />
              </CardHeader>
              <CardContent>
                <Skeleton className="h-8 w-16 mb-1" />
                <Skeleton className="h-3 w-32" />
              </CardContent>
            </Card>
          ))
        ) : (
          statCards.map((stat) => (
            <Card key={stat.title} className="hover:shadow-md transition-shadow">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">{stat.title}</CardTitle>
                <div className={cn("p-2 rounded-lg", stat.bg)}>
                  <stat.icon className={cn("w-4 h-4", stat.color)} />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stat.value}</div>
                <p className="text-xs text-muted-foreground flex items-center gap-1 mt-1">
                  <TrendingUp className="w-3 h-3 text-emerald-500" />
                  <span className="text-emerald-500 font-medium">+12%</span> from last month
                </p>
              </CardContent>
            </Card>
          ))
        )}
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <Card className="lg:col-span-4">
          <CardHeader>
            <CardTitle>Revenue Growth</CardTitle>
          </CardHeader>
          <CardContent className="pl-2">
            <div className="h-[300px] w-full">
              <ResponsiveContainer width="100%" height={300} minWidth={0} minHeight={0}>
                <AreaChart data={chartData}>
                  <defs>
                    <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="hsl(var(--primary))" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="hsl(var(--primary))" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--muted))" />
                  <XAxis 
                    dataKey="name" 
                    stroke="hsl(var(--muted-foreground))" 
                    fontSize={12} 
                    tickLine={false} 
                    axisLine={false} 
                  />
                  <YAxis 
                    stroke="hsl(var(--muted-foreground))" 
                    fontSize={12} 
                    tickLine={false} 
                    axisLine={false} 
                    tickFormatter={(value) => `$${value}`}
                  />
                  <Tooltip 
                    contentStyle={{ 
                      backgroundColor: 'hsl(var(--card))', 
                      borderColor: 'hsl(var(--border))',
                      borderRadius: '8px',
                      color: 'hsl(var(--foreground))'
                    }} 
                  />
                  <Area 
                    type="monotone" 
                    dataKey="revenue" 
                    stroke="hsl(var(--primary))" 
                    fillOpacity={1} 
                    fill="url(#colorRevenue)" 
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        <Card className="lg:col-span-3">
          <CardHeader>
            <CardTitle>Recent Bookings</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-8">
              {loading ? (
                Array(5).fill(0).map((_, i) => (
                  <div key={i} className="flex items-center gap-4">
                    <Skeleton className="h-9 w-9 rounded-full" />
                    <div className="space-y-1 flex-1">
                      <Skeleton className="h-4 w-32" />
                      <Skeleton className="h-3 w-24" />
                    </div>
                    <Skeleton className="h-4 w-16" />
                  </div>
                ))
              ) : recentBookings.length === 0 ? (
                <div className="flex flex-col items-center justify-center h-[300px] text-muted-foreground">
                  <Clock className="w-12 h-12 mb-4 opacity-20" />
                  <p>No recent bookings found</p>
                </div>
              ) : (
                recentBookings.map((booking) => (
                  <div key={booking.id} className="flex items-center gap-4">
                    <div className="w-9 h-9 rounded-full bg-muted flex items-center justify-center font-medium text-sm">
                      {booking.users?.name?.charAt(0) || 'U'}
                    </div>
                    <div className="flex-1 space-y-1">
                      <p className="text-sm font-medium leading-none">{booking.users?.name}</p>
                      <p className="text-xs text-muted-foreground">
                        {booking.destinations?.name}
                      </p>
                    </div>
                    <div className="text-right space-y-1">
                      <p className="text-sm font-medium">${booking.total_price}</p>
                      <Badge variant={
                        booking.status === 'paid' ? 'default' : 
                        booking.status === 'pending' ? 'secondary' : 'destructive'
                      } className="text-[10px] px-1.5 py-0 h-4">
                        {booking.status}
                      </Badge>
                    </div>
                  </div>
                ))
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

import { cn } from '@/src/lib/utils';

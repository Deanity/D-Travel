import React, { useState, useEffect } from 'react';
import { supabase } from '@/src/lib/supabase';
import { Button } from '@/src/components/ui/button';
import { Input } from '@/src/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/src/components/ui/table';
import { Search, Calendar, User, MapPin, MoreHorizontal, Loader2, CheckCircle2, XCircle, Clock } from 'lucide-react';
import { toast } from 'sonner';
import { Badge } from '@/src/components/ui/badge';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/src/components/ui/dropdown-menu';
import { format } from 'date-fns';
import { Skeleton } from '@/src/components/ui/skeleton';

export const BookingsPage = () => {
  const [bookings, setBookings] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('bookings')
        .select(`
          *,
          users (name, email),
          destinations (name)
        `)
        .is('deleted_at', null)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setBookings(data || []);
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setLoading(false);
    }
  };

  const updateStatus = async (id: string, status: 'pending' | 'paid' | 'cancelled') => {
    try {
      const { error } = await supabase
        .from('bookings')
        .update({ status, updated_at: new Date().toISOString() })
        .eq('id', id);

      if (error) throw error;
      toast.success(`Booking status updated to ${status}`);
      fetchBookings();
    } catch (error: any) {
      toast.error(error.message);
    }
  };

  const filteredBookings = bookings.filter(booking => {
    const matchesSearch = booking.users?.name?.toLowerCase().includes(search.toLowerCase()) || 
                         booking.destinations?.name?.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === 'all' || booking.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'paid': return <CheckCircle2 className="w-3 h-3 mr-1" />;
      case 'cancelled': return <XCircle className="w-3 h-3 mr-1" />;
      default: return <Clock className="w-3 h-3 mr-1" />;
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Bookings</h2>
        <p className="text-muted-foreground">Manage customer bookings and reservations.</p>
      </div>

      <div className="flex flex-col md:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input 
            placeholder="Search by user or destination..." 
            className="pl-10"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <div className="flex gap-2">
          {['all', 'pending', 'paid', 'cancelled'].map((status) => (
            <Button
              key={status}
              variant={statusFilter === status ? 'default' : 'outline'}
              size="sm"
              onClick={() => setStatusFilter(status)}
              className="capitalize"
            >
              {status}
            </Button>
          ))}
        </div>
      </div>

      <div className="border rounded-lg bg-card overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>User</TableHead>
              <TableHead>Destination</TableHead>
              <TableHead>Dates</TableHead>
              <TableHead>Price</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              Array(5).fill(0).map((_, i) => (
                <TableRow key={i}>
                  <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-24" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-16" /></TableCell>
                  <TableCell><Skeleton className="h-6 w-20 rounded-full" /></TableCell>
                  <TableCell className="text-right"><Skeleton className="h-8 w-8 ml-auto rounded-full" /></TableCell>
                </TableRow>
              ))
            ) : filteredBookings.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="h-32 text-center text-muted-foreground">
                  No bookings found.
                </TableCell>
              </TableRow>
            ) : (
              filteredBookings.map((booking) => (
                <TableRow key={booking.id}>
                  <TableCell>
                    <div className="flex flex-col">
                      <span className="font-medium">{booking.users?.name}</span>
                      <span className="text-xs text-muted-foreground">{booking.users?.email}</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-1">
                      <MapPin className="w-3 h-3 text-muted-foreground" />
                      {booking.destinations?.name}
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex flex-col text-xs">
                      <span className="flex items-center gap-1">
                        <Calendar className="w-3 h-3" />
                        Booked: {format(new Date(booking.booking_date), 'MMM d, yyyy')}
                      </span>
                      <span className="flex items-center gap-1 text-muted-foreground">
                        <Clock className="w-3 h-3" />
                        Visit: {format(new Date(booking.visit_date), 'MMM d, yyyy')}
                      </span>
                    </div>
                  </TableCell>
                  <TableCell className="font-medium">${booking.total_price}</TableCell>
                  <TableCell>
                    <Badge variant={
                      booking.status === 'paid' ? 'default' : 
                      booking.status === 'pending' ? 'secondary' : 'destructive'
                    } className="flex items-center w-fit">
                      {getStatusIcon(booking.status)}
                      <span className="capitalize">{booking.status}</span>
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger className="inline-flex items-center justify-center rounded-md h-9 w-9 text-muted-foreground hover:bg-accent hover:text-accent-foreground outline-none">
                        <MoreHorizontal className="w-4 h-4" />
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => updateStatus(booking.id, 'paid')}>
                          <CheckCircle2 className="w-4 h-4 mr-2 text-emerald-500" />
                          Mark as Paid
                        </DropdownMenuItem>
                        <DropdownMenuItem onClick={() => updateStatus(booking.id, 'pending')}>
                          <Clock className="w-4 h-4 mr-2 text-blue-500" />
                          Mark as Pending
                        </DropdownMenuItem>
                        <DropdownMenuItem onClick={() => updateStatus(booking.id, 'cancelled')}>
                          <XCircle className="w-4 h-4 mr-2 text-destructive" />
                          Cancel Booking
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
};

import React, { useState, useEffect } from 'react';
import { supabase } from '@/src/lib/supabase';
import { Button } from '@/src/components/ui/button';
import { Input } from '@/src/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/src/components/ui/table';
import { 
  Dialog, 
  DialogContent, 
  DialogDescription, 
  DialogFooter, 
  DialogHeader, 
  DialogTitle, 
  DialogTrigger 
} from '@/src/components/ui/dialog';
import { Label } from '@/src/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/src/components/ui/select';
import { Plus, Search, Edit2, Trash2, MapPin, Star, MoreHorizontal, Loader2 } from 'lucide-react';
import { toast } from 'sonner';
import { Badge } from '@/src/components/ui/badge';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/src/components/ui/dropdown-menu';
import { Skeleton } from '@/src/components/ui/skeleton';

export const DestinationsPage = () => {
  const [destinations, setDestinations] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingDestination, setEditingDestination] = useState<any>(null);
  const [submitting, setSubmitting] = useState(false);

  // Form state
  const [formData, setFormData] = useState({
    name: '',
    location: '',
    description: '',
    price: 0,
    category_id: '',
    image_url: ''
  });

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    setLoading(true);
    try {
      const [destRes, catRes] = await Promise.all([
        supabase
          .from('destinations')
          .select('*, categories(name)')
          .is('deleted_at', null)
          .order('created_at', { ascending: false }),
        supabase
          .from('categories')
          .select('*')
          .is('deleted_at', null)
      ]);

      if (destRes.error) throw destRes.error;
      if (catRes.error) throw catRes.error;

      setDestinations(destRes.data || []);
      setCategories(catRes.data || []);
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenModal = (destination: any = null) => {
    if (destination) {
      setEditingDestination(destination);
      setFormData({
        name: destination.name,
        location: destination.location,
        description: destination.description || '',
        price: destination.price,
        category_id: destination.category_id,
        image_url: '' // We'll handle images separately if needed, but for now just URL
      });
    } else {
      setEditingDestination(null);
      setFormData({
        name: '',
        location: '',
        description: '',
        price: 0,
        category_id: '',
        image_url: ''
      });
    }
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);

    try {
      if (editingDestination) {
        const { error } = await supabase
          .from('destinations')
          .update({
            name: formData.name,
            location: formData.location,
            description: formData.description,
            price: formData.price,
            category_id: formData.category_id,
            updated_at: new Date().toISOString()
          })
          .eq('id', editingDestination.id);

        if (error) throw error;
        toast.success('Destination updated successfully');
      } else {
        const { data, error } = await supabase
          .from('destinations')
          .insert([{
            name: formData.name,
            location: formData.location,
            description: formData.description,
            price: formData.price,
            category_id: formData.category_id,
            rating: 0
          }])
          .select();

        if (error) throw error;

        // If image URL provided, add to destination_images
        if (formData.image_url && data?.[0]) {
          await supabase.from('destination_images').insert([{
            destination_id: data[0].id,
            image_url: formData.image_url
          }]);
        }

        toast.success('Destination created successfully');
      }

      setIsModalOpen(false);
      fetchData();
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setSubmitting(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this destination?')) return;

    try {
      const { error } = await supabase
        .from('destinations')
        .update({ deleted_at: new Date().toISOString() })
        .eq('id', id);

      if (error) throw error;
      toast.success('Destination deleted successfully');
      fetchData();
    } catch (error: any) {
      toast.error(error.message);
    }
  };

  const filteredDestinations = destinations.filter(dest => {
    const matchesSearch = dest.name.toLowerCase().includes(search.toLowerCase()) || 
                         dest.location.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'all' || dest.category_id === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Destinations</h2>
          <p className="text-muted-foreground">Manage your travel destinations and their details.</p>
        </div>
        <Button onClick={() => handleOpenModal()} className="w-full md:w-auto">
          <Plus className="w-4 h-4 mr-2" />
          Add Destination
        </Button>
      </div>

      <div className="flex flex-col md:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input 
            placeholder="Search destinations..." 
            className="pl-10"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <Select value={categoryFilter} onValueChange={setCategoryFilter}>
          <SelectTrigger className="w-full md:w-[200px]">
            <SelectValue placeholder="All Categories" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            {categories.map(cat => (
              <SelectItem key={cat.id} value={cat.id}>{cat.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="border rounded-lg bg-card overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Location</TableHead>
              <TableHead>Category</TableHead>
              <TableHead>Price</TableHead>
              <TableHead>Rating</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {loading ? (
              Array(5).fill(0).map((_, i) => (
                <TableRow key={i}>
                  <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-24" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-20" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-16" /></TableCell>
                  <TableCell><Skeleton className="h-4 w-12" /></TableCell>
                  <TableCell className="text-right"><Skeleton className="h-8 w-8 ml-auto rounded-full" /></TableCell>
                </TableRow>
              ))
            ) : filteredDestinations.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="h-32 text-center text-muted-foreground">
                  No destinations found.
                </TableCell>
              </TableRow>
            ) : (
              filteredDestinations.map((dest) => (
                <TableRow key={dest.id}>
                  <TableCell className="font-medium">{dest.name}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-1 text-muted-foreground">
                      <MapPin className="w-3 h-3" />
                      {dest.location}
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{dest.categories?.name}</Badge>
                  </TableCell>
                  <TableCell>${dest.price}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-1">
                      <Star className="w-3 h-3 fill-yellow-400 text-yellow-400" />
                      {dest.rating.toFixed(1)}
                    </div>
                  </TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger className="inline-flex items-center justify-center rounded-md h-9 w-9 text-muted-foreground hover:bg-accent hover:text-accent-foreground outline-none">
                        <MoreHorizontal className="w-4 h-4" />
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => handleOpenModal(dest)}>
                          <Edit2 className="w-4 h-4 mr-2" />
                          Edit
                        </DropdownMenuItem>
                        <DropdownMenuItem 
                          className="text-destructive focus:text-destructive"
                          onClick={() => handleDelete(dest.id)}
                        >
                          <Trash2 className="w-4 h-4 mr-2" />
                          Delete
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

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle>{editingDestination ? 'Edit Destination' : 'Add Destination'}</DialogTitle>
            <DialogDescription>
              Fill in the details for the destination.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2 col-span-2">
                <Label htmlFor="name">Name</Label>
                <Input 
                  id="name" 
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  required 
                />
              </div>
              <div className="space-y-2 col-span-2">
                <Label htmlFor="location">Location</Label>
                <Input 
                  id="location" 
                  value={formData.location}
                  onChange={(e) => setFormData({...formData, location: e.target.value})}
                  required 
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="price">Price ($)</Label>
                <Input 
                  id="price" 
                  type="number"
                  value={formData.price}
                  onChange={(e) => setFormData({...formData, price: Number(e.target.value)})}
                  required 
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="category">Category</Label>
                <Select 
                  value={formData.category_id} 
                  onValueChange={(val) => setFormData({...formData, category_id: val})}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select category" />
                  </SelectTrigger>
                  <SelectContent>
                    {categories.map(cat => (
                      <SelectItem key={cat.id} value={cat.id}>{cat.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2 col-span-2">
                <Label htmlFor="description">Description</Label>
                <Input 
                  id="description" 
                  value={formData.description}
                  onChange={(e) => setFormData({...formData, description: e.target.value})}
                />
              </div>
              {!editingDestination && (
                <div className="space-y-2 col-span-2">
                  <Label htmlFor="image_url">Image URL</Label>
                  <Input 
                    id="image_url" 
                    placeholder="https://..."
                    value={formData.image_url}
                    onChange={(e) => setFormData({...formData, image_url: e.target.value})}
                  />
                </div>
              )}
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancel</Button>
              <Button type="submit" disabled={submitting}>
                {submitting ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : null}
                {editingDestination ? 'Update' : 'Create'}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
};

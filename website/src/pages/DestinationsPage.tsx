import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/src/lib/supabase';
import { Button } from '@/src/components/ui/button';
import { Input } from '@/src/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/src/components/ui/card';
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

import { cn } from '@/src/lib/utils';

// Internal component for optimized image loading
const DestinationImage = ({ src, alt }: { src: string; alt: string }) => {
  const [isLoaded, setIsLoaded] = useState(false);
  const [hasError, setHasError] = useState(false);

  const fallback = "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80";

  return (
    <div className="relative w-full h-full bg-muted overflow-hidden">
      {(!isLoaded && !hasError) && <Skeleton className="absolute inset-0 w-full h-full rounded-none" />}
      <img 
        src={hasError ? fallback : src} 
        alt={alt} 
        loading="lazy"
        decoding="async"
        onLoad={() => setIsLoaded(true)}
        onError={() => {
          setHasError(true);
          setIsLoaded(true);
        }}
        className={cn(
          "object-cover w-full h-full group-hover:scale-105 transition-[transform,opacity] duration-500 will-change-transform",
          isLoaded ? "opacity-100" : "opacity-0"
        )} 
      />
    </div>
  );
};

export const DestinationsPage = () => {
  const [destinations, setDestinations] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingDestination, setEditingDestination] = useState<any>(null);
  const [submitting, setSubmitting] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deletingId, setDeletingId] = useState<string | null>(null);

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
          .select('*, categories(name), destination_images(image_url)')
          .is('deleted_at', null)
          .order('created_at', { ascending: false })
          .limit(24), // Add limit for better performance
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
        image_url: destination.destination_images?.[0]?.image_url || ''
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

        if (formData.image_url) {
          const { data: existingImages } = await supabase
            .from('destination_images')
            .select('id')
            .eq('destination_id', editingDestination.id);
            
          if (existingImages && existingImages.length > 0) {
            await supabase
              .from('destination_images')
              .update({ image_url: formData.image_url })
              .eq('destination_id', editingDestination.id);
          } else {
            await supabase
              .from('destination_images')
              .insert([{ destination_id: editingDestination.id, image_url: formData.image_url }]);
          }
        }

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

  const handleDeleteConfirm = async () => {
    if (!deletingId) return;

    try {
      setSubmitting(true);
      const { error } = await supabase
        .from('destinations')
        .update({ deleted_at: new Date().toISOString() })
        .eq('id', deletingId);

      if (error) throw error;
      toast.success('Destination deleted successfully');
      setDeletingId(null);
      setIsDeleteModalOpen(false);
      fetchData();
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setSubmitting(false);
    }
  };

  const filteredDestinations = useMemo(() => {
    return destinations.filter(dest => {
      const matchesSearch = dest.name.toLowerCase().includes(search.toLowerCase()) || 
                           dest.location.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = categoryFilter === 'all' || dest.category_id === categoryFilter;
      return matchesSearch && matchesCategory;
    });
  }, [destinations, search, categoryFilter]);

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

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {loading ? (
          Array(8).fill(0).map((_, i) => (
            <Card key={i} className="flex flex-col overflow-hidden">
              <Skeleton className="h-48 w-full rounded-none" />
              <CardHeader className="p-4 pb-2">
                <Skeleton className="h-5 w-3/4 mb-2" />
                <Skeleton className="h-4 w-1/2" />
              </CardHeader>
              <CardContent className="p-4 pt-0">
                <Skeleton className="h-4 w-1/4" />
              </CardContent>
            </Card>
          ))
        ) : filteredDestinations.length === 0 ? (
          <div className="col-span-full h-64 flex flex-col items-center justify-center text-muted-foreground border rounded-lg bg-card border-dashed">
            <p>No destinations found.</p>
          </div>
        ) : (
          filteredDestinations.map((dest) => {
            // Check if there are images and fallback if not
            const imageUrl = dest.destination_images && dest.destination_images.length > 0 
              ? dest.destination_images[0].image_url 
              : 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80';
              
            return (
              <Card key={dest.id} className="flex flex-col overflow-hidden group hover:shadow-md transition-all">
                <div className="relative h-48 overflow-hidden bg-muted">
                  <DestinationImage src={imageUrl} alt={dest.name} />
                  <div className="absolute top-2 right-2 flex gap-1">
                    <Badge className="bg-background/80 text-foreground backdrop-blur-sm shadow-sm hover:bg-background/90 text-xs">
                      {dest.categories?.name || 'Uncategorized'}
                    </Badge>
                  </div>
                  <div className="absolute top-2 left-2">
                    <DropdownMenu>
                      <DropdownMenuTrigger className="inline-flex items-center justify-center rounded-full bg-background/80 backdrop-blur-sm shadow-sm h-8 w-8 text-foreground hover:bg-accent hover:text-accent-foreground outline-none">
                        <MoreHorizontal className="w-4 h-4" />
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="start">
                        <DropdownMenuItem onClick={() => handleOpenModal(dest)}>
                          <Edit2 className="w-4 h-4 mr-2" />
                          Edit
                        </DropdownMenuItem>
                        <DropdownMenuItem 
                          className="text-destructive focus:text-destructive"
                          onClick={() => {
                            setDeletingId(dest.id);
                            setIsDeleteModalOpen(true);
                          }}
                        >
                          <Trash2 className="w-4 h-4 mr-2" />
                          Delete
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>
                </div>
                <CardHeader className="p-4 pb-2">
                  <div className="flex justify-between items-start gap-2">
                    <CardTitle className="text-lg leading-tight line-clamp-1" title={dest.name}>
                      {dest.name}
                    </CardTitle>
                    <div className="flex items-center gap-1 shrink-0 text-sm font-semibold whitespace-nowrap bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400 px-2 py-0.5 rounded-full">
                      ${dest.price}
                    </div>
                  </div>
                  <div className="flex items-center gap-1 text-sm text-muted-foreground mt-1" title={dest.location}>
                    <MapPin className="w-3.5 h-3.5 shrink-0" />
                    <span className="line-clamp-1">{dest.location}</span>
                  </div>
                </CardHeader>
                <CardContent className="p-4 pt-0 flex-1 flex flex-col justify-end">
                  <div className="flex items-center justify-between mt-auto pt-4 text-sm border-t border-border/50">
                    <div className="flex items-center gap-1 text-muted-foreground">
                      <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                      <span className="font-medium text-foreground">{dest.rating?.toFixed(1) || '0.0'}</span>
                      <span className="text-xs ml-0.5">(Reviews)</span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })
        )}
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
                    <SelectValue placeholder="Select category">
                      {categories.find(c => c.id === formData.category_id)?.name}
                    </SelectValue>
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
              <div className="space-y-2 col-span-2">
                <Label htmlFor="image_url">Image URL</Label>
                <Input 
                  id="image_url" 
                  placeholder="https://..."
                  value={formData.image_url}
                  onChange={(e) => setFormData({...formData, image_url: e.target.value})}
                />
              </div>
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

      <Dialog open={isDeleteModalOpen} onOpenChange={setIsDeleteModalOpen}>
        <DialogContent className="sm:max-w-[400px]">
          <DialogHeader>
            <DialogTitle>Delete Destination</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this destination? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter className="pt-4">
            <Button type="button" variant="outline" onClick={() => setIsDeleteModalOpen(false)}>
              Cancel
            </Button>
            <Button type="button" variant="destructive" onClick={handleDeleteConfirm} disabled={submitting}>
              {submitting ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : null}
              Delete
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

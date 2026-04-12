export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          name: string
          email: string
          phone: string | null
          profile_picture: string | null
          language: string
          is_dark_mode: boolean
          role: 'admin' | 'user'
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id: string
          name: string
          email: string
          phone?: string | null
          profile_picture?: string | null
          language?: string
          is_dark_mode?: boolean
          role?: 'admin' | 'user'
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          name?: string
          email?: string
          phone?: string | null
          profile_picture?: string | null
          language?: string
          is_dark_mode?: boolean
          role?: 'admin' | 'user'
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      categories: {
        Row: {
          id: string
          name: string
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          name: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          name?: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      destinations: {
        Row: {
          id: string
          name: string
          location: string
          description: string | null
          price: number
          rating: number
          category_id: string
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          name: string
          location: string
          description?: string | null
          price: number
          rating?: number
          category_id: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          name?: string
          location?: string
          description?: string | null
          price?: number
          rating?: number
          category_id?: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      destination_images: {
        Row: {
          id: string
          destination_id: string
          image_url: string
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          destination_id: string
          image_url: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          destination_id?: string
          image_url?: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      bookings: {
        Row: {
          id: string
          user_id: string
          destination_id: string
          booking_date: string
          visit_date: string
          total_price: number
          status: 'pending' | 'paid' | 'cancelled'
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          user_id: string
          destination_id: string
          booking_date?: string
          visit_date: string
          total_price: number
          status?: 'pending' | 'paid' | 'cancelled'
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          user_id?: string
          destination_id?: string
          booking_date?: string
          visit_date?: string
          total_price?: number
          status?: 'pending' | 'paid' | 'cancelled'
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      payments: {
        Row: {
          id: string
          booking_id: string
          payment_method: string
          amount: number
          status: 'pending' | 'success' | 'failed'
          paid_at: string | null
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          booking_id: string
          payment_method: string
          amount: number
          status?: 'pending' | 'success' | 'failed'
          paid_at?: string | null
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          booking_id?: string
          payment_method?: string
          amount?: number
          status?: 'pending' | 'success' | 'failed'
          paid_at?: string | null
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      wishlists: {
        Row: {
          id: string
          user_id: string
          destination_id: string
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          user_id: string
          destination_id: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          user_id?: string
          destination_id?: string
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
      reviews: {
        Row: {
          id: string
          user_id: string
          destination_id: string
          rating: number
          comment: string | null
          created_at: string
          updated_at: string
          deleted_at: string | null
        }
        Insert: {
          id?: string
          user_id: string
          destination_id: string
          rating: number
          comment?: string | null
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
        Update: {
          id?: string
          user_id?: string
          destination_id?: string
          rating?: number
          comment?: string | null
          created_at?: string
          updated_at?: string
          deleted_at?: string | null
        }
      }
    }
  }
}

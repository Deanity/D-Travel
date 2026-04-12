import { User, Session } from '@supabase/supabase-js';

// Mock data stored in localStorage
const STORAGE_KEY = 'dtravel_mock_data';

const getInitialData = () => {
  const saved = localStorage.getItem(STORAGE_KEY);
  if (saved) return JSON.parse(saved);

  return {
    users: [
      { id: 'mock-admin-id', name: 'Admin User', email: 'admin@example.com', role: 'admin', created_at: new Date().toISOString() }
    ],
    categories: [
      { id: '1', name: 'Beach', created_at: new Date().toISOString() },
      { id: '2', name: 'Mountain', created_at: new Date().toISOString() },
      { id: '3', name: 'City', created_at: new Date().toISOString() }
    ],
    destinations: [
      { id: '1', name: 'Bali', location: 'Indonesia', description: 'Tropical paradise', price: 1200, rating: 4.8, category_id: '1', created_at: new Date().toISOString() },
      { id: '2', name: 'Swiss Alps', location: 'Switzerland', description: 'Snowy peaks', price: 2500, rating: 4.9, category_id: '2', created_at: new Date().toISOString() }
    ],
    bookings: [],
    reviews: []
  };
};

let mockData = getInitialData();

const saveData = () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(mockData));
};

export const mockSupabase = {
  auth: {
    getSession: async () => {
      const session = JSON.parse(localStorage.getItem('mock_session') || 'null');
      return { data: { session }, error: null };
    },
    onAuthStateChange: (callback: any) => {
      const session = JSON.parse(localStorage.getItem('mock_session') || 'null');
      // Simulate initial call
      setTimeout(() => callback('SIGNED_IN', session), 0);
      return { data: { subscription: { unsubscribe: () => {} } } };
    },
    signInWithPassword: async ({ email, password }: any) => {
      if (email === 'admin@example.com' && password === 'admin123') {
        const user = mockData.users[0];
        const session = { user, access_token: 'mock-token', expires_in: 3600 };
        localStorage.setItem('mock_session', JSON.stringify(session));
        return { data: { user, session }, error: null };
      }
      return { data: { user: null, session: null }, error: { message: 'Invalid credentials. Use admin@example.com / admin123' } };
    },
    signOut: async () => {
      localStorage.removeItem('mock_session');
      return { error: null };
    }
  },
  from: (table: string) => ({
    select: (query: string = '*') => ({
      eq: (column: string, value: any) => ({
        single: async () => {
          const item = mockData[table]?.find((i: any) => i[column] === value);
          return { data: item || null, error: item ? null : { message: 'Not found' } };
        },
        order: (col: string, { ascending }: any) => ({
          limit: async (n: number) => {
            const items = mockData[table]
              ?.filter((i: any) => i[column] === value)
              .sort((a: any, b: any) => ascending ? (a[col] > b[col] ? 1 : -1) : (a[col] < b[col] ? 1 : -1))
              .slice(0, n);
            return { data: items || [], error: null };
          }
        }),
        async: async () => {
          const items = mockData[table]?.filter((i: any) => i[column] === value);
          return { data: items || [], error: null };
        }
      }),
      order: (col: string, { ascending }: any) => ({
        limit: async (n: number) => {
          const items = [...(mockData[table] || [])]
            .sort((a: any, b: any) => ascending ? (a[col] > b[col] ? 1 : -1) : (a[col] < b[col] ? 1 : -1))
            .slice(0, n);
          return { data: items || [], error: null };
        },
        async: async () => {
          const items = [...(mockData[table] || [])]
            .sort((a: any, b: any) => ascending ? (a[col] > b[col] ? 1 : -1) : (a[col] < b[col] ? 1 : -1));
          return { data: items || [], error: null };
        }
      }),
      async: async () => {
        return { data: mockData[table] || [], error: null };
      }
    }),
    insert: (data: any) => ({
      select: () => ({
        single: async () => {
          const newItem = { ...data, id: Math.random().toString(36).substr(2, 9), created_at: new Date().toISOString() };
          mockData[table].push(newItem);
          saveData();
          return { data: newItem, error: null };
        }
      })
    }),
    update: (data: any) => ({
      eq: (column: string, value: any) => ({
        async: async () => {
          mockData[table] = mockData[table].map((i: any) => i[column] === value ? { ...i, ...data, updated_at: new Date().toISOString() } : i);
          saveData();
          return { data: null, error: null };
        }
      })
    }),
    delete: () => ({
      eq: (column: string, value: any) => ({
        async: async () => {
          // Soft delete
          mockData[table] = mockData[table].map((i: any) => i[column] === value ? { ...i, deleted_at: new Date().toISOString() } : i);
          saveData();
          return { data: null, error: null };
        }
      })
    })
  })
} as any;

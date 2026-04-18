import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'listTrip/myTrip.dart';
import 'whishlist/wishList.dart';
import 'profile/profile.dart';
import 'details/placeCover.dart';
import 'search/search.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  List<String> _favoriteCategories = [];
  bool _isLoading = true;
  String _userName = "Traveler";

  int _selectedCategoryIndex = 0;
  final List<Map<String, String>> _categories = [
    {'icon': '❤️', 'label': 'All'},
    {'icon': '🏝️', 'label': 'Beach'},
    {'icon': '🗻', 'label': 'Mountain'},
    {'icon': '🌲', 'label': 'Forest'},
    {'icon': '🌊', 'label': 'Ocean'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = Supabase.instance.client.auth.currentUser;
    
    setState(() {
      _favoriteCategories = prefs.getStringList('favorite_places') ?? [];
      if (user != null && user.userMetadata != null) {
        _userName = user.userMetadata!['first_name'] ?? "Traveler";
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=pristia'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Hello, $_userName!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none_rounded, size: 28),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Headline
                const Text(
                  'Where do you\nwant to explore today?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                // Search Bar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) => const SearchScreen(),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Search destination',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.search, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Choose Category
                _buildSectionHeader('Choose Category', 'See All'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: _buildCategoryItem(
                          _categories[index]['icon']!,
                          _categories[index]['label']!,
                          isSelected: _selectedCategoryIndex == index,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Favorite Place
                _buildSectionHeader('Favorite Place', 'Explore'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildFavoriteCard(
                        'Kuta Beach',
                        'Bali, Indonesia',
                        '4.8',
                        'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=400&q=80',
                      ),
                      _buildFavoriteCard(
                        'Bromo Mountain',
                        'Jawa Ti, Indonesia',
                        '4.0',
                        'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=400&q=80',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Popular Package
                _buildSectionHeader('Popular Package', 'See All'),
                const SizedBox(height: 16),
                _buildPackageCard(
                  'Kuta Resort',
                  '745,00',
                  '4.8',
                  'A resort is a place used for vacation, relaxation or as a day...',
                  'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=400&q=80',
                ),
                _buildPackageCard(
                  'Jepara Resort',
                  '545,00',
                  '4.8',
                  'A resort is a place used for vacation, relaxation or as a day...',
                  'https://images.unsplash.com/photo-1540541338287-41700207dee6?auto=format&fit=crop&w=400&q=80',
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          action,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String icon, String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFCD240) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
              color: isSelected ? Colors.black : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(String name, String location, String rating, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceCoverScreen(
              name: name,
              location: location,
              rating: rating,
              imageUrl: imageUrl,
              price: '245.00',
              description: 'Bali is an island in Indonesia known for its verdant volcanoes, unique rice terraces, beaches, and beautiful coral reefs. Before becoming a tourist attraction, Kuta was a trading port where local products were traded.',
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const SizedBox(height: 120),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                    ),
                  ),
                ],
              ),
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Text(location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const Icon(Icons.star_half, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(String name, String price, String rating, String desc, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceCoverScreen(
              name: name,
              location: 'Indonesia',
              rating: rating,
              imageUrl: imageUrl,
              price: price,
              description: desc,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imageUrl, width: 90, height: 90, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.favorite_border, color: Colors.grey.shade400, size: 20),
                    ],
                  ),
                  Text(
                    '\$$price',
                    style: const TextStyle(color: Color(0xFFFCD240), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home – selected (pill highlight)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.home_filled, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // My Trip
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const MyTripScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.near_me_outlined, color: Colors.grey.shade400, size: 26),
          ),

          // Wishlist
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const WishListScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.favorite_border_rounded, color: Colors.grey.shade400, size: 26),
          ),

          // Profile
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const ProfileScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.person_outline_rounded, color: Colors.grey.shade400, size: 26),
          ),
        ],
      ),
    );
  }
}

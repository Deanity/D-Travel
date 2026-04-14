import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  List<String> _favoritePlaces = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _allDestinations = [
    {
      'name': 'Mount Bromo',
      'location': 'East Java, Indonesia',
      'category': 'Mountain',
      'rating': 4.9,
      'price': 150,
      'image': '🗻',
    },
    {
      'name': 'Kuta Beach',
      'location': 'Bali, Indonesia',
      'category': 'Beach',
      'rating': 4.7,
      'price': 120,
      'image': '🏝️',
    },
    {
      'name': 'Raja Ampat',
      'location': 'West Papua, Indonesia',
      'category': 'Ocean',
      'rating': 5.0,
      'price': 450,
      'image': '🌊',
    },
    {
      'name': 'Ubud Forest',
      'location': 'Bali, Indonesia',
      'category': 'Forest',
      'rating': 4.8,
      'price': 180,
      'image': '🌲',
    },
    {
      'name': 'Lake Toba',
      'location': 'North Sumatra, Indonesia',
      'category': 'Ocean',
      'rating': 4.6,
      'price': 200,
      'image': '🌊',
    },
    {
      'name': 'Ijen Crater',
      'location': 'East Java, Indonesia',
      'category': 'Mountain',
      'rating': 4.8,
      'price': 130,
      'image': '🗻',
    },
    {
      'name': 'Komodo Island',
      'location': 'East Nusa Tenggara',
      'category': 'Beach',
      'rating': 4.9,
      'price': 300,
      'image': '🏝️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritePlaces = prefs.getStringList('favorite_places') ?? [];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _recommendedDestinations {
    if (_favoritePlaces.isEmpty) return _allDestinations;
    return _allDestinations.where((dest) => _favoritePlaces.contains(dest['category'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Traveler 👋',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        'DTravel',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade400),
                    const SizedBox(width: 12),
                    Text(
                      'Search destination...',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories Based on Favorites
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _favoritePlaces.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD240),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _favoritePlaces[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Recommended Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended For You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Recommendation Grid
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final destination = _recommendedDestinations[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F0F0),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      destination['image'],
                                      style: const TextStyle(fontSize: 50),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      destination['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            destination['location'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${destination['price']}',
                                          style: const TextStyle(
                                            color: Color(0xFFFCD240),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                                            Text(
                                              ' ${destination['rating']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: _recommendedDestinations.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home_filled, color: Color(0xFFFCD240)),
            Icon(Icons.explore_outlined, color: Colors.white),
            Icon(Icons.favorite_border_rounded, color: Colors.white),
            Icon(Icons.person_outline_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

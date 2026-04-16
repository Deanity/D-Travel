import 'package:flutter/material.dart';
import '../homepage.dart';
import '../whishlist/wishList.dart';
import '../profile/profile.dart';

class MyTripScreen extends StatefulWidget {
  const MyTripScreen({super.key});

  @override
  State<MyTripScreen> createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample trip data
  final List<Map<String, dynamic>> _trips = [
    {
      'name': 'Kuta Beach',
      'price': '\$1,450.00',
      'startDate': '13 Jun 2021',
      'endDate': '15 Jun 2021',
    },
    {
      'name': 'Kuta Resort',
      'price': '\$145.00',
      'startDate': '13 Jun 2021',
      'endDate': '15 Jun 2021',
    },
    {
      'name': 'Bromo Mountain',
      'price': '\$880.00',
      'startDate': '20 Jul 2021',
      'endDate': '23 Jul 2021',
    },
    {
      'name': 'Jepara Resort',
      'price': '\$320.00',
      'startDate': '05 Aug 2021',
      'endDate': '08 Aug 2021',
    },
  ];

  List<Map<String, dynamic>> get _filteredTrips {
    if (_searchQuery.isEmpty) return _trips;
    return _trips
        .where((t) =>
            t['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),

            // ── Title ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'List Your Trip',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search destination',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.search, color: Colors.grey.shade700, size: 22),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Trip List ──
            Expanded(
              child: _filteredTrips.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredTrips.length,
                      itemBuilder: (context, index) {
                        final trip = _filteredTrips[index];
                        return _buildTripCard(
                          name: trip['name'],
                          price: trip['price'],
                          startDate: trip['startDate'],
                          endDate: trip['endDate'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTripCard({
    required String name,
    required String price,
    required String startDate,
    required String endDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Price
          Text(
            price,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE85D25),
            ),
          ),
          const SizedBox(height: 10),

          // Date range
          Row(
            children: [
              Icon(Icons.calendar_month_outlined,
                  size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                '$startDate - $endDate',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.near_me_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No trips found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different destination name',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation Bar (consistent with homepage.dart) ──
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
          // Home – not selected
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const HomepageScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.home_outlined, color: Colors.grey.shade400, size: 26),
          ),

          // My Trip – selected (pill highlight)
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.near_me_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'My Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Wishlist – not selected
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
            child: Icon(Icons.favorite_border_rounded,
                color: Colors.grey.shade400, size: 26),
          ),

          // Profile – not selected
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
            child: Icon(Icons.person_outline_rounded,
                color: Colors.grey.shade400, size: 26),
          ),
        ],
      ),
    );
  }
}

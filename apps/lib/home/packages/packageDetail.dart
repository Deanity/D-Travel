import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking/detailBooking.dart';
import '../details/bookingDatePicker.dart';

class PackageDetailScreen extends StatefulWidget {
  final Map<String, dynamic> packageData;

  const PackageDetailScreen({super.key, required this.packageData});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final List<Map<String, dynamic>> _itinerary = [
    {
      'day': 'Day 1',
      'title': 'Arrival & Beach Sunset',
      'description': 'Arrival at International Airport, meeting service and transfer to hotel. Enjoy sunset at Jimbaran Beach.',
      'icon': Icons.flight_land_rounded,
    },
    {
      'day': 'Day 2',
      'title': 'Cultural Journey',
      'description': 'Visit Barong Dance performance, Ubud Art Market, and Tegalalang Rice Terrace.',
      'icon': Icons.temple_hindu_rounded,
    },
    {
      'day': 'Day 3',
      'title': 'Water Activity & Departure',
      'description': 'Tanjung Benoa water sports and transfer back to airport for your flight home.',
      'icon': Icons.surfing_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildIncludedRow(),
                      const SizedBox(height: 32),
                      _buildDescription(),
                      const SizedBox(height: 32),
                      _buildItinerary(),
                      const SizedBox(height: 32),
                      _buildIncludeExclude(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: Colors.black, size: 20),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.packageData['id'],
              child: Image.network(
                widget.packageData['image'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFCD240),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.packageData['badge'] ?? widget.packageData['duration'],
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFCD240), size: 22),
                const SizedBox(width: 4),
                Text(
                  widget.packageData['rating'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                Text(' / 5.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.packageData['title'],
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 16),
            const SizedBox(width: 4),
            Text(
              'Bali, Indonesia', // Placeholder
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncludedRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What\'s Included?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _includedChip(Icons.hotel_rounded, 'Hotel 4*'),
              _includedChip(Icons.restaurant_rounded, 'Meals'),
              _includedChip(Icons.directions_car_rounded, 'Transport'),
              _includedChip(Icons.person_pin_rounded, 'Local Guide'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _includedChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFCD240), size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About This Package', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          'Experience the best of Bali with this carefully curated package. From the serene rice fields of Ubud to the vibrant sunsets of Jimbaran, every moment is designed for your comfort and enjoyment. This package includes premium accommodation and private transportation.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.7),
        ),
      ],
    );
  }

  Widget _buildItinerary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Itinerary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ..._itinerary.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCD240),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'], color: Colors.black, size: 20),
                  ),
                  if (item != _itinerary.last)
                    Container(
                      width: 2,
                      height: 60,
                      color: Colors.grey.shade100,
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['day'].toUpperCase(),
                      style: const TextStyle(color: Color(0xFFE85D25), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['description'],
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildIncludeExclude() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _checkListSection('Includes', [
            'Hotel 4 Stars Accommodation',
            'Daily Breakfast & Dinner',
            'Professional Tour Guide',
            'Entrance Fees to all attractions',
          ], true),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 24),
          _checkListSection('Excludes', [
            'International Flight Tickets',
            'Personal Expenses & Laundry',
            'Travel Insurance',
          ], false),
        ],
      ),
    );
  }

  Widget _checkListSection(String title, List<String> items, bool isInclude) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                isInclude ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isInclude ? Colors.green : Colors.redAccent,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(item, style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Price per person', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  'Rp ${widget.packageData['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFE85D25),
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _showDatePicker(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCD240),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BookingDatePicker(),
    );

    if (result != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DetailBookingScreen(),
        ),
      );
    }
  }
}

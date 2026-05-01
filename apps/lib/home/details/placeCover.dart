import 'package:flutter/material.dart';
import 'dart:async';

import 'bookingDatePicker.dart';
import '../booking/detailBooking.dart';


class PlaceCoverScreen extends StatefulWidget {
  final String name;
  final String location;
  final String description;
  final String rating;
  final String price;
  final String imageUrl;

  const PlaceCoverScreen({
    super.key,
    this.name = 'Kuta Beach',
    this.location = 'Bali, Indonesia',
    this.description =
        'Bali is an island in Indonesia known for its verdant volcanoes, unique rice terraces, beaches, and beautiful coral reefs. Before becoming a tourist attraction, Kuta was a trading port where local products were traded to buyers from outside Bali.',
    this.rating = '4,8',
    this.price = '245.00',
    this.imageUrl =
        'lib/assets/home/kutaBeach.png',
  });

  @override
  State<PlaceCoverScreen> createState() => _PlaceCoverScreenState();
}

class _PlaceCoverScreenState extends State<PlaceCoverScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomBar = false;
  bool _isScrolled = false;

  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  Timer? _timer;
  late final List<String> _galleryImages;

  @override
  void initState() {
    super.initState();
    _galleryImages = [
      'lib/assets/detailPage/Showcase1.png',
      'lib/assets/detailPage/Showcase2.png',
      'lib/assets/detailPage/Showcase3.png',
    ];
    _scrollController.addListener(_onScroll);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentImageIndex < _galleryImages.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentImageIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      final showBar = offset > MediaQuery.of(context).size.height * 0.4;
      if (showBar != _showBottomBar) {
        setState(() {
          _showBottomBar = showBar;
        });
      }
      final scrolled = offset > 50;
      if (scrolled != _isScrolled) {
        setState(() {
          _isScrolled = scrolled;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 2,
                elevation: 0,
                shadowColor: Colors.black.withOpacity(0.3),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                title: AnimatedOpacity(
                  opacity: _showBottomBar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.favorite,
                      color: Colors.black),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image Gallery
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: _galleryImages.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            _galleryImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.9),
                              ],
                              stops: const [0.0, 0.3, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Bottom Content of Cover
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: _buildCoverContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Detail Content below cover
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildDetailContent(),
                ),
              ),
            ],
          ),

          // Floating Bottom Bar logic from PlaceDetail
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showBottomBar ? 0 : -100,
            left: 0,
            right: 0,
            child: _buildFloatingBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Favorite Label
        Row(
          children: [
            const Text(
              'FAVORITE PLACE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFFFCD240),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 10, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Location
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              widget.location,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Reviewers Count & Avatars
        Row(
          children: [
            const Text(
              '100+ people have explored',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const Spacer(),
            _buildOverlappingAvatars(),
          ],
        ),
        const SizedBox(height: 16),

        // Progress Lines
        Row(
          children: List.generate(_galleryImages.length, (index) {
            return Expanded(
              child: Container(
                height: 2,
                margin: EdgeInsets.only(
                    right: index == _galleryImages.length - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Description
        Text(
          widget.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // Rating & Arrow Function
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFFCD240), size: 20),
            const SizedBox(width: 6),
            Text(
              widget.rating,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_downward, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 32),


      ],
    );
  }

  Widget _buildDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        // What's Included?
        const Text(
          'What\'s Included?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildIncludedChip(Icons.flight_takeoff_outlined, 'Flight'),
              _buildIncludedChip(Icons.hotel_outlined, 'Hotel'),
              _buildIncludedChip(Icons.directions_car_outlined, 'Transport'),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // About Trip
        const Text(
          'About Trip',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          widget.description,
          style:
              TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
        ),
        const SizedBox(height: 12),
        Text(
          'See beautiful Bali and help us keep it that way by joining this EcoTour of a Bali village. All proceeds from the EcoTour are donated to the Tangkas Village Recycling Center.',
          style:
              TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
        ),
        const SizedBox(height: 32),

        // Gallery Photo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gallery Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('See All',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildGalleryImage('lib/assets/detailPage/gallery/image1.png'),
            const SizedBox(width: 12),
            _buildGalleryImage('lib/assets/detailPage/gallery/image3.png'),
            const SizedBox(width: 12),
            _buildGalleryMore('lib/assets/detailPage/gallery/image2.png', '+20'),
          ],
        ),
        const SizedBox(height: 32),

        // Location
        const Text('Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/DummyMaps.png'), 
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on,
                        color: Color(0xFFFCD240), size: 28),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.remove, size: 20, color: Colors.black87),
                        ),
                        Container(height: 1, width: 24, color: Colors.grey.shade100),
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.add, size: 20, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Reviews
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Review (99)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(widget.rating,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewItem('Yelena Belova', 'https://i.pravatar.cc/150?u=yelena',
            'Today', 'Pretty nice. The entrance is quite far from the parking lot but wouldnt be much of a problem if it wasnt raining. Love the interior :)'),
        _buildReviewItem('Mark Travor', 'https://i.pravatar.cc/150?u=mark',
            'Today', 'A really great place and amazing work place. I really love staying there! Will definitely come back!'),

        const SizedBox(height: 120), // For bottom floating bar
      ],
    );
  }

  Widget _buildFloatingBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '\$${widget.price} ',
                  style: const TextStyle(
                      color: Color(0xFFE85D25),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '/Person',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: const BookingDatePicker(),
                ),
              );
              if (result != null && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBookingScreen(
                      bookingData: {
                        'destinationName': widget.name,
                        'destinationImage': widget.imageUrl,
                        'startDate': result['start'],
                        'endDate': result['end'],
                      },
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCD240),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Book Now',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String url) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(url, height: 80, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildGalleryMore(String url, String count) {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(url,
                height: 80, width: double.infinity, fit: BoxFit.cover),
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
                child: Text(count,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 20, color: Colors.grey),
    );
  }

  Widget _buildReviewItem(
      String name, String avatar, String date, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(
                          5,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 14)),
                    ),
                  ],
                ),
              ),
              Text(date,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildOverlappingAvatars() {
    final avatars = [
      'https://i.pravatar.cc/150?img=11',
      'https://i.pravatar.cc/150?img=12',
      'https://i.pravatar.cc/150?img=32',
      'https://i.pravatar.cc/150?img=41',
    ];

    double overlap = 18.0;
    double radius = 14.0;

    return SizedBox(
      width: (radius * 2) + (avatars.length - 1) * overlap,
      height: radius * 2,
      child: Stack(
        children: [
          // Render in reverse to have the leftmost visually on top
          for (int i = avatars.length - 1; i >= 0; i--)
            Positioned(
              left: i * overlap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black45, width: 1.5),
                ),
                child: CircleAvatar(
                  radius: radius,
                  backgroundImage: NetworkImage(avatars[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

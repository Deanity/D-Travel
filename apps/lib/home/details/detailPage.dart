import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String name;
  final String location;
  final String description;
  final String rating;
  final String price;
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.deepOrangeAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Top Destination Card (The one from the image)
                _buildTopImageCard(),
                
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
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                ),
                const SizedBox(height: 12),
                Text(
                  'See beautiful Bali and help us keep it that way by joining this EcoTour of a Bali village. All proceeds from the EcoTour are donated to the Tangkas Village Recycling Center.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                ),
                const SizedBox(height: 32),

                // Gallery Photo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gallery Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('See All', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildGalleryImage('https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=200&q=80'),
                    const SizedBox(width: 12),
                    _buildGalleryImage('https://images.unsplash.com/photo-1518548419970-58e3b4079830?auto=format&fit=crop&w=200&q=80'),
                    const SizedBox(width: 12),
                    _buildGalleryMore('https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=200&q=80', '+20'),
                  ],
                ),
                const SizedBox(height: 32),

                // Location
                const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://miro.medium.com/v2/resize:fit:1400/1*q61Sfy8A6o5zP_y7qOkJpw.png'), // Placeholder Map
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xFFFCD240), shape: BoxShape.circle),
                            child: const Icon(Icons.location_on, color: Colors.black, size: 24),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            children: [
                              _buildMapControl(Icons.add),
                              const SizedBox(height: 8),
                              _buildMapControl(Icons.remove),
                            ],
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
                    const Text('Review (99)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                         const Icon(Icons.star, color: Colors.amber, size: 20),
                         const SizedBox(width: 4),
                         Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildReviewItem('Yelena Belova', 'https://i.pravatar.cc/150?u=yelena', 'Today', 'Pretty nice. The entrance is quite far from the parking lot but wouldnt be much of a problem if it wasnt raining. Love the interior :)'),
                _buildReviewItem('Mark Travor', 'https://i.pravatar.cc/150?u=mark', 'Today', 'A really great place and amazing work place. I really love staying there! Will definitely come back!'),
                
                const SizedBox(height: 120), // For bottom bar
              ],
            ),
          ),

          // Bottom Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$$price ',
                          style: const TextStyle(color: Color(0xFFE85D25), fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '/Person',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCD240),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopImageCard() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFFCD240), shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 12, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('100+ people have explored', style: TextStyle(color: Colors.white, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
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
        child: Image.network(url, height: 80, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildGalleryMore(String url, String count) {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(url, height: 80, width: double.infinity, fit: BoxFit.cover),
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 20, color: Colors.grey),
    );
  }

  Widget _buildReviewItem(String name, String avatar, String date, String comment) {
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
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 14)),
                    ),
                  ],
                ),
              ),
              Text(date, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
        ],
      ),
    );
  }
}

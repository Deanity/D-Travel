import 'package:flutter/material.dart';
import '../auth/login/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "https://i.pinimg.com/736x/ca/b2/f1/cab2f1c998bd454613d9b48eed8e70fc.jpg",
      "title": "Lets explore\nthe world",
      "subtitle": "let's explore the world with us with just a\nfew clicks"
    },
    {
      "image": "https://i.pinimg.com/736x/ee/ca/d2/eecad2477524d48452f28c88e0230c61.jpg",
      "title": "Visit tourist\nattractions",
      "subtitle": "Find thousands of tourist destinations\nready for you to visit"
    },
    {
      "image": "https://i.pinimg.com/1200x/08/cc/60/08cc60e6fdaee7f2f7874fb720601eb2.jpg",
      "title": "Get ready for\nnext trip",
      "subtitle": "Find thousands of tourist destinations\nready for you to visit"
    },
  ];

  Widget _buildLogo() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Text(
          'DTravel',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Positioned(
          top: 2,
          left: 50, // Menyesuaikan letak titik dengan panjang DTravel
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFFCD240),
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Images Slider
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    onboardingData[index]["image"]!,
                    fit: BoxFit.cover,
                    // Tambahan loading builder agar smooth saat load gambar
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFCD240),
                        ),
                      );
                    },
                  ),
                  // Dark Gradient Overlay untuk teks agar terbaca dengan jelas
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Logo di sudut kiri atas
          Positioned(
            top: 64, // Memperhitungkan status bar
            left: 24,
            child: _buildLogo(),
          ),

          // Konten Title, Subtitle, Progress, dan Button di bawah
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  onboardingData[_currentPage]["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  onboardingData[_currentPage]["subtitle"]!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Progress Bar Indikator (Garis 3 Segmen)
                Row(
                  children: List.generate(
                    onboardingData.length,
                    (index) => Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: index == onboardingData.length - 1 ? 0 : 8),
                        height: 3,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Button Next / Get Started
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCD240),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == onboardingData.length - 1 ? "Get Started" : "Next",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

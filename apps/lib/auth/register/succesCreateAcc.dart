import 'package:flutter/material.dart';
import 'favoriteExplore.dart';

class SuccessCreateAccScreen extends StatelessWidget {
  const SuccessCreateAccScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // Ikon Custom - Dibangun berlapis mirip logo pin peta di sketch Anda
              Center(
                child: SizedBox(
                   width: 180,
                   height: 180,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       // Ikon Map Pin
                       const Positioned(
                         top: 30, // Geser ke atas agar tidak bentrok dengan elips
                         child: Icon(
                           Icons.location_on, 
                           size: 110,
                           color: Color(0xFFFCD240), // Bagian kuning dalamnya
                         ),
                       ),
                       const Positioned(
                         top: 30,
                         child: Icon(
                           Icons.location_on_outlined,
                           size: 110,
                           color: Colors.black, // Pinggiran pin lokasi tebal
                         ),
                       ),
                       // Bolong jarum hitam kecil dalam Pin
                       Positioned(
                         top: 60,
                         child: Container(
                           width: 25,
                           height: 25,
                           decoration: const BoxDecoration(
                             color: Colors.black,
                             shape: BoxShape.circle,
                           ),
                         ),
                       ),
                       // Hiasan Bintang/Sparkle Kanan Atas
                       const Positioned(
                         top: 25,
                         right: 40,
                         child: Icon(Icons.circle_outlined, color: Color(0xFFFCD240), size: 14),
                       ),
                       // Hiasan Plus Kiri Tengah
                       const Positioned(
                         left: 30,
                         top: 70,
                         child: Icon(Icons.add, color: Color(0xFFFCD240), size: 18),
                       ),
                     ],
                   ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Judul Utama Sukses
              const Text(
                'Successfully created an\naccount',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // Keterangan Subtitle
              Text(
                'After this you can explore any place you\nwant. enjoy it!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Tombol Mulai Jelajah
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteExploreScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCD240),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Let's Explore!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

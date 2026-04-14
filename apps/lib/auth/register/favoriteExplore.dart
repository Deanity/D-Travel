import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/homepage.dart';

class FavoriteExploreScreen extends StatefulWidget {
  const FavoriteExploreScreen({super.key});

  @override
  State<FavoriteExploreScreen> createState() => _FavoriteExploreScreenState();
}

class _FavoriteExploreScreenState extends State<FavoriteExploreScreen> {
  // Menyimpan kategori lokasi yang dipilih (contoh bawaan: Mountain dan Forest terpilih)
//   final Set<String> _selectedItems = {'Mountain', 'Forest'};
  final Set<String> _selectedItems = {};

  // Daftar kategori dengan label dan emoji berformat 3D modern sebagai pengganti sementara image assets
  final List<Map<String, String>> _categories = [
    {'title': 'Beach', 'icon': '🏝️'},
    {'title': 'Mountain', 'icon': '🗻'},
    {'title': 'Forest', 'icon': '🌲'},
    {'title': 'Ocean', 'icon': '🌊'},
    {'title': 'Camping', 'icon': '⛺'},
    {'title': 'Fishing', 'icon': '🎣'},
  ];

  void _toggleSelection(String title) {
    setState(() {
      if (_selectedItems.contains(title)) {
        _selectedItems.remove(title);
      } else {
        _selectedItems.add(title);
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one favorite place')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_places', _selectedItems.toList());

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomepageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Header kosong sejenak untuk padding safe area
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Where is your favorite\nplace to explore?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              
              // Tampilan Grid Pilihan Peminatan
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom sejajar
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95, // Rasio sedikit tegak agar lega
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final title = category['title']!;
                    final icon = category['icon']!;
                    final isSelected = _selectedItems.contains(title);
                    
                    return GestureDetector(
                      onTap: () => _toggleSelection(title),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade200,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            if (!isSelected) 
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 5,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Konten Utama Blok
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Container bayangan untuk Icon 3D
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.grey.shade200,
                                          Colors.transparent,
                                        ],
                                        radius: 0.6,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      icon,
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Ikon Centang Hijau saat dipilih
                            if (isSelected)
                              const Positioned(
                                top: 12,
                                right: 12,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),

              // Tombol Next (Menuju Dashboard / Halaman Awal)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCD240),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                     'Next',
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

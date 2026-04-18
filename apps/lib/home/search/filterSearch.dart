import 'package:flutter/material.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  double _priceLimit = 590;
  int _selectedStar = 5;
  String _selectedIncluded = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Range Price
            const Text(
              'Range Price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey.shade100,
                trackHeight: 2.0,
                thumbShape: _CustomThumbShape(),
                overlayColor: Colors.black.withOpacity(0.05),
              ),
              child: Slider(
                value: _priceLimit,
                min: 100,
                max: 7000,
                onChanged: (double value) {
                  setState(() {
                    _priceLimit = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$100', style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
                Text('\$${_priceLimit.toInt()}', style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                Text('\$7.000', style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 32),

            // Star Review
            const Text(
              'Star Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            _buildStarReviewItem(5),
            const SizedBox(height: 12),
            _buildStarReviewItem(4),
            const SizedBox(height: 12),
            _buildStarReviewItem(3),
            const SizedBox(height: 12),
            _buildStarReviewItem(2),
            const SizedBox(height: 12),
            _buildStarReviewItem(1),
            const SizedBox(height: 32),

            // Included
            const Text(
              'Included',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildIncludedChip('All', Icons.apps),
                const SizedBox(width: 12),
                _buildIncludedChip('Flight', Icons.flight_takeoff_outlined),
                const SizedBox(width: 12),
                _buildIncludedChip('Hotel', Icons.apartment_outlined),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _priceLimit = 590;
                    _selectedStar = 5;
                    _selectedIncluded = 'All';
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade200),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCD240),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarReviewItem(int starCount) {
    bool isSelected = _selectedStar == starCount;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStar = starCount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2DC49D) : Colors.grey.shade100,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.star,
                    size: 20,
                    color: index < starCount ? const Color(0xFFFCD240) : Colors.grey.shade200,
                  ),
                );
              }),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2DC49D),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncludedChip(String label, IconData icon) {
    bool isSelected = _selectedIncluded == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIncluded = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? const Color(0xFF2DC49D) : Colors.grey.shade100,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? const Color(0xFFFCD240) : Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbRadius = 10.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    double value = 0.0,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, _thumbRadius, paintFill);
    canvas.drawCircle(center, _thumbRadius, paintBorder);
  }
}

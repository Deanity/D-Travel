import 'package:flutter/material.dart';
import 'paymentMethod.dart';

class DetailBookingScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const DetailBookingScreen({super.key, this.bookingData});

  @override
  State<DetailBookingScreen> createState() => _DetailBookingScreenState();
}

class _DetailBookingScreenState extends State<DetailBookingScreen> {
  final TextEditingController _nameController = TextEditingController(text: "Pristia");
  final TextEditingController _contactController = TextEditingController(text: "+62039120102012031");
  final TextEditingController _idNumberController = TextEditingController(text: "0210312013103003010303");
  
  String _selectedMember = "2 Member";
  String _selectedIdType = "ID Card";

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
        title: const Text(
          'Detail Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildCustomTextField(
              label: "Person Responsible",
              controller: _nameController,
            ),
            const SizedBox(height: 24),
            _buildCustomTextField(
              label: "Contact Info",
              controller: _contactController,
            ),
            const SizedBox(height: 24),
            _buildCustomDropdown(
              label: "Member",
              value: _selectedMember,
              items: ["1 Member", "2 Member", "3 Member", "4 Member"],
              onChanged: (val) => setState(() => _selectedMember = val!),
            ),
            const SizedBox(height: 24),
            _buildCustomDropdown(
              label: "Type ID",
              value: _selectedIdType,
              items: ["ID Card", "Passport", "Driver License"],
              onChanged: (val) => setState(() => _selectedIdType = val!),
            ),
            const SizedBox(height: 24),
            _buildCustomTextField(
              label: "Number ID",
              controller: _idNumberController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCustomTextField({required String label, required TextEditingController controller}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Positioned(
          top: -10,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Total ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                TextSpan(
                  text: '\$1490,00',
                  style: TextStyle(color: Color(0xFFE85D25), fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCD240),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

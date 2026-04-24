import 'package:flutter/material.dart';
import 'createNewAccPassword.dart';

class CreateNewAccEmailScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  const CreateNewAccEmailScreen({super.key, required this.firstName, required this.lastName});

  @override
  State<CreateNewAccEmailScreen> createState() => _CreateNewAccEmailScreenState();
}

class _CreateNewAccEmailScreenState extends State<CreateNewAccEmailScreen> {
  final _emailController = TextEditingController();
  bool _receiveMarketing = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                "And, your email?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              
              // Email Field (menggunakan floating label)
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: Color(0xFFFCD240)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'pristia@gmail.com',
                  hintStyle: const TextStyle(color: Colors.black87),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFFCD240), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Toggle Switch Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "I'd like to received marketing and policy \ncommunication from D-Travel and its partners.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Sedikit spacer agar switch tidak terlalu dempet
                  Switch(
                    value: _receiveMarketing,
                    onChanged: (value) {
                      setState(() {
                        _receiveMarketing = value;
                      });
                    },
                    // Gaya warna khusus switch untuk menyamai sketsa (hitam-putih)
                    activeColor: Colors.white,
                    activeTrackColor: Colors.black,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                        return Colors.grey.shade400; // Border luar saat nonaktif
                      },
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Create Password Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your email')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNewAccPasswordScreen(
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          email: _emailController.text.trim(),
                        ),
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
                    'Create Password',
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

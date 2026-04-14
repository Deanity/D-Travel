import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'succesCreateAcc.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class CreateNewAccOTPScreen extends StatefulWidget {
  final String email;
  const CreateNewAccOTPScreen({super.key, required this.email});

  @override
  State<CreateNewAccOTPScreen> createState() => _CreateNewAccOTPScreenState();
}

class _CreateNewAccOTPScreenState extends State<CreateNewAccOTPScreen> {
  // Node agar kursor otomatis loncat ke kotak selanjutnya
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();
  final TextEditingController _controller7 = TextEditingController();
  final TextEditingController _controller8 = TextEditingController();

  bool _isLoading = false;
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _resendOTP() async {
    print('DEBUG: Attempting resend to: ${widget.email}');
    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code resent successfully!')),
        );
        _startTimer();
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    _focusNode7.dispose();
    _focusNode8.dispose();

    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final otp = _controller1.text + 
                _controller2.text + 
                _controller3.text + 
                _controller4.text + 
                _controller5.text + 
                _controller6.text +
                _controller7.text +
                _controller8.text;

    if (otp.length < 8) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter all 8 digits')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.signup,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessCreateAccScreen(),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildOTPBox(FocusNode focusNode, TextEditingController controller, FocusNode? nextFocusNode, FocusNode? prevFocusNode) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 64,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1), // Batasi hanyak 1 angka per kotak
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty && nextFocusNode != null) {
                nextFocusNode.requestFocus(); // Loncat ke depan
              } else if (value.isEmpty && prevFocusNode != null) {
                prevFocusNode.requestFocus(); // Loncat ke belakang saat delete
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero, // Teks agar terpusat di tengah kotak
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFCD240), width: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
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
                "OTP Verification",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),
              
              // Baris kotak pengisian OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOTPBox(_focusNode1, _controller1, _focusNode2, null),
                  _buildOTPBox(_focusNode2, _controller2, _focusNode3, _focusNode1),
                  _buildOTPBox(_focusNode3, _controller3, _focusNode4, _focusNode2),
                  _buildOTPBox(_focusNode4, _controller4, _focusNode5, _focusNode3),
                  _buildOTPBox(_focusNode5, _controller5, _focusNode6, _focusNode4),
                  _buildOTPBox(_focusNode6, _controller6, _focusNode7, _focusNode5),
                  _buildOTPBox(_focusNode7, _controller7, _focusNode8, _focusNode6),
                  _buildOTPBox(_focusNode8, _controller8, null, _focusNode7),
                ],
              ),
              const SizedBox(height: 32),
              
              // Informasi Timer reload kode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Send code reload in',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  _canResend 
                    ? GestureDetector(
                        onTap: _isLoading ? null : _resendOTP,
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                            color: Color(0xFFFCD240), 
                            fontSize: 13, 
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        _formatTime(_start),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                ],
              ),
              
              const Spacer(),
              
              // Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCD240),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        'Submit',
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

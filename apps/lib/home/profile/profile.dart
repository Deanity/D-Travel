import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../homepage.dart';
import '../listTrip/myTrip.dart';
import '../whishlist/wishList.dart';
import '../../auth/login/login.dart';
import '../notification/notif.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "Pristia";
  String _userEmail = "Semarang, Indonesia";
  bool _isLoggingOut = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      // Set initial data from metadata/auth for immediate feedback
      setState(() {
        _userName = user.userMetadata?['first_name'] ?? "User";
        _userEmail = user.email ?? "";
      });

      try {
        // Fetch fresh data from public.users table (synced by trigger)
        final userData = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _userName = userData['name'] ?? _userName;
            _userEmail = userData['email'] ?? _userEmail;
          });
        }
      } catch (e) {
        debugPrint('Error loading profile: $e');
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Logout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16, height: 1.5),
                children: [
                  const TextSpan(text: 'Are you sure you want to log out of '),
                  TextSpan(
                    text: '$_userName\'s ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(text: 'account?'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleLogout();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCD240),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Your Profile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              // Profile Header
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('lib/assets/profile/pfp.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Menu Options
              _buildMenuCard(
                title: "Personal Information",
                icon: Icons.person_pin_outlined,
              ),
              _buildMenuCard(
                title: "Notification",
                icon: Icons.notifications_none_outlined,
                hasBadge: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                },
              ),
              _buildMenuCard(
                title: "FAQ",
                icon: Icons.chat_bubble_outline_rounded,
              ),
              _buildMenuCard(
                title: "Language",
                icon: Icons.language_rounded,
              ),
              const SizedBox(height: 60),
              // Logout Button separated
              _buildMenuCard(
                title: "Logout",
                onTap: _showLogoutConfirmation,
                isLogout: true,
                icon: Icons.logout_rounded,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMenuCard({
    required String title,
    IconData? icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool hasBadge = false,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap ?? () {},
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isLogout ? Colors.redAccent.withOpacity(0.1) : Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLogout ? Colors.redAccent : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  if (trailing != null)
                    trailing
                  else if (icon != null)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(icon, color: isLogout ? Colors.redAccent : Colors.black, size: 24),
                        if (hasBadge)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE85D25),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const HomepageScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.home_outlined, color: Colors.grey.shade900, size: 26),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const MyTripScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.near_me_outlined, color: Colors.grey.shade900, size: 26),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 350),
                  pageBuilder: (_, __, ___) => const WishListScreen(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(Icons.favorite_border_rounded, color: Colors.grey.shade900, size: 26),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

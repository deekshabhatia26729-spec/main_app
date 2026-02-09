import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_app/screens/address_book_screen.dart'; 
import 'package:maid_app/screens/bookings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Colors extracted from the UI
  final Color primaryPurple = const Color(0xFF6229E8); // Vibrant Purple
  final Color scaffoldBg = const Color(0xFFF5F7FB);
  final Color textDark = const Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // --- Layer 1: Purple Background Header ---
          Container(
            height: 280, // Covers the top section
            width: double.infinity,
            color: primaryPurple,
          ),

          // --- Layer 2: Scrolling Content ---
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. App Bar / Navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Profile",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Profile Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD9D9D9), // Light grey placeholder
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deeksha Bhatia",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "+91 6375278663",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                // Edit Profile Logic
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Edit Profile",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.white, size: 16)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 3. Menu List Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // --- Card 1: Bookings & Address ---
                        _buildMenuSection([
                          _buildMenuItem(
                            icon: Icons.calendar_today_outlined,
                            text: "Your bookings",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BookingsScreen()),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.book_outlined, // Icon looks like a book/notebook
                            text: "Address Book",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddressBookScreen()),
                              );
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // --- Card 2: General Settings (Refer to Logout) ---
                        _buildMenuSection([
                          _buildMenuItem(
                            icon: Icons.share_outlined,
                            text: "Refer & Earn",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.article_outlined, // "About us" generic icon
                            text: "About us",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.edit_note, // "Terms" icon
                            text: "Terms & Conditions",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.gpp_good_outlined, // "Privacy" shield
                            text: "Privacy policy",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.headset_mic_outlined,
                            text: "Help & Support",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.description_outlined,
                            text: "Request account deletion",
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.logout,
                            text: "Log out",
                            onTap: () {},
                            isLastItem: true,
                          ),
                        ]),

                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  // 1. White Card Container
  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // 2. Individual Menu Item
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLastItem = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLastItem 
            ? const BorderRadius.vertical(bottom: Radius.circular(20))
            : null, // Rounds click effect for last item
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[900], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Divider
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: 0, // Full width divider inside the card
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_app/screens/search_location_screen.dart'; 
// import 'package:maid_app/screens/address_details_screen.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  // Colors
  final Color primaryPurple = const Color(0xFF7D42F1);
  final Color scaffoldBg = const Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // --- Layer 1: Backgrounds ---
          Column(
            children: [
              // The Purple Header Background
              Container(
                height: 280, // Fixed height to allow the card to overlap this area
                color: primaryPurple,
              ),
              // The White Body Background
              Expanded(
                child: Container(color: scaffoldBg),
              ),
            ],
          ),

          // --- Layer 2: Scrollable Content ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // 1. Back Button & Title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "My Addresses",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 2. Add Address Button (White Pill)
                  GestureDetector(
                    onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => const SearchLocationScreen(),
                         ),
                       );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add, color: primaryPurple, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                "Add Address",
                                style: GoogleFonts.inter(
                                  color: primaryPurple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. SAVED ADDRESSES Text
                  Text(
                    "SAVED ADDRESSES",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 4. The Card (Overlapping the purple background)
                  _buildAddressCard(
                    label: "Home",
                    address: "233,Ganpati, Pocket 25, D-1/10A Budh Vihar Phase-1 delhi-110086, New Delhi, Pocket 25, Sector 3 , Rohini, Delhi, India,\n110085,\nMobile: 6375276345",
                    phone: "6375276345", 
                  ),
                  
                  // Add extra space at bottom for scrolling
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String label,
    required String address,
    required String phone,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on, 
              color: Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                // Address Text
                Text(
                  address,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),

                // Edit Button
                GestureDetector(
                  onTap: () {
                     // Navigate to Edit Address
                  },
                  child: Text(
                    "EDIT",
                    style: GoogleFonts.inter(
                      color: primaryPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'address_details_screen.dart'; // Ensure this file exists or comment it out

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  // Controller for the search field to handle state
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors extracted from the image
    const Color primaryPurple = Color(0xFF7F4DFF);
    const Color bgGrey = Color(0xFFF3F4F6);
    const Color textDark = Color(0xFF1F2937);
    const Color textGrey = Color(0xFF9CA3AF);

    return Scaffold(
      backgroundColor: bgGrey,
      body: Stack(
        children: [
          // --- BACKGROUND LAYER ---
          // This purple container creates the top background header
          Container(
            height: 240, // Height of the purple section
            width: double.infinity,
            color: primaryPurple,
          ),

          // --- CONTENT LAYER ---
          SafeArea(
            child: Column(
              children: [
                // 1. Header Row (Back Button + Title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Search your Location",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Search Bar ---
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30), // High radius for pill shape
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search locality, sector, area",
                              hintStyle: GoogleFonts.inter(
                                color: textGrey,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black87,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- Add Address / Current Location Card ---
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildActionTile(
                                icon: Icons.add,
                                text: "Add Address",
                                color: primaryPurple,
                                onTap: () {
                                  // Handle Add Address logic
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey[100],
                                ),
                              ),
                              _buildActionTile(
                                icon: Icons.my_location, // Target icon
                                text: "Use current location",
                                color: primaryPurple,
                                onTap: () {
                                  // Handle Current Location logic
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- Saved Addresses Header ---
                        Text(
                          "SAVED ADDRESSES",
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // --- Saved Address Item (Home) ---
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon Box
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100], // Light grey box
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Home",
                                          style: GoogleFonts.inter(
                                            color: textDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "233,Ganpati, Pocket 25, D-1/10A Budh Vihar Phase-1 delhi-110086, New Delhi, Pocket 25, Sector 3, Rohini, Delhi, India, 110085\nMobile: 8375276345",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey[600],
                                        fontSize: 12, // Slightly smaller for address
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddressDetailsScreen(),
                                          ),
                                        );
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
                        ),
                        
                        // Extra spacing at bottom
                        const SizedBox(height: 40),
                      ],
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

  // Helper widget for "Add Address" and "Use current location" items
  Widget _buildActionTile({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
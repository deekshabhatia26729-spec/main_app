import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  // State for the "Save address as" toggle
  String selectedAddressType = "Home";

  // Controllers
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: "6375267665");
  final TextEditingController _nameController = TextEditingController(text: "Deeksha");

  // Colors extracted from the image
  final Color primaryPurple = const Color(0xFF7F4DFF);
  final Color lightPurpleBg = const Color(0xFFEBE4FF); // Very light purple for selection
  final Color bgGrey = const Color(0xFFF5F7FB);
  final Color borderGrey = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: Stack(
        children: [
          // --- Layer 1: Purple Background Header ---
          Container(
            height: 220, // Height of the purple section
            width: double.infinity,
            color: primaryPurple,
          ),

          // --- Layer 2: Content ---
          SafeArea(
            child: Column(
              children: [
                // Custom Header
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
                        "Add Address Details",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // --- CARD 1: Address Details ---
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address details",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Save address as",
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Toggle Buttons (Home / Other)
                              Row(
                                children: [
                                  _buildTypeButton("Home"),
                                  const SizedBox(width: 12),
                                  _buildTypeButton("Other"),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Row: House No & Floor
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPillTextField(
                                      hint: "Flat/House No.",
                                      controller: _houseNoController,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildPillTextField(
                                      hint: "Floor (Optional)",
                                      controller: _floorController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Building Name
                              _buildPillTextField(
                                hint: "Apartment/Building Name*",
                                controller: _buildingController,
                              ),
                              const SizedBox(height: 16),

                              // Landmark
                              _buildPillTextField(
                                hint: "Nearby Landmark (Optional)",
                                controller: _landmarkController,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --- CARD 2: Area/Sector/Locality ---
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Area/Sector/Locality*",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Pocket 25, D-1/10A Budh Vihar Phase-1 delhi- 110086, New Delhi, Pocket 25",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: lightPurpleBg,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Change",
                                      style: GoogleFonts.inter(
                                        color: primaryPurple,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --- CARD 3: Receiver's Details ---
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Receiver's Details",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Our professional will reach out to you on this number.",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Phone Number
                              _buildPillTextField(
                                hint: "Receiver's phone number",
                                controller: _phoneController,
                                prefixText: "+91  ",
                              ),
                              const SizedBox(height: 16),

                              // Name
                              _buildPillTextField(
                                hint: "Receiver's name",
                                controller: _nameController,
                              ),
                            ],
                          ),
                        ),

                        // Extra space for bottom button
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // --- Sticky Bottom Button ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              "Save address",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  // 1. Pill-shaped Text Field
  Widget _buildPillTextField({
    required String hint,
    required TextEditingController controller,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Matching the image's rounded look
        border: Border.all(color: borderGrey),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
          prefixText: prefixText,
          prefixStyle: GoogleFonts.inter(
             color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }

  // 2. Toggle Button (Home/Other)
  Widget _buildTypeButton(String type) {
    final bool isSelected = selectedAddressType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedAddressType = type;
          });
        },
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? lightPurpleBg : Colors.white,
            borderRadius: BorderRadius.circular(20), // Pill shape
            border: Border.all(
              color: isSelected ? Colors.transparent : borderGrey,
            ),
          ),
          child: Text(
            type,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? primaryPurple : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_app/screens/bottom_navigationbar.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive sizing
    final size = MediaQuery.of(context).size;
    // const primaryColor = Color(0xFF7D42F1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- 1. Header Text Section ---
              Text(
                "What’s your location?",
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary, 
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We need your location to show you  our serviceable hubs",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              // --- 2. Central Image Section ---
              // Using Expanded ensures the image takes up available space
              // nicely between the text and buttons.
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/image.png', // Replace with your city image asset
                    width: size.width * 0.9,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Placeholder if image is missing
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.location_city,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --- 3. Bottom Buttons Section ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add logic to get current location
                    print("Get Current Location Clicked");
                  },
                  icon: const Icon(Icons.my_location, color: Colors.white),
                  label: Text(
                    'Use current location',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary, 
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Add logic for manual entry
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                    print("Enter Location Manually Clicked");
                  },
                  child: Text(
                    "Enter location manually",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

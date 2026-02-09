import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORTS ---
import 'home_screen.dart';      // Your Home content
import 'bookings_screen.dart';  // Your Bookings content

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // --- Theme Colors ---
  final Color activeColor = const Color(0xFF7D42F1); // Change to Color(0xFF007A5E) for Green
  final Color inactiveColor = const Color(0xFF9E9E9E); 

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // --- Modern Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Modern subtle border like the screenshot
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          // Soft shadow for depth
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0, // Remove default elevation to use our custom shadow
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          
          // --- Typography & Colors ---
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 13, 
            fontWeight: FontWeight.w600,
            height: 1.6, // Adds space between icon and text
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 13, 
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),

          // --- Icons ---
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2), // Slight spacing adjustment
                child: Icon(Icons.home_outlined, size: 26),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.home_filled, size: 26),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.calendar_month_outlined, size: 26), // Matches the squared calendar in image
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.calendar_month, size: 26),
              ),
              label: 'Bookings',
            ),
          ],
        ),
      ),
    );
  }
}
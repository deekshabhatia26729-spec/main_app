import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  // Exact colors from the image
  final Color primaryPurple = const Color(0xFF7D42F1); // The main purple
  final Color scaffoldBg = const Color(0xFFF5F7FB);
  
  late TabController _tabController;
  bool isOneTime = true; // State for the toggle (One-time vs Recurring)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Column(
        children: [
          // --- Custom Purple Header ---
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: BoxDecoration(
              color: primaryPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Back Button & Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Your Bookings",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),

                // 2. Tabs (Upcoming / Past)
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                  unselectedLabelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent, // Removes the grey line usually below tabs
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past"),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. White Pill Toggle (One-time / Recurring)
                Container(
                  height: 45,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      // Option 1: One-time
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isOneTime = true),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isOneTime ? primaryPurple : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "One-time",
                              style: GoogleFonts.inter(
                                color: isOneTime ? Colors.white : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Option 2: Recurring
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isOneTime = false),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !isOneTime ? primaryPurple : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Recurring",
                              style: GoogleFonts.inter(
                                color: !isOneTime ? Colors.white : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Body Content ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming View
                _buildEmptyState(),
                
                // Past View
                Center(
                  child: Text(
                    "No past bookings",
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder for when there are no bookings (as seen in common empty states)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           // You can add the 3D calendar image here if you have the asset
           // Image.asset('assets/calendar.png', height: 100),
        ],
      ),
    );
  }
}
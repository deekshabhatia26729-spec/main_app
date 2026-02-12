import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';
import 'search_location_screen.dart';
import 'service_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlideIndex = 0;
  int _currentTab = 0; // 0 = Home, 1 = Bookings
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _bannerController;
  late Timer _bannerTimer;

  // --- Colors ---
  final Color primaryColor = const Color(0xFF6E40C9); // Deep Purple
  final Color primaryLight = const Color(0xFFF3EAFF); // Light Purple
  final Color greenBannerColor = const Color(0xFF0F9D58);
  final Color serviceBoxColor = const Color(0xFFF5F5F5);
  final Color textDark = const Color(0xFF2D2D2D);
  final Color softBlue = const Color(0xFF4FC3F7); // Soft blue for active card

  // --- State for Selection ---
  final Map<int, int> _selectedServices = {};
  int _activeProfessionalCard = 0; // Track active professional card
  int? _expandedFAQIndex; // Track which FAQ is expanded (null = none)

  // --- Interaction Methods ---
  void _handleAddressClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchLocationScreen()),
    );
  }

  void _incrementService(int index) {
    setState(() {
      _selectedServices[index] = (_selectedServices[index] ?? 0) + 1;
    });
  }

  void _decrementService(int index) {
    setState(() {
      if (_selectedServices.containsKey(index)) {
        if (_selectedServices[index]! > 1) {
          _selectedServices[index] = _selectedServices[index]! - 1;
        } else {
          _selectedServices.remove(index);
        }
      }
    });
  }

  int get _totalItemCount =>
      _selectedServices.values.fold(0, (sum, qty) => sum + qty);

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentSlideIndex < 2) {
        _currentSlideIndex++;
      } else {
        _currentSlideIndex = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentSlideIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // --- BOTTOM SHEET (Review Services) ---
  void _showCartDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Helper to update both Modal state and Parent state
            void updateQty(int index, bool increment) {
              setState(() {
                if (increment) {
                  _incrementService(index);
                } else {
                  _decrementService(index);
                }
              });
              setModalState(() {}); // Refresh modal
              if (_selectedServices.isEmpty) Navigator.pop(context);
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Review Services",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.purple,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _selectedServices.length,
                      itemBuilder: (ctx, i) {
                        int key = _selectedServices.keys.elementAt(i);
                        int qty = _selectedServices[key]!;
                        var item = serviceList[key];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF9F6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/3014/3014275.png", // Generic clean icon
                                  color: Colors.brown[300],
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Name & Price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'].replaceAll('\n', ' '),
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "₹${item['price']}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Purple Pill Counter
                              Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onPressed: () => updateQty(key, false),
                                    ),
                                    Text(
                                      "$qty",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onPressed: () => updateQty(key, true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // =========================================
      // Bottom Navigation Bar (Standard)
      // =========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Bookings",
          ),
        ],
      ),

      body: Stack(
        children: [
          // Scrollable Content with Purple Background
          Column(
            children: [
              // Fixed Top Bar
              Container(
                color: Colors.white,
                child: SafeArea(bottom: false, child: _buildTopBar()),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  // Padding at bottom to avoid hiding content behind the cart bar
                  padding: EdgeInsets.only(
                    bottom: _selectedServices.isNotEmpty ? 80 : 20,
                  ),
                  child: Column(
                    children: [
                      // Purple background section
                      Container(
                        width: double.infinity,
                        color: primaryColor,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildBannerCarousel(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),

                      // White floating card section (overlapping with negative margin)
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(34),
                              topRight: Radius.circular(34),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                title: "Book for Later",
                                subtitle:
                                    "Select your slot & stay worry - free",
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildActionCard(
                                      title: "Schedule\nBooking",
                                      subTag: "UP TO 50% OFF",
                                      imagePath: "assets/images/call.png",
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildActionCard(
                                      title: "Recurring\nBooking",
                                      subTag: "UP TO 50% OFF",
                                      imagePath: "assets/images/recuriing.png",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              _buildSectionHeader(
                                title: "All house help services",
                                subtitle: "At your door steps",
                              ),
                              const SizedBox(height: 16),
                              // Grid
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 20,
                                    ),
                                itemCount: serviceList.length,
                                itemBuilder: (context, index) =>
                                    _buildServiceItem(index),
                              ),
                              const SizedBox(height: 30),
                              _buildReliableSection(),
                              const SizedBox(height: 25),
                              _buildFAQSection(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // =========================================
          // Layer 3: Floating "Go to Cart" Bar
          // =========================================
          if (_selectedServices.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70, // Height of the bar
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8), // Very light grey/white
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  border: const Border(
                    top: BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT: Icon + Text + Arrow (Clickable)
                    InkWell(
                      onTap: _showCartDetails,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/3014/3014275.png",
                              width: 20,
                              color: Colors.brown[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$_totalItemCount Services",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: Color(0xFF6E40C9),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    // RIGHT: "Go to cart" Button
                    ElevatedButton(
                      onPressed: _showCartDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Go to cart",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  // =========================================
  // HELPER WIDGETS (Same as before, minimal changes)
  // =========================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _handleAddressClick,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Home",
                        style: GoogleFonts.inter(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  Text(
                    "233, Ganpati Nagar 25, D...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFFFD700),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Earn",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF795548),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹100",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF795548),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const ProfileScreen()),
                ),
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 18,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final List<String> bannerImages = [
      'assets/images/image copy.png',
      'assets/images/new 1 banner 1.png',
      'assets/images/cook.png',
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) =>
                setState(() => _currentSlideIndex = index),
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    bannerImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentSlideIndex == index ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentSlideIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subTag,
    required String imagePath,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF8B5CF6), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subTag,
                  style: GoogleFonts.inter(
                    color: primaryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -5,
            bottom: -5,
            child: Image.asset(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(int index) {
    final int quantity = _selectedServices[index] ?? 0;
    final bool isSelected = quantity > 0;
    final service = serviceList[index];

    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailScreen(
                        serviceData: serviceList[index],
                        serviceIndex: index,
                        initialQty: _selectedServices[index] ?? 0,
                        onAdd: () => _incrementService(index),
                        onRemove: () => _decrementService(index),
                        selectedServices: _selectedServices,
                        serviceList: serviceList,
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: serviceBoxColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: primaryColor, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.cleaning_services_outlined,
                        size: 40,
                        color: isSelected ? primaryColor : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
              // Plus button or counter at bottom-right corner
              Positioned(
                bottom: 8,
                right: 8,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                  child: isSelected
                      ? _buildCounterControl(index, quantity)
                      : _buildAddButton(index),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          service['name'],
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? primaryColor : textDark,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(int index) {
    return GestureDetector(
      key: ValueKey('add_$index'),
      onTap: () => _incrementService(index),
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFE9D5FF), // Light lavender
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: primaryColor, // Dark purple
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterControl(int index, int qty) {
    return Container(
      key: ValueKey('counter_$index'),
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: primaryColor, // Dark purple background
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _decrementService(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.remove, size: 18, color: Colors.white),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            child: Center(
              child: Text(
                "$qty",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => _incrementService(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReliableSection() {
    final List<Map<String, String>> professionals = [
      {'caption': 'Verified\nProfessionals\nYou Can Trust'},
      {'caption': 'Properly\nTrained to\nDeliver Great\nService'},
      {'caption': 'Safe, Reliable\nand Consistent\nEvery Time'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reliable & Trustworthy",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Ensuring integrity through verified standards",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < professionals.length - 1 ? 16 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeProfessionalCard = index;
                      });
                    },
                    child: _buildProfessionalCard(
                      professionals[index]['caption']!,
                      index == _activeProfessionalCard,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(String caption, bool isActive) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isActive ? Border.all(color: softBlue, width: 3) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/Rectangle 300.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Professional',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: 180,
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textDark,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'Can I book a recurring Service?',
        'answer':
            'Yes! You can easily schedule recurring services on a daily, weekly, or monthly basis. Simply select your preferred frequency during booking, and we\'ll handle the rest automatically.',
      },
      {
        'question': 'Do I need to provide cleaning equipment?',
        'answer':
            'No, our professionals come fully equipped with all necessary cleaning supplies and tools. However, if you have specific products you\'d prefer us to use, feel free to provide them.',
      },
      {
        'question': 'What if I am not satisfied with the service?',
        'answer':
            'Your satisfaction is our priority. If you\'re not happy with the service, please contact us within 24 hours and we\'ll arrange a re-service at no additional cost or provide a full refund.',
      },
      {
        'question': 'How do I reschedule or cancel a booking?',
        'answer':
            'You can easily reschedule or cancel through the app under "My Bookings". Please note that cancellations made less than 2 hours before the scheduled time may incur a small fee.',
      },
      {
        'question': 'Are your professionals background verified?',
        'answer':
            'Absolutely! All our professionals undergo thorough background checks, verification, and training before they can join our platform. Your safety and security are our top priorities.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FAQs",
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 15),
        ...List.generate(
          faqs.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index < faqs.length - 1 ? 10 : 0),
            child: _buildFAQItem(
              index,
              faqs[index]['question']!,
              faqs[index]['answer']!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    final bool isExpanded = _expandedFAQIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle: if already expanded, collapse it; otherwise expand it
          _expandedFAQIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EAFF), // Soft pastel purple
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A148C),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isExpanded ? 0.125 : 0, // 45 degrees for minus effect
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isExpanded ? Icons.remove : Icons.add,
                      color: const Color(0xFF6E40C9),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          answer,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B4A8C),
                            height: 1.5,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// Data
final List<Map<String, dynamic>> serviceList = [
  {'name': 'Pre-Party\nExpress Clean', 'price': 499},
  {'name': 'After-Party\nExpress Clean', 'price': 599},
  {'name': 'Packing or\nUnpacking', 'price': 349},
  {'name': 'Sweeping &\nMopping', 'price': 299},
  {'name': 'Utensils', 'price': 199},
  {'name': 'Bathroom &\nSurface clean...', 'price': 399},
  {'name': 'Kitchen Prep', 'price': 249},
  {'name': 'Ironing', 'price': 149},
  {'name': 'Sweeping', 'price': 99},
  {'name': 'Dusting', 'price': 129},
  {'name': 'Window', 'price': 199},
  {'name': 'Staircase', 'price': 89},
];

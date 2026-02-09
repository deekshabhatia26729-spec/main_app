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

  // --- Colors ---
  final Color primaryColor = const Color(0xFF6E40C9); // Deep Purple
  final Color primaryLight = const Color(0xFFF3EAFF); // Light Purple
  final Color greenBannerColor = const Color(0xFF0F9D58);
  final Color serviceBoxColor = const Color(0xFFF5F5F5);
  final Color textDark = const Color(0xFF2D2D2D);

  // --- State for Selection ---
  final Map<int, int> _selectedServices = {};

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
          // =========================================
          // Layer 1 & 2: Background + Content
          // =========================================
          Column(
            children: [
              // Purple Top Area
              Container(
                height: size.height * 0.38,
                width: double.infinity,
                color: primaryColor,
                child: SafeArea(child: Column(children: [_buildTopBar()])),
              ),
            ],
          ),

          // Scrollable Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 60), // Space for top bar
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // Padding at bottom to avoid hiding content behind the cart bar
                    padding: EdgeInsets.only(
                      bottom: _selectedServices.isNotEmpty ? 80 : 20,
                    ),
                    child: Column(
                      children: [
                        _buildBannerCarousel(),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
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
                                      icon: Icons.access_time_filled_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildActionCard(
                                      title: "Recurring\nBooking",
                                      subTag: "UP TO 50% OFF",
                                      icon: Icons.calendar_month_rounded,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    "233, Ganpati Nagar 25, D...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.85),
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹100",
                          style: GoogleFonts.inter(
                            color: Colors.white,
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
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.person, color: primaryColor, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView(
            controller: PageController(viewportFraction: 0.92),
            onPageChanged: (index) =>
                setState(() => _currentSlideIndex = index),
            children: [
              _buildGreenBanner(),
              _buildGenericBanner(Colors.blueAccent, "Deep Cleaning Offer"),
              _buildGenericBanner(Colors.orangeAccent, "Summer Sale"),
            ],
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

  Widget _buildGreenBanner() {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 20),
      decoration: BoxDecoration(
        color: greenBannerColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TRUSTED,\nRELIABLE AND\nVERIFIED.",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B6134),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Chosen by 200k+ families",
                    style: GoogleFonts.inter(
                      color: Colors.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Book now",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF003823),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            top: 10,
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/6998/6998058.png',
              fit: BoxFit.contain,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericBanner(Color color, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subTag,
    required IconData icon,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
            right: 0,
            top: 0,
            child: Icon(icon, color: Colors.white.withOpacity(0.2), size: 50),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(icon, color: Colors.white.withOpacity(0.9), size: 30),
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryLight : serviceBoxColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: primaryColor, width: 1.5)
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
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: isSelected
                      ? _buildCounterControl(index, quantity)
                      : _buildAddButton(index),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
      onTap: () => _incrementService(index),
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Icon(Icons.add, color: primaryColor, size: 20)),
      ),
    );
  }

  Widget _buildCounterControl(int index, int qty) {
    return Container(
      height: 32,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _decrementService(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.remove, size: 16, color: primaryColor),
            ),
          ),
          Text(
            "$qty",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          InkWell(
            onTap: () => _incrementService(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.add, size: 16, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReliableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: "Reliable & Trustworthy",
          subtitle: "Ensuring integrity through verified standards",
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildReliableItem("Verified\nProfessionals"),
              _buildReliableItem("Properly\nTrained"),
              _buildReliableItem("Safe &\nSecure"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReliableItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            height: 90,
            width: 85,
            decoration: BoxDecoration(
              color: serviceBoxColor,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/12560/12560566.png",
                ),
                scale: 5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
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
        _buildFAQItem("Can I book a recurring Service?"),
        const SizedBox(height: 10),
        _buildFAQItem("Do I need to provide cleaning equipment?"),
        const SizedBox(height: 10),
        _buildFAQItem("What if I am not satisfied with the service?"),
      ],
    );
  }

  Widget _buildFAQItem(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A148C),
              ),
            ),
          ),
          const Icon(Icons.add, color: Color(0xFF6E40C9), size: 22),
        ],
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

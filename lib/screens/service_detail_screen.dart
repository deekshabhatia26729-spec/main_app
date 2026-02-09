import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  // Keep references if parent wants to share state
  final Map<int, int> selectedServices;
  final List<Map<String, dynamic>> serviceList;
  final Map<String, dynamic> serviceData;
  final int serviceIndex;
  final int initialQty;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const ServiceDetailScreen({
    super.key,
    required this.selectedServices,
    required this.serviceList,
    required this.serviceData,
    required this.serviceIndex,
    this.initialQty = 0,
    this.onAdd,
    this.onRemove,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  // --- Brand Colors extracted from Image ---
  final Color primaryPurple = const Color(0xFF7F57F1); // The main purple button color
  final Color greenColor = const Color(0xFF00C853);
  final Color redColor = const Color(0xFFFF3D00);
  final Color bgLight = const Color(0xFFF9F9F9); // Light background for sections
  final Color textDark = const Color(0xFF1D1D1D);
  final Color textGrey = const Color(0xFF757575);

  bool isAdded = false;
  late int qty;

  @override
  void initState() {
    super.initState();
    isAdded = widget.initialQty > 0;
    qty = widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for scrolling
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image
                _buildHeroImage(),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Title, Price and Add Button
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // 3. Includes Section (Green)
                      _buildInfoSection(
                        title: "Includes",
                        items: [
                          "Sweeping and mopping the staircase",
                          "Sweeping and mopping the staircase",
                          "Sweeping and mopping the staircase",
                        ],
                        icon: Icons.check_circle,
                        iconColor: greenColor,
                      ),
                      const SizedBox(height: 16),

                      // 4. Does Not Include Section (Red)
                      _buildInfoSection(
                        title: "Does not include",
                        items: [
                          "Sweeping and mopping the staircase",
                          "Sweeping and mopping the staircase",
                          "Sweeping and mopping the staircase",
                        ],
                        icon: Icons.cancel,
                        iconColor: redColor,
                      ),
                      const SizedBox(height: 24),

                      // 5. How it's done Section
                      Text(
                        "How it's done?",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStepItem("Sweeping", "The staircase of up to one floor are swept first."),
                      _buildStepItem("Sweeping", "The staircase of up to one floor are swept first."),
                      _buildStepItem("Sweeping", "The staircase of up to one floor are swept first."),

                      const SizedBox(height: 24),

                      // 6. FAQs Section
                      Text(
                        "FAQs",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Purple Info Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EFFF), // Light purple bg
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Can I book a recurring Service?",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textGrey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Expandable Questions
                      _buildFAQItem("Do I need to provide all the cleaning equipment?"),
                      _buildFAQItem("Do I need to provide all the cleaning equipment?"),
                      _buildFAQItem("Do I need to provide all the cleaning equipment?"),
                      _buildFAQItem("Do I need to provide all the cleaning equipment?"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Back Button Overlay
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          // Share Button Overlay
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
          // Floating review bar (shows when there are selected services)
          if (widget.selectedServices.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            "${widget.selectedServices.values.fold<int>(0, (p, e) => p + e)} Services",
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: textDark),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_up_rounded, color: Color(0xFF6E40C9), size: 24),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => CartScreen(
                              selectedServices: widget.selectedServices,
                              serviceList: widget.serviceList,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Go to cart",
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
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

  void _showCartDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          void updateQty(int index, bool increment) {
            setModalState(() {
              if (increment) {
                widget.selectedServices[index] = (widget.selectedServices[index] ?? 0) + 1;
              } else {
                if (widget.selectedServices.containsKey(index)) {
                  if (widget.selectedServices[index]! > 1) {
                    widget.selectedServices[index] = widget.selectedServices[index]! - 1;
                  } else {
                    widget.selectedServices.remove(index);
                  }
                }
              }
            });
            // also try to notify parent if this is the same service
            if (index == widget.serviceIndex) {
              if (increment) {
                widget.onAdd?.call();
              } else {
                widget.onRemove?.call();
              }
            }
            if (widget.selectedServices.isEmpty) Navigator.pop(context);
            if (mounted) setState(() {});
          }

          final keys = widget.selectedServices.keys.toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Review Services", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: keys.length,
                    itemBuilder: (ctx, i) {
                      final key = keys[i];
                      final qty = widget.selectedServices[key]!;
                      final item = widget.serviceList[key];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(color: bgLight, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.cleaning_services_outlined, size: 30, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text("₹${item['price']}", style: GoogleFonts.inter(color: textGrey)),
                                ],
                              ),
                            ),
                            Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: primaryPurple.withOpacity(0.15))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(onTap: () => updateQty(key, false), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.remove, size: 18, color: Colors.black))),
                                  Text("$qty", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textDark)),
                                  InkWell(onTap: () => updateQty(key, true), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.add, size: 18, color: Colors.black))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.selectedServices.values.fold<int>(0, (p, e) => p + e)} Services", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => CartScreen(
                                selectedServices: widget.selectedServices,
                                serviceList: widget.serviceList,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        child: Text("Go to cart", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // --- Widget Builders ---

  Widget _buildHeroImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.grey, // Placeholder color
        image: DecorationImage(
          // Using a placeholder image since I don't have your asset
          image: NetworkImage("https://images.unsplash.com/photo-1581578731117-104f8a3d46a8?q=80&w=2070&auto=format&fit=crop"), 
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Staircase",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "₹45",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "30 m", // Dummy duration
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textGrey,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 36,
          child: qty > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryPurple.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          if (qty > 0) {
                            setState(() {
                              qty = (qty - 1);
                              if (qty == 0) isAdded = false;
                            });
                            widget.onRemove?.call();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.remove, size: 18, color: Colors.black),
                        ),
                      ),
                      Text(
                        "$qty",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            qty = qty + 1;
                            isAdded = true;
                          });
                          widget.onAdd?.call();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.add, size: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                    onPressed: () {
                    setState(() {
                      qty = 1;
                      isAdded = true;
                    });
                    widget.onAdd?.call();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => CartScreen(
                          selectedServices: widget.selectedServices,
                          serviceList: widget.serviceList,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                  ),
                  child: Text(
                    "ADD",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        )
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF444444),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStepItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Thumbnail
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            // Use Icon or Image here
            child: Icon(Icons.cleaning_services_outlined, color: primaryPurple.withOpacity(0.5)),
          ),
          const SizedBox(width: 16),
          // Step Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textGrey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFFF).withOpacity(0.5), // Very light purple
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            trailing: const Icon(Icons.add, size: 20, color: Colors.black),
            childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            children: [
              Text(
                "Yes, basic cleaning supplies are required to be provided by the customer.",
                style: GoogleFonts.inter(fontSize: 12, color: textGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_common_widgets.dart';

import 'instant_tab.dart';
import 'recurring_tab.dart';
import 'scheduled_tab.dart';

class CartScreen extends StatefulWidget {
  Map<int, int>? selectedServices;
  List<Map<String, dynamic>>? serviceList;
  CartScreen({super.key, this.selectedServices, this.serviceList});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0; // 0=Instant, 1=Scheduled, 2=Recurring

  void _updateQuantity(int index, int delta) {
    setState(() {
      if (widget.selectedServices!.containsKey(index)) {
        int newQty = widget.selectedServices![index]! + delta;
        if (newQty > 0) {
          widget.selectedServices![index] = newQty;
        } else {
          widget.selectedServices!.remove(index);
        }
      } else if (delta > 0) {
        widget.selectedServices![index] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Guard against null or empty data
    if (widget.selectedServices == null ||
        widget.serviceList == null ||
        widget.selectedServices!.isEmpty) {
      return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                      'My Cart',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: GoogleFonts.inter(fontSize: 16, color: kTextGrey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Totals logic
    double subtotal = 0;
    widget.selectedServices!.forEach((k, v) {
      if (k < widget.serviceList!.length) {
        subtotal += (widget.serviceList![k]['price'] as int) * v;
      }
    });
    double gst = subtotal * 0.18;
    double total = subtotal + gst;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                    'My Cart',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // --- WHITE CONTENT AREA ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // --- TAB SELECTOR ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildTab(0, 'Instant'),
                          _buildTab(1, 'Scheduled'),
                          _buildTab(2, 'Recurring'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- CONTENT ---
                    Expanded(
                      child: IndexedStack(
                        index: _selectedTab,
                        children: [
                          InstantTab(
                            items: widget.selectedServices!,
                            services: widget.serviceList!,
                            onChangeQty: _updateQuantity,
                          ),
                          ScheduledTab(
                            items: widget.selectedServices!,
                            services: widget.serviceList!,
                            onChangeQty: _updateQuantity,
                            subtotal: subtotal,
                            gst: gst,
                            total: total,
                          ),
                          RecurringTab(
                            items: widget.selectedServices!,
                            services: widget.serviceList!,
                            onChangeQty: _updateQuantity,
                          ),
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

      // --- BOTTOM ACTION BAR ---
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              if (_selectedTab == 1) {
                _showTimeSlotBottomSheet(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _selectedTab == 2
                ? Text(
                    'Select frequency & time slot',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : _selectedTab == 1
                ? Text(
                    'Select time slot',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pay now',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _showTimeSlotBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const TimeSlotBottomSheet(),
    );
  }

  Widget _buildTab(int index, String text) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

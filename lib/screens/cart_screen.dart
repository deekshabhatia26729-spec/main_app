import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_common_widgets'; // Import common assets
import 'instant_tab.dart';
import 'recurring_tab.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0; // 0=Instant, 1=Scheduled, 2=Recurring

  // Dummy Data
  final List<Map<String, dynamic>> _services = [
    {'name': 'Utensils', 'price': 49},
    {'name': 'Sweeping', 'price': 49},
  ];

  final Map<int, int> _cartItems = {0: 1, 1: 1};

  void _updateQuantity(int index, int delta) {
    setState(() {
      if (_cartItems.containsKey(index)) {
        int newQty = _cartItems[index]! + delta;
        if (newQty > 0) _cartItems[index] = newQty;
        else _cartItems.remove(index);
      } else if (delta > 0) {
        _cartItems[index] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Totals logic
    double subtotal = 0;
    _cartItems.forEach((k, v) => subtotal += (_services[k]['price'] as int) * v);
    double total = subtotal + (subtotal * 0.18);

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
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text('My Cart', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // --- WHITE CONTENT AREA ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
                          InstantTab(items: _cartItems, services: _services, onChangeQty: _updateQuantity),
                          // Reuse InstantTab for Scheduled as UI is same
                          InstantTab(items: _cartItems, services: _services, onChangeQty: _updateQuantity),
                          RecurringTab(items: _cartItems, services: _services, onChangeQty: _updateQuantity),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _selectedTab == 2
              ? Text('Select frequency & time slot', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pay now', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const VerticalDivider(color: Colors.white24, width: 32, thickness: 1, indent: 4, endIndent: 4),
                    Text('₹${total.toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String text) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
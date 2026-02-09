import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_common_widgets'; // Import common assets


class InstantTab extends StatelessWidget {
  final Map<int, int> items;
  final List<Map<String, dynamic>> services;
  final Function(int, int) onChangeQty;

  const InstantTab({
    super.key,
    required this.items,
    required this.services,
    required this.onChangeQty,
  });

  @override
  Widget build(BuildContext context) {
    const Color kTextGrey = Color(0xFF999999); // Define kTextGrey as a constant
    
    // Calculate totals
    double subtotal = 0;
    items.forEach((key, qty) {
      if (key < services.length) {
        subtotal += (services[key]['price'] as int) * qty;
      }
    });
    double gst = subtotal * 0.18;
    double total = subtotal + gst;
    int totalQty = items.values.fold(0, (p, c) => p + c);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Review Booking" Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Review booking', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('$totalQty services', style: GoogleFonts.inter(fontSize: 13, color: kTextGrey)),
            ],
          ),
          const SizedBox(height: 12),

          // Service List
          ...items.keys.map((key) {
            final qty = items[key]!;
            final service = services[key];
            return ServiceItemCard(
              name: service['name'],
              price: service['price'],
              quantity: qty,
              onAdd: () => onChangeQty(key, 1),
              onRemove: () => onChangeQty(key, -1),
            );
          }).toList(),

          // Add More Link
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Missed something? Add more services',
                style: GoogleFonts.inter(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
          ),

          // Coupon
          const CouponCard(),

          // Address & Contact
          const AddressDetailsCard(),
          
          const SizedBox(height: 12),

          // Bill Details
          BillDetailsCard(subtotal: subtotal, gst: gst, total: total),

          const SizedBox(height: 100), // Bottom padding for floating button
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_app/widgets/cart_common_widgets.dart';

class ScheduledTab extends StatelessWidget {
  final Map<int, int> items;
  final List<Map<String, dynamic>> services;
  final Function(int, int) onChangeQty;
  final double subtotal;
  final double gst;
  final double total;

  const ScheduledTab({
    super.key,
    required this.items,
    required this.services,
    required this.onChangeQty,
    required this.subtotal,
    required this.gst,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    int totalServices = items.values.fold(0, (sum, item) => sum + item);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Review booking',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalServices services',
                style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...items.keys.map((key) {
            final qty = items[key]!;
            final service = services[key];
            return ServiceItemCard(
              name: service['name'],
              price: (service['price'] as num).toInt(),
              quantity: qty,
              onAdd: () => onChangeQty(key, 1),
              onRemove: () => onChangeQty(key, -1),
            );
          }).toList(),

          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Missed something? Add more services',
              style: GoogleFonts.inter(
                color: kPrimaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const CouponCard(),

          const SizedBox(height: 16),
          const AddressDetailsCard(),

          const SizedBox(height: 16),
          BillDetailsCard(subtotal: subtotal, gst: gst, total: total),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

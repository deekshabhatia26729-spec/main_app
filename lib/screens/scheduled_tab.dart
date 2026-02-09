import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_common_widgets';


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
              Text('Review booking', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('$totalServices services', style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),

          ...items.keys.map((key) {
            final qty = items[key]!;
            final service = services[key];
            return ServiceItemCard(
              name: service['name'],
              price: (service['price'] as num).toDouble(),
              quantity: qty,
              onAdd: () => onChangeQty(key, 1),
              onRemove: () => onChangeQty(key, -1),
            );
          }).toList(),

          GestureDetector(
            onTap: () {},
            child: Text(
              'Missed something? Add more services',
              style: GoogleFonts.inter(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
          ),

          const CouponsCard(),
          const BookingDetailsCard(),
          const SizedBox(height: 20),
          
          Text('Bill Details', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          BillDetailsCard(subtotal: subtotal, gst: gst, total: total),
           
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/cart_common_widgets'; // Import common assets

class RecurringTab extends StatelessWidget {
  final Map<int, int> items;
  final List<Map<String, dynamic>> services;
  final Function(int, int) onChangeQty;

  const RecurringTab({
    super.key,
    required this.items,
    required this.services,
    required this.onChangeQty,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Review booking', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('${items.length} service per visit', style: GoogleFonts.inter(fontSize: 13, color: kTextGrey)),
            ],
          ),
          const SizedBox(height: 12),

          // --- UNIQUE RECURRING CARD ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select frequency & time for recurring services', 
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Save up to 25 per service with auto-scheduled bookings', 
                        style: GoogleFonts.inter(color: kTextGrey, fontSize: 12)),
                      const SizedBox(height: 12),
                      _checkItem('Select days of your choice'),
                      const SizedBox(height: 4),
                      _checkItem('Priority service, same slot, no hassle'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_month_outlined, color: kPrimaryColor, size: 20),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Services
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

          const CouponCard(),
          const AddressDetailsCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _checkItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 12, color: kTextBlack))),
      ],
    );
  }
}
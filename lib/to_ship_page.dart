// to_ship_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tryfit_capstone/homepage.dart';
import 'orders_page.dart' as orders_page;
import 'completed_page.dart' as completed_page;
import 'cancelled_page.dart' as cancelled_page;

class ToShipPage extends StatefulWidget {
  const ToShipPage({super.key});

  @override
  State<ToShipPage> createState() => _ToShipPageState();
}

class _ToShipPageState extends State<ToShipPage> {
  final Color accent = const Color(0xFF9747FF);
  final Color grayBg = const Color(0xFFF7F7F7);
  final Color placeholderGray = const Color(0xFFECECEC);

  List<Map<String, dynamic>> toShipOrders = [
    {
      'id': 'ORD-1001',
      'status': 'To Ship',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'items': [
        {
          'productName': 'Purple Hoodie',
          'image': null,
          'size': 'M',
          'quantity': 1,
          'color': 'Violet',
        },
      ],
      'address': '123 Rainbow Street, Enchanted City',
      'expectedDelivery': 'Oct 25, 2025',
      'total': 799,
    },
  ];

  final List<Map<String, dynamic>> cancelled = [];
  final String activeTab = 'To Ship';

  String _formatShort(DateTime dt) {
    final s = dt.toIso8601String();
    return s.substring(0, 16).replaceAll('T', ' ');
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order ID copied to clipboard')),
    );
  }

  void _confirmCancelOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Cancellation?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _cancelOrder(order);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _cancelOrder(Map<String, dynamic> order) {
    setState(() {
      toShipOrders.removeWhere((o) => o['id'] == order['id']);
      final moved = Map<String, dynamic>.from(order);
      moved['status'] = 'Cancelled';
      moved['cancelledAt'] = DateTime.now().toIso8601String();
      cancelled.add(moved);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cancelled and moved to Cancelled.')),
    );
  }

  void _navigateTo(String page) {
    Widget nextPage;
    switch (page) {
      case 'To Receive':
        nextPage = const orders_page.OrdersPage();
        break;
      case 'Completed':
        nextPage = const completed_page.CompletedPage();
        break;
      case 'Cancelled':
        nextPage = const cancelled_page.CancelledPage();
        break;
      case 'To Ship':
      default:
        nextPage = const ToShipPage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  void _goToHomepage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Homepage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFFC7A3FF)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              // Header: back arrow + "My Purchases" (Krona One)
              Row(
                children: [
                  IconButton(
                    onPressed: _goToHomepage, // ✅ Fixed navigation
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Text(
                    "My Purchases",
                    style: GoogleFonts.kronaOne(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // TABS
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['To Ship', 'To Receive', 'Completed', 'Cancelled']
                      .map((tab) {
                        final bool isActive = tab == activeTab;
                        return GestureDetector(
                          onTap: () => _navigateTo(tab),
                          child: Container(
                            margin: const EdgeInsets.only(right: 18),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tab,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isActive ? accent : Colors.black87,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 3,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),

              const SizedBox(height: 12),

              // ORDER LIST
              Expanded(
                child: toShipOrders.isEmpty
                    ? const Center(
                        child: Text(
                          'No "To Ship" orders found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: toShipOrders.map((order) {
                            final item = (order['items'] as List).isNotEmpty
                                ? order['items'][0] as Map<String, dynamic>
                                : null;
                            if (item == null) return const SizedBox.shrink();

                            final imageUri =
                                item['image'] as String? ??
                                'https://via.placeholder.com/100';
                            final productName =
                                item['productName'] ?? 'Product';
                            final qty = item['quantity'] ?? 1;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: grayBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To Ship',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: accent,
                                        ),
                                      ),
                                      Text(
                                        _formatShort(
                                          order['createdAt'] as DateTime,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUri,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, err, stack) =>
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: placeholderGray,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Size: ${(item['size'] ?? '—')}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Qty: $qty',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total Payment:',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  '₱${order['total'] ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: accent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Flexible(
                                        child: Text(
                                          'Waiting for courier to confirm\nshipment',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          'View Shipping Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order ID: ${order['id']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _copyToClipboard(order['id']),
                                        icon: const Icon(
                                          Icons.copy,
                                          color: Color(0xFF9747FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => _confirmCancelOrder(order),
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: grayBg,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: accent,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Cancel Order',
                                          style: TextStyle(
                                            color: accent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

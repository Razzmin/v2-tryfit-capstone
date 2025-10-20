// orders_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your actual separate pages
import 'to_ship_page.dart';
import 'completed_page.dart';
import 'cancelled_page.dart';

/// OrdersPage = the "To Receive" screen.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const String activeTab = 'To Receive';
  final List<String> tabs = ['To Ship', 'To Receive', 'Completed', 'Cancelled'];

  final List<Map<String, dynamic>> orders = [
    {
      'id': '1',
      'status': 'To Ship',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'items': [
        {
          'productName': 'Purple Hoodie',
          'size': 'M',
          'quantity': 1,
          'color': 'Violet',
        },
      ],
      'address': '123 Rainbow Street, Enchanted City',
      'expectedDelivery': 'Oct 25, 2025',
      'total': 799,
    },
    {
      'id': '2',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'items': [
        {
          'productName': 'Denim Pants',
          'size': 'L',
          'quantity': 2,
          'color': 'Blue',
        },
      ],
      'address': '456 Ocean Drive, Mystic Village',
      'expectedDelivery': 'Oct 10, 2025',
      'total': 1200,
    },
    {
      'id': '3',
      'status': 'To Receive',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'items': [
        {
          'productName': 'Casual Tee',
          'size': 'S',
          'quantity': 1,
          'color': 'White',
        },
      ],
      'address': '789 Starlane, Dreamtown',
      'expectedDelivery': 'Oct 20, 2025',
      'total': 350,
    },
  ];

  List<Map<String, dynamic>> get _toReceiveOrders =>
      orders.where((o) => o['status'] == 'To Receive').toList();

  void _onTabTap(String tab) {
    if (tab == activeTab) return;

    Widget target;
    switch (tab) {
      case 'To Ship':
        target = const ToShipPage();
        break;
      case 'Completed':
        target = const CompletedPage();
        break;
      case 'Cancelled':
        target = const CancelledPage();
        break;
      default:
        return;
    }

    // Replace instead of pushing to prevent stacking multiple pages
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _toReceiveOrders;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
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

              // Tabs
              SizedBox(
                height: 44,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tabs.map((tab) {
                      final isActive = tab == activeTab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onTabTap(tab),
                            child: Container(
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
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isActive
                                          ? const Color(0xFF9747FF)
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 3,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFF9747FF)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // To Receive Content
              Expanded(
                child: displayed.isEmpty
                    ? Center(
                        child: Text(
                          'No orders in "To Receive".',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayed.length,
                        itemBuilder: (context, index) {
                          final order = displayed[index];
                          final item = (order['items'] as List).isNotEmpty
                              ? order['items'][0]
                              : null;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order['status'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9747FF),
                                      ),
                                    ),
                                    Text(
                                      (order['createdAt'] as DateTime)
                                          .toString()
                                          .substring(0, 16),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Product row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECECEC),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item != null
                                                ? item['productName'] ?? ''
                                                : 'Item',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          if (item != null) ...[
                                            Text(
                                              "Size: ${item['size']}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Qty: ${item['quantity']}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "Color: ${item['color']}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                Text(
                                  "Delivery Address: ${order['address']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      "Expected Delivery: ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      order['expectedDelivery'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF9747FF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Payment:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₱${order['total']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9747FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

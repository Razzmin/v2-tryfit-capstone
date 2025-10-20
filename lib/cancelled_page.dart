import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_page.dart';
import 'to_ship_page.dart';
import 'completed_page.dart';
import 'homepage.dart'; // ✅ make sure this file exists

class CancelledPage extends StatefulWidget {
  const CancelledPage({super.key});

  @override
  State<CancelledPage> createState() => _CancelledPageState();
}

class _CancelledPageState extends State<CancelledPage> {
  final String activeTab = 'Cancelled';

  final List<Map<String, dynamic>> cancelledOrders = [
    {
      'id': '1',
      'status': 'Cancelled',
      'date': '10/10/2025',
      'item': {
        'name': 'Slim Fit Jeans',
        'image': 'https://placehold.co/100x100',
        'quantity': 1,
        'size': 'Medium',
      },
      'total': 999,
    },
    {
      'id': '2',
      'status': 'Cancelled',
      'date': '10/12/2025',
      'item': {
        'name': 'Casual Shirt',
        'image': 'https://placehold.co/100x100',
        'quantity': 2,
        'size': 'Large',
      },
      'total': 1200,
    },
  ];

  void _navigateTo(String tab) {
    Widget target;

    switch (tab) {
      case 'To Ship':
        target = const ToShipPage();
        break;
      case 'To Receive':
        target = const OrdersPage();
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF9747FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // ✅ Navigate to Homepage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Homepage()),
                      );
                    },
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

              const SizedBox(height: 10),

              // CANCELLED ORDERS
              Expanded(
                child: cancelledOrders.isEmpty
                    ? const Center(
                        child: Text(
                          'No cancelled orders found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cancelledOrders.length,
                        itemBuilder: (context, index) {
                          final order = cancelledOrders[index];
                          final item = order['item'];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // CARD HEADER
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order['status'],
                                      style: const TextStyle(
                                        color: Color(0xFF9747FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      order['date'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // PRODUCT ROW
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[300],
                                        image: DecorationImage(
                                          image: NetworkImage(item['image']),
                                          fit: BoxFit.cover,
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
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item['size'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'Qty: ${item['quantity']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Total Payment:',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '₱${order['total']}',
                                                style: const TextStyle(
                                                  color: Color(0xFF9747FF),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                // BUTTONS ROW
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Cancellation Details
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // TODO: show cancellation details
                                      },
                                      child: const Text(
                                        'Cancellation Details',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Buy Again
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF9747FF),
                                          width: 1,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
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
                                        'Buy Again',
                                        style: TextStyle(
                                          color: Color(0xFF9747FF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
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

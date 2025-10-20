// completed_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'to_ship_page.dart';
import 'orders_page.dart'; // To Receive
import 'cancelled_page.dart';
import 'homepage.dart'; // Make sure this file exists

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final String activeTab = 'Completed';
  final Color accent = const Color(0xFF9747FF);

  final List<Map<String, dynamic>> orders = [
    {
      'id': 'C-1001',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'items': [
        {
          'productName': 'Purple Hoodie',
          'image': 'https://placehold.co/100x100',
          'size': 'M',
          'quantity': 1,
          'color': 'Violet',
        },
      ],
      'total': 799,
      'userId': 'user-123',
      'deliveryFee': 50,
    },
    {
      'id': 'C-1002',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      'items': [
        {
          'productName': 'Denim Pants',
          'image': 'https://placehold.co/100x100',
          'size': 'L',
          'quantity': 2,
          'color': 'Blue',
        },
      ],
      'total': 1200,
      'userId': 'user-123',
      'deliveryFee': 70,
    },
  ];

  void _navigateTo(String tab) {
    if (tab == activeTab) return;

    Widget target;
    switch (tab) {
      case 'To Ship':
        target = const ToShipPage();
        break;
      case 'To Receive':
        target = const OrdersPage();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              // Header: back arrow + My Purchases (Krona One)
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Homepage()),
                    ),
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

              const SizedBox(height: 12),

              // Tabs
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
                            margin: const EdgeInsets.only(right: 28),
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

              const SizedBox(height: 6),

              // Orders
              Expanded(
                child: orders.isEmpty
                    ? const Center(
                        child: Text(
                          'No completed orders found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: orders.map((order) {
                            final item = (order['items'] as List).isNotEmpty
                                ? order['items'][0]
                                : null;
                            if (item == null) return const SizedBox.shrink();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9747FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Product Row
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.grey[300],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              item['image'] ??
                                                  'https://placehold.co/100x100',
                                            ),
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
                                              item['productName'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Size: ${item['size'] ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Qty: ${item['quantity'] ?? 1}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Color: ${item['color'] ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Total
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Payment:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '₱${order['total'] ?? 0}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9747FF),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Rate
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            'ToRate',
                                            arguments: {
                                              'orderData': order,
                                              'items': order['items'],
                                              'userId': order['userId'],
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 30,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF7F7F7),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(color: accent),
                                          ),
                                          child: Text(
                                            'Rate',
                                            style: TextStyle(
                                              color: accent,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      // Buy Again
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            'ReCheckout',
                                            arguments: {
                                              'selectedItems': order['items'],
                                              'total': order['total'],
                                              'deliveryFee':
                                                  order['deliveryFee'],
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accent,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'Buy Again',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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

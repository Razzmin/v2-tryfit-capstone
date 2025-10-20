import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    // Example data (replace with API or local storage later)
    notifications = [
      {
        "id": "1",
        "type": "cart",
        "message": "Item added to cart successfully.",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
      },
      {
        "id": "2",
        "type": "order",
        "message": "Your order #2548 has been placed!",
        "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        "id": "3",
        "type": "shipped",
        "message": "Order #2548 is on its way.",
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "id": "4",
        "type": "ready",
        "message": "Your parcel is ready for pickup.",
        "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      },
    ];
  }

  Icon getIcon(String type) {
    switch (type) {
      case "cart":
        return const Icon(
          Icons.shopping_cart,
          color: Color(0xFF9747FF),
          size: 20,
        );
      case "order":
        return const Icon(
          Icons.receipt_long,
          color: Color(0xFF4CAF50),
          size: 20,
        );
      case "shipped":
        return const Icon(
          Icons.inventory_2,
          color: Color(0xFF2196F3),
          size: 20,
        );
      case "ready":
        return const Icon(
          Icons.check_circle,
          color: Color(0xFFFF9800),
          size: 20,
        );
      default:
        return const Icon(Icons.notifications, color: Colors.grey, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Text(
                    "Notification",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 30),

              // Notification List
              Expanded(
                child: notifications.isEmpty
                    ? const Center(
                        child: Text(
                          "No notifications yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          final formattedTime = DateFormat(
                            'hh:mm a',
                          ).format(item['timestamp']);
                          final formattedDate = DateFormat(
                            'MM/dd/yyyy',
                          ).format(item['timestamp']);

                          return Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    getIcon(item['type']),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item['message'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "$formattedTime • $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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

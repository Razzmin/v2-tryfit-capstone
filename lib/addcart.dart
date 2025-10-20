import 'package:flutter/material.dart';
import 'package:tryfit_capstone/checkout.dart';

class Addcart extends StatefulWidget {
  const Addcart({super.key});

  @override
  State<Addcart> createState() => _AddcartState();
}

class _AddcartState extends State<Addcart> {

  // Dummy cart items for now
  List<Map<String, dynamic>> cartItems = [
    {
      "id": "1",
      "productId": "p1",
      "productName": "Stylish Shirt",
      "price": 290,
      "quantity": 1,
      "selected": true,
    },
    {
      "id": "2",
      "productId": "p2",
      "productName": "Cool Jeans",
      "price": 450,
      "quantity": 2,
      "selected": false,
    },
  ];

    // Functions that mimic Firebase actions
  void increaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] < 20) item['quantity']++;
    });
  }

  void decreaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) item['quantity']--;
    });
  }

  void toggleSelected(Map<String, dynamic> item) {
    setState(() {
      item['selected'] = !(item['selected'] ?? false);
    });
  }

  void removeFromCart(String id) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = 
    cartItems.where((item) => item['selected'] == true).toList();
    final totalQuantity = 
    selectedItems.fold<int>(0, (sum, item) => sum + item['quantity'] as int);
    final totalPrice = 
    selectedItems.fold<int>(0, (sum, item) => sum + item['price'] * item['quantity']as int);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(iconSize: 30,
          icon: Icon(Icons.navigate_before, color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Shopping Cart",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
          IconButton(
            
            icon: Icon(Icons.delete_outline, color: Colors.black),
              onPressed: () {
      setState(() {
        cartItems.removeWhere((item) => item['selected'] == true);
      });
    },
          ),
      ],
      ),
      body: cartItems.isEmpty
      ? Center(child: 
      Text("Your cart is empty", style: TextStyle(fontSize: 17),))
      : ListView.builder(
        padding: EdgeInsets.only(bottom: 150),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Align(
                  alignment: Alignment.center,
              child: Center (
             child: GestureDetector(
                onTap: () => toggleSelected(item),
                child: Icon(
                  item['selected'] == true
                  ? Icons.check_box : Icons.check_box_outline_blank,
                  color: item['selected'] == true
                  ? Color(0xFF9747FF) : Colors.black,
                  size: 28,
                ),
              ),  
              ),
              ),
              SizedBox(width: 10),

              Container(
              width: 90,
              height: 90,
              color: Colors.grey[200],
              child: Icon(Icons.image,size: 40, color: Colors.grey[600]),
              ),
              SizedBox(width:12),


              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text(item['productName'] ?? 'Product',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Size:M", style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₱${item['price']}",
                  style: TextStyle(
                    color:  Color(0xFF9747FF), fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      IconButton(
                         onPressed: () => decreaseQuantity(item),
                          icon: Icon(Icons.remove),
                          ),
                          Text(
                            "${item['quantity']}",
                             style: TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () => increaseQuantity(item),
                              icon: Icon(Icons.add),
                              ),                    
                             ],
                            ),
                          ],
                   ),
              ],
                ),
              ),

              ],
          ),
      ),
    );
        },
      ),
     bottomSheet: cartItems.isNotEmpty
    ? Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 140, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Items: $totalQuantity",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Total: ₱$totalPrice",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9747FF)),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: selectedItems.isEmpty ? null : () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => Checkout(
                selectedItems: selectedItems,
                total: totalPrice.toDouble(),
                ),
                ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9747FF),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Checkout Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                
              ),
            ),
          ],
        ),
      )
    : null,
    );
  }
}
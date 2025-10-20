import 'package:flutter/material.dart';
import 'package:tryfit_capstone/checkoutsummary.dart';

class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems; // list of items selected
  final double total; //total price

  const Checkout({super.key, required this.selectedItems, required this.total});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<Map<String, dynamic>> checkoutItems = []; //stores items na chineckout
  Map<String, dynamic>? shippingLocation; //stores user shipping address
  bool showPopup = false; //pop up message mamaya  after magcheckout
  
  @override
  void initState() {
    super.initState();
    //copies selected items galing cart to checkout list
    checkoutItems = List.from(widget.selectedItems);
  }
  
  //function para magdelete yung ekis
  void handleDelete(String id) {
    setState(() {
      checkoutItems.removeWhere((item) => item['id'] == id);
    });
  }
  @override
  Widget build(BuildContext context) {
     double deliveryFee = 58;
     double totalWithDelivery = widget.total + deliveryFee;
  

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
        "Checkout",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
        ),

        body: SingleChildScrollView(// changed
        padding: const EdgeInsets.only(left: 16, right: 16, top:16, bottom: 140),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
               padding: const EdgeInsets.all(8),
                itemCount: checkoutItems.length,
                itemBuilder:(context, index) {
                  final item = checkoutItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[200],
                      child: Icon(Icons.image,size: 40, color: Colors.grey[600]),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              item['name'] ?? 'Product Name',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis, //para di magoverflow kapag long text
                          ),
                          ),
                          GestureDetector(
                            onTap: () => handleDelete(item['id']),
                            child: const Icon(Icons.close, size: 18),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Size: ${item['size'] ?? '-'}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₱${item['price'] ?? 0}",
                          style: TextStyle(
                            color: Color(0xFF9747FF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "x${item['quantity'] ?? 1 }",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey),
                            ),
                      ],
                        ),
                      ],
                      ),
              ),
                      ],
                ),
                  );
                },
                ),
        
         const SizedBox(height: 20),

          const Text(
            "Shipping Address",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold)),
            const SizedBox(height:8),

            GestureDetector(
              onTap: () {
                //later navigate sa address screen
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                ),
                child: shippingLocation == null ? 
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("No shipping address saved."),
                      Text("Tap here to add one."),
                  ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("${shippingLocation!['name']} (${shippingLocation!['phone']}"),
                        Text(shippingLocation!['house']),
                        Text(shippingLocation!['fullAddress']),
                    ],
                  ),
              ),
            ),

                  const SizedBox(height: 25),
                  const Text(
                    "Delivery Method",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("LOCAL STANDARD SHIPPING: ₱58"),
                  const Text("Delivered within 2-3 days",
                  style: TextStyle(fontSize: 12, color: Colors.black)),
                  
                  const SizedBox(height: 150),
                    ],
                    ),
                   ),
          
              bottomSheet: Container(
                height: 130,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:", style: TextStyle(fontSize: 16)),
                          Text(
                            "₱$totalWithDelivery",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9747FF),
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: () {
                            Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Checkoutsummary(total: totalWithDelivery),
                            ),
                           ); //navigate muna pa checkout summary
                          setState(() {
                            showPopup = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xFF9747FF),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Proceed", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                  ),
                  );
  }
}
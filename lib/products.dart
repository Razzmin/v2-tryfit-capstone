import 'package:flutter/material.dart';
import 'package:tryfit_capstone/addcart.dart';

//dummy data for now
final Map<String, dynamic> product = {
  "id": "1",
  "name": "Stylish Shirt",
  "price" :  290,
  "imageUrl" :  "https://placehold.co/300x300/png",
  "description" :  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  "rating" :  4.8,
  "sold" :  23,
  "sizes": {"S": 5, "M": 10, "L": 7 },
};

final List<Map<String, dynamic>> reviews = [
  {
    "id": "r1",
    "username": "Alice",
    "size": "M",
    "comment": "Great fit, very comfortable!",
    "rating": 5
  },
  {
    "id": "r2",
    "username": "Bob",
    "size": "L",
    "comment": "Good quality, but color is slightly off.",
    "rating": 4
  },
  {
    "id": "r3",
    "username": "Charlie",
    "size": "S",
    "comment": "Loved it! Will buy again.",
    "rating": 5
  },
];

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String? selectedSize;
  int quantity = 1;
  bool showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () => Navigator.pop(context),
      ),
      title: Text (
        "Cloth Details",
        style: TextStyle(
          color: Colors.black
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () =>  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Addcart()),
                  ),
            )
        ],
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "https://placehold.co/300x300/png", width: double.infinity,
               height: 300, fit: BoxFit.cover),
               Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product["name"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text("₱${product["price"]}", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Color(0xFF9747FF))),
                      ],
                    ),
                    SizedBox(height: 8),

                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product["rating"].round() ? Icons.star : Icons.star_border,
                              color: Colors.amberAccent,
                              size: 18,
                            );
                          }),
                        ),
                        SizedBox(width: 8),
                        Text("| ${product["sold"]} Sold",
                         style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),

                    SizedBox(height: 17),

                    Text("Cloth Description",
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...product["description"].split("\n").map((line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text("• $line"),
                      )),

                      SizedBox(height: 16),

                      //reviews
                      Text("Reviews",
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                      SizedBox(height:8),
                      ...((showAllReviews ? reviews : reviews.take(3)).toList()).map((review) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[600],
                              child: Text(review["username"][0].toUpperCase(),
                               style: TextStyle(color: Colors.white)),
                            ),

                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(review["username"],
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < review["rating"] ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 14,
                                          );
                                        }),
                                        )
                                    ],
                                  ),

                                  Text("Size: ${review["size"]}", 
                                  style: TextStyle(color: Colors.grey[350])),
                                  SizedBox(height: 4),
                                  Text(review["comment"]),
                                ],
                              ),
                              )
                          ],
                        ),
                        )),
                        if (reviews.length >3 )
                        Center (
                          child: TextButton(
                            onPressed: () => setState(() => showAllReviews = !showAllReviews),
                            child: Text(
                              showAllReviews ? "Hide Reviews" : "Show More Reviews",
                               style: TextStyle(color: Colors.purple)),
                          ),
                        ),
                        ],
                      ),
                      ),
                      ],
                    ),
                  ),
        bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        color: Colors.white,
        child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9747FF),
                foregroundColor: Colors.white,
                minimumSize: Size.fromHeight(45)),
              child: Text("Add to Cart", 
              style: TextStyle(fontSize: 16),),
              onPressed:() => _showAddToCartModal(context, this)
              ),
              
              ),

              SizedBox(width: 16),
              Expanded (
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9747FF),
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(45)),
                  child: Text("Try-on", style: TextStyle(fontSize: 16),),
                  onPressed: () {},
                  ),
                  ), 
        ],
      ),
    ),
);
  }
}

    void _showAddToCartModal(BuildContext context, _ProductsState parentState) {
    showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return Container (
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Image.network(
                      product["imageUrl"],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child:Text(product["name"], 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Available Size: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(width: 10),
                Wrap(
                  spacing: 18,
                  children: product["sizes"].keys.map<Widget>((size) {
                    final isSelected = parentState.selectedSize == size;
                    return ChoiceChip(
                      label: Text(size, 
                      ),
                       selected: isSelected,
                       onSelected: (_) => setModalState(()  => parentState.selectedSize = size),
                       selectedColor: Colors.purple,
                       disabledColor: Colors.grey[200],
                       labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                       ),
                       );
                  }).toList(),
                ),
                ],
),
                SizedBox(height: 30),

                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                    Text("Quantity: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    SizedBox(width: 10),
                    IconButton( 
                      color: Color(0xFF9747FF),
                      iconSize: 20,
                      onPressed: () => setModalState (() => parentState.quantity = parentState.quantity > 1 ? parentState.quantity -1 : 1),
                       icon: Icon(Icons.remove),
                       ),
                    Text(parentState.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 )
                    ),
                     SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Color(0xFF9747FF),
                      iconSize: 20,
                      onPressed: () => setModalState(() {
                        if (parentState.selectedSize != null &&
                         parentState.quantity < product["sizes"][parentState.selectedSize]) {
                          parentState.quantity++;
                         }  
                      }),
                      ),
                  ],
                ),
                 Padding(
              padding: const EdgeInsets.only(right: 15.0), 
              child: Text(
                  "Stock: ${parentState.selectedSize != null ? product["sizes"][parentState.selectedSize] : '-'}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              )
                ),
                  ],
), 
          SizedBox(height: 10),
            Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF9747FF),
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(50)),
                    onPressed: () {
                      if (parentState.selectedSize == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            content: Text("Please select a size"),
                            ),
                            );
                        return;
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text("Added to cart"),
                        ),
                      );
                    },
                    child: Text("Add to Cart"),
                ),
                ),
              ],
            ),
          );
      },
      ),
      );
}


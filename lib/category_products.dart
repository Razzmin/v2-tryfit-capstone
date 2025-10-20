import 'package:flutter/material.dart';
import 'package:tryfit_capstone/homepage.dart';
import 'package:tryfit_capstone/products.dart';
import 'dart:developer' as developer;


class CategoryProducts extends StatefulWidget {
  final String selectedCategory; //passed from navbar or buttons

  const CategoryProducts({super.key, this.selectedCategory = 'T-shirts'});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  late String activeCategory;

   // sample products – later you can fetch real ones from Firebase or your DB
  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    "Popular": [
      {
        "name": "Classic White Tee",
        "price": 250,
        "rating": 4.8,
        "sold": "2.5K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=White+Tee",
      },
    ],
    "Latest": [
      {
        "name": "New Drop Hoodie",
        "price": 500,
        "rating": 4.7,
        "sold": "1.2K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=Hoodie",
      },
    ],
    "T-shirts": [
      {
        "name": "Plain Black Shirt",
        "price": 299,
        "rating": 4.9,
        "sold": "3.2K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=T-shirt",
      },
    ],
    "Longsleeves": [
      {
        "name": "Men’s Longsleeve Polo",
        "price": 399,
        "rating": 4.5,
        "sold": "1.1K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=Longsleeve",
      },
    ],
    "Shorts": [
      {
        "name": "Denim Shorts",
        "price": 350,
        "rating": 4.6,
        "sold": "2.3K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=Shorts",
      },
    ],
    "Pants": [
      {
        "name": "Cargo Pants",
        "price": 499,
        "rating": 4.8,
        "sold": "5K",
        "delivery": "3-5 Days",
        "imageUrl": "https://via.placeholder.com/200x200.png?text=Pants",
      },
    ],
  };

  final List<String> categories = [
    "Popular",
    "Latest",
    "T-shirts",
    "Longsleeves",
    "Shorts",
    "Pants",
  ];

  @override
  void initState() {
    super.initState();
    activeCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       body: Stack(
    children: [
      Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: 
            AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
            ),
          ),
      ),
        SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.navigate_before, color: Colors.black),
                        iconSize: 30,
                        onPressed:() {
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child:  Text(
                      activeCategory, style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    ),
                   SizedBox(width: 40),
                  ],
                  ),
                  const  SizedBox(height: 12),
                  
                  //category buttons
                    SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                      final category = categories[index];
                      final bool isActive = category == activeCategory;
                        return Padding (
                       padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                          onPressed: () { 
                            setState(() {
                              activeCategory = category; 
                            });
                            developer.log("Switched to $activeCategory");

                          },
                           style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF9747FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: isActive ? Colors.white.withAlpha(150) :
                          Colors.white.withAlpha(80),
                          ),
                            child: Text(
                            category,
                            style: TextStyle(color: Colors.black, fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          ),
                        );
                      },
                    ),
                      ),
                    const SizedBox(height: 20),

                    //product grid
                    Expanded(
                      child: Builder
                      (builder: (_) {
                        final products = categoryProducts[activeCategory] ?? [];
                        developer.log("Rendering products for $activeCategory (${products.length})");

                        return products.isEmpty 
                        ? const Center(
                        child: Text("No products found"))
                        : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7
                      ),
                       itemBuilder: (context, index){
                        final product = products[index];
                           return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => Products(),
                              ), 
                              );
                          },
                            child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(230),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)
                                  ),
                                  child: SizedBox( 
                                    height: 140, 
                                    width: double.infinity,
                                   child: Image.network(
                                    product['imageUrl'] ?? '-',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context,error,stack) =>
                                    Container(
                                      color:  Colors.grey[300],
                                      height: 140,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    ),
                                    ),
                                    ),
                       Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                              product['name'] ?? 'Unnamed',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                     const SizedBox(height: 4),
                                          Text(
                                            "₱${product['price'] ?? 'N/A'}",
                                             style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF9747FF),
                                              ),
                                          ),
                                         const SizedBox(height: 4),
                                         Text(
                                           " ⭐ ${product['rating'] ?? '-'} | ${product['sold'] ?? '0'} Sold",
                                                style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                              ),
                                           const SizedBox(height: 4),
                                              Text(
                                                  " 🚚 ${product['delivery'] ?? 'N/A'}",
                                                  style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54
                                                  ),                     
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        );
                       },
                     );

                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
    ),
    );
  }
}
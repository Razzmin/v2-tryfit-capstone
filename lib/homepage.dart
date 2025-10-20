// homepage.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tryfit_capstone/addcart.dart';
import 'edit_profile_page.dart';
import 'orders_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestions = [
    'T-Shirts',
    'Longsleeves',
    'Pants',
    'Shorts',
  ];
  List<String> _filteredSuggestions = [];

  Color purple = const Color(0xFF9747FF);
  Color lightBg = const Color(0xFFDEDEDE);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFC7A3FF),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void handleSearch(String text) {
    setState(() {
      _filteredSuggestions = text.isEmpty
          ? []
          : _suggestions
                .where((s) => s.toLowerCase().contains(text.toLowerCase()))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color.fromRGBO(162, 89, 251, 0.91)),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.transparent),
            ),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(top: 30),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "CATEGORIES",
                      style: GoogleFonts.kronaOne(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _categorySection("Tops", ["T-Shirts", "Longsleeves"]),
                  _categorySection("Bottoms", ["Pants", "Shorts"]),
                ],
              ),
            ),
          ],
        ),
      ),

      // Home content
      body: _homeContent(),

      // Bottom navigation bar — updated to use AddCart
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.house, color: purple),
            ),
            IconButton(
              onPressed: () {
                // ✅ Navigate to AddCart page (replace current)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Addcart()),
                );
              },
              icon: Icon(FontAwesomeIcons.cartShopping, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersPage()),
                );
              },
              icon: Icon(FontAwesomeIcons.boxOpen, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.user, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFC7A3FF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "TRYFIT",
                      style: GoogleFonts.kronaOne(
                        fontSize: 28,
                        color: Colors.black,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.bars,
                            color: Colors.black,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: handleSearch,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            filled: true,
                            fillColor: lightBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.comments,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  if (_filteredSuggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        children: _filteredSuggestions
                            .map(
                              (s) => ListTile(
                                title: Text(s),
                                onTap: () {
                                  _searchController.text = s;
                                  setState(() => _filteredSuggestions = []);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("New Arrivals"),
                    productList(180, 130),
                    sectionTitle("Popular"),
                    popularList(),
                    sectionTitle("Our Picks for You"),
                    gridProducts(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categorySection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                title,
                style: GoogleFonts.kronaOne(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Text(
      title,
      style: GoogleFonts.kronaOne(
        fontSize: 16,
        color: Colors.black,
        letterSpacing: 1,
      ),
    ),
  );

  // ✅ Placeholder product list (gray boxes)
  Widget productList(double height, double width) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 12),
          width: width,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ✅ Placeholder popular list (gray circles)
  Widget popularList() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0E0E0),
                radius: 40,
              ),
              const SizedBox(height: 5),
              Text(
                "Item $index",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Placeholder grid products (gray rectangles)
  Widget gridProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product $index",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₱${(index + 1) * 100}",
                      style: TextStyle(color: purple),
                    ),
                    const Text(
                      "⭐ 4.8 • 1.2k Sold",
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      "🚚 Free Delivery",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

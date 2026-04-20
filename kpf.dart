import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpf/product/categories.dart';
import 'package:kpf/database/userprovider.dart';

import 'package:kpf/product/card.dart';
import 'package:kpf/screens/page2.dart';
import 'package:kpf/profiles/profile.dart';
import 'package:provider/provider.dart';

class Kpf extends StatefulWidget {
  const Kpf({super.key});

  @override
  State<Kpf> createState() => _KpfState();
}

class _KpfState extends State<Kpf> with TickerProviderStateMixin {
  int currentIndex = 0;
  int _selectedCategory = 0; // ✅ Active category index
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> allProducts = [
    {
      "image": "lib/images/pic7.jpg",
      "name": "Women's Air Peg 2K35",
      "price": "\$146",
      "tag": "New",
      "rating": 4.8,
      "category": "Running", // ✅ Category added
    },
    {
      "image": "lib/images/pic2.jpg",
      "name": "Women's Free Run Evo 3",
      "price": "\$124",
      "tag": "Hot",
      "rating": 4.6,
      "category": "Running", // ✅ Category added
    },
    {
      "image": "lib/images/pic5.jpg",
      "name": "Air Jordan 1 Mid",
      "price": "\$160",
      "tag": "Sale",
      "rating": 4.9,
      "category": "Jordan", // ✅ Category added
    },
    {
      "image": "lib/images/pic6.jpg",
      "name": "Nike Air Max",
      "price": "\$140",
      "tag": "Popular",
      "rating": 4.7,
      "category": "Air Max", // ✅ Category added
    },
  ];

  // ✅ Category list
  final List<String> _categoryList = [
    "All",
    "Running",
    "Jordan",
    "Air Max",
    "Casual"
  ];

  // ✅ Filter by both category AND search query
  List<Map<String, dynamic>> get filteredProducts {
    final selected = _categoryList[_selectedCategory];

    List<Map<String, dynamic>> list = selected == "All"
        ? List.from(allProducts)
        : allProducts.where((p) => p["category"] == selected).toList();

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p["name"].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  @override
  void initState() {
    super.initState();

    debugPrint("══════════════════════════════");
    debugPrint("🏠 HOME SCREEN OPENED");
    debugPrint("   Total Products : ${allProducts.length}");
    debugPrint("══════════════════════════════");

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      if (_searchController.text.isNotEmpty) {
        debugPrint(
            "🔍 Search query: ${_searchController.text}  |  Results: ${filteredProducts.length}");
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFF5F9F6),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 8),
                Expanded(
                  child:
                      isSearching ? _buildSearchResults() : _buildHomeContent(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu_rounded,
                    color: Color(0xFF2E7D32), size: 22),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                "IRONACHLE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 2,
                ),
              ),
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _headerIcon(Icons.shopping_cart_outlined, () {
                debugPrint("🛒 Cart icon tapped from Home");
                navigateTo(CartScreen());
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: _searchController,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Search shoes, brands...",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded,
                color: Color(0xFF4CAF50), size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.grey, size: 20),
                  )
                : const Icon(Icons.tune_rounded,
                    color: Color(0xFF4CAF50), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = filteredProducts;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No results for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Text(
            "${results.length} result${results.length != 1 ? 's' : ''} found",
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = results[index];
              return _buildSearchResultCard(p);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () {
        debugPrint("══════════════════════════════");
        debugPrint("🔍 SEARCH RESULT TAPPED");
        debugPrint("   Name  : ${p["name"]}");
        debugPrint("   Price : ${p["price"]}");
        debugPrint("══════════════════════════════");
        navigateTo(
            Page2(image: p["image"], name: p["name"], price: p["price"]));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: const Color(0xFFF5F9F6),
                child: Image.asset(p["image"], fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p["name"],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFC107), size: 14),
                      const SizedBox(width: 3),
                      Text(
                        p["rating"].toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p["price"],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "View",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    // ✅ Show empty state when category has no products
    final products = filteredProducts;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSaleBanner(),
          const SizedBox(height: 22),
          _buildCategoryChips(), // ✅ Now interactive
          const SizedBox(height: 22),
          _buildQuickScroll(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 0
                      ? "Trending Now 🔥"
                      : "${_categoryList[_selectedCategory]} Shoes 👟",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // ✅ Empty state when no products in category
          products.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          "No shoes in ${_categoryList[_selectedCategory]}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildProductGrid(products), // ✅ Pass filtered products
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSaleBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF00897B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "LIMITED OFFER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Big Sale\nUp to 75% OFF",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Grab Now →",
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "lib/images/pic1.jpg",
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FIXED: Category chips ab setState ke saath kaam karenge
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: _categoryList.length,
        itemBuilder: (context, i) {
          final selected = i == _selectedCategory; // ✅ State se check
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = i; // ✅ State update hoti hai
              });
              debugPrint("🏷️  Category tapped: ${_categoryList[i]}");
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF00897B)])
                    : null,
                color: selected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: selected
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                _categoryList[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickScroll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Featured",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              final p = allProducts[index];
              return GestureDetector(
                onTap: () {
                  debugPrint("══════════════════════════════");
                  debugPrint("⚡ FEATURED PRODUCT TAPPED");
                  debugPrint("   Name  : ${p["name"]}");
                  debugPrint("   Price : ${p["price"]}");
                  debugPrint("══════════════════════════════");
                  navigateTo(Page2(
                      image: p["image"], name: p["name"], price: p["price"]));
                },
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(p["image"], fit: BoxFit.contain),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          p["price"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ FIXED: filtered products accept karta hai ab
  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () {
              debugPrint("══════════════════════════════");
              debugPrint("🔥 TRENDING PRODUCT TAPPED");
              debugPrint("   Name     : ${p["name"]}");
              debugPrint("   Price    : ${p["price"]}");
              debugPrint("   Tag      : ${p["tag"]}");
              debugPrint("   Rating   : ${p["rating"]}");
              debugPrint("   Category : ${p["category"]}");
              debugPrint("══════════════════════════════");
              navigateTo(
                  Page2(image: p["image"], name: p["name"], price: p["price"]));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Container(
                            width: double.infinity,
                            color: const Color(0xFFF5F9F6),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(p["image"], fit: BoxFit.contain),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p["tag"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_border_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p["name"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p["price"],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFFFC107), size: 13),
                                const SizedBox(width: 2),
                                Text(
                                  p["rating"].toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
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
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Consumer<UserProvider>(
        builder: (context, user, _) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: user.imagePath != null
                            ? (kIsWeb
                                ? Image.network(user.imagePath!,
                                    fit: BoxFit.cover)
                                : Image.file(File(user.imagePath!),
                                    fit: BoxFit.cover))
                            : const Icon(Icons.person,
                                size: 40, color: Color(0xFF2E7D32)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "⭐ Premium Member",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _drawerItem(Icons.person_rounded, "Profile", () {
                debugPrint("👤 Profile opened from Drawer");
                Navigator.pop(context);
                navigateTo(const ProfileScreen());
              }),
              _drawerItem(Icons.category_rounded, "Categories", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(),
                    ));
              }),
              _drawerItem(Icons.shopping_cart_rounded, "Cart", () {
                debugPrint("🛒 Cart opened from Drawer");
                Navigator.pop(context);
                navigateTo(CartScreen());
              }),
              const Spacer(),
              Divider(color: Colors.grey[200]),
              _drawerItem(Icons.logout_rounded, "Logout", () {
                debugPrint("🚪 Logout from Drawer");
                Navigator.pop(context);
              }, isLogout: true),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.08)
              : const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            color: isLogout ? Colors.red : const Color(0xFF4CAF50), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isLogout ? Colors.red : const Color(0xFF1A1A2E),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        onTap: (index) {
          setState(() => currentIndex = index);
          const tabs = ["Home", "Categories", "Wishlist", "Profile"];
          debugPrint("📍 Bottom nav tapped: ${tabs[index]}");
          if (index == 3) navigateTo(const ProfileScreen());
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: "Wishlist"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}

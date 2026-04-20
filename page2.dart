import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpf/product/card.dart';


class Page2 extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  const Page2({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with TickerProviderStateMixin {
  int _selectedSize = 9;
  String _selectedColor = "Brown";
  bool _isFavorite = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<int> sizes = [7, 8, 9, 10, 11, 12];

  final List<Map<String, dynamic>> colors = [
    {"name": "Brown", "color": const Color(0xff8B4513)},
    {"name": "Black", "color": Colors.black},
    {"name": "Tan", "color": const Color(0xffD2B48C)},
  ];

  @override
  void initState() {
    super.initState();

    debugPrint("══════════════════════════════");
    debugPrint("👟 PRODUCT OPENED");
    debugPrint("   Name  : ${widget.name}");
    debugPrint("   Price : ${widget.price}");
    debugPrint("   Image : ${widget.image}");
    debugPrint("══════════════════════════════");

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: Column(
        children: [
          _buildImageSection(context),
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 20),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              widget.price,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => const Icon(Icons.star_rounded,
                                  color: Color(0xFFFFC107), size: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "4.8  •  238 reviews",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _sectionLabel("Select Color"),
                        const SizedBox(height: 12),
                        Row(
                          children: colors.map((colorData) {
                            final isSelected =
                                _selectedColor == colorData["name"];
                            return GestureDetector(
                              onTap: () {
                                setState(
                                    () => _selectedColor = colorData["name"]);
                                debugPrint(
                                    "🎨 Color selected: ${colorData["name"]}  |  Product: ${widget.name}");
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorData["color"],
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4CAF50)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF4CAF50)
                                                .withOpacity(0.4),
                                            blurRadius: 10,
                                          )
                                        ]
                                      : [],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _sectionLabel("Select Size"),
                            const Text(
                              "Size Guide →",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: sizes.map((size) {
                            final isSelected = _selectedSize == size;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedSize = size);
                                debugPrint(
                                    "📐 Size selected: $size  |  Color: $_selectedColor  |  Product: ${widget.name}");
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(colors: [
                                          Color(0xFF4CAF50),
                                          Color(0xFF00897B),
                                        ])
                                      : null,
                                  color: isSelected
                                      ? null
                                      : const Color(0xFFF5F9F6),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF4CAF50)
                                                .withOpacity(0.4),
                                            blurRadius: 12,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  size.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint("══════════════════════════════");
                                  debugPrint("🛒 ADDED TO CART");
                                  debugPrint("   Product : ${widget.name}");
                                  debugPrint("   Price   : ${widget.price}");
                                  debugPrint("   Size    : $_selectedSize");
                                  debugPrint("   Color   : $_selectedColor");
                                  debugPrint("══════════════════════════════");

                                  CartScreen.cartItems.add({
                                    "image": widget.image,
                                    "name": widget.name,
                                    "price": widget.price,
                                    "color": _selectedColor,
                                    "size": _selectedSize,
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen()));
                                },
                                child: Container(
                                  height: 54,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF4CAF50),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.shopping_cart_outlined,
                                          color: Color(0xFF2E7D32), size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          color: Color(0xFF2E7D32),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint("══════════════════════════════");
                                  debugPrint("⚡ BUY NOW TAPPED");
                                  debugPrint("   Product : ${widget.name}");
                                  debugPrint("   Price   : ${widget.price}");
                                  debugPrint("   Size    : $_selectedSize");
                                  debugPrint("   Color   : $_selectedColor");
                                  debugPrint("══════════════════════════════");

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Order Placed Successfully"),
                                    backgroundColor: Color(0xFF4CAF50),
                                  ));
                                },
                                child: Container(
                                  height: 54,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF00897B)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4CAF50)
                                            .withOpacity(0.4),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.flash_on_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        "Buy Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Image.asset(widget.image, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: Color(0xFF2E7D32)),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() => _isFavorite = !_isFavorite);
                debugPrint(
                    "❤️  Favorite: $_isFavorite  |  Product: ${widget.name}");
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _isFavorite ? const Color(0xFFFFEBEE) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: _isFavorite ? Colors.redAccent : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}

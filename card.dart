import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpf/orderconformation.dart/checkout.dart';

class CartScreen extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    debugPrint("══════════════════════════════");
    debugPrint("🛍️  CART SCREEN OPENED");
    debugPrint("   Total Items : ${CartScreen.cartItems.length}");
    for (int i = 0; i < CartScreen.cartItems.length; i++) {
      final item = CartScreen.cartItems[i];
      debugPrint(
          "   [$i] ${item["name"]} | ${item["price"]} | Size: ${item["size"]} | Color: ${item["color"]}");
    }
    debugPrint("══════════════════════════════");

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double total = 0;
    for (var item in CartScreen.cartItems) {
      total +=
          double.tryParse(item["price"].toString().replaceAll("\$", "")) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
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
                _buildAppBar(context),
                Expanded(
                  child: CartScreen.cartItems.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartList(),
                ),
                if (CartScreen.cartItems.isNotEmpty)
                  _buildCheckoutPanel(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF2E7D32), size: 18),
            ),
          ),
          const Spacer(),
          const Text(
            "My Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${CartScreen.cartItems.length}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: const Color(0xFF4CAF50).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Cart is Empty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add some shoes to get started!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      itemCount: CartScreen.cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = CartScreen.cartItems[index];
        return _buildCartCard(item, index);
      },
    );
  }

  Widget _buildCartCard(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: Key("$index-${item["name"]}"),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        debugPrint("🗑️  ITEM REMOVED FROM CART: ${item["name"]}");
        setState(() => CartScreen.cartItems.removeAt(index));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 28),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 86,
                height: 86,
                color: const Color(0xFFF5F9F6),
                padding: const EdgeInsets.all(8),
                child: Image.asset(item["image"], fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _tag("Color: ${item["color"]}"),
                      const SizedBox(width: 6),
                      _tag("Size: ${item["size"]}"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["price"],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("🗑️  ITEM REMOVED FROM CART: ${item["name"]}");
                setState(() => CartScreen.cartItems.removeAt(index));
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCheckoutPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${CartScreen.cartItems.length} item(s)",
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              Text(
                "\$${_totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery",
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              const Text("\$10.00",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Divider(color: Colors.grey[100], height: 20, thickness: 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E)),
              ),
              Text(
                "\$${(_totalPrice + 10).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: () {
                debugPrint("══════════════════════════════");
                debugPrint("💳 PROCEEDING TO CHECKOUT");
                debugPrint("   Items    : ${CartScreen.cartItems.length}");
                debugPrint("   Subtotal : \$${_totalPrice.toStringAsFixed(2)}");
                debugPrint(
                    "   Total    : \$${(_totalPrice + 10).toStringAsFixed(2)}");
                debugPrint("══════════════════════════════");

                final item = CartScreen.cartItems[0];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                              image: item["image"],
                              name: item["name"],
                              price: item["price"],
                            )));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

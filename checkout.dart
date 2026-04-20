import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpf/orderconformation.dart/continuescreen.dart';

class CheckoutScreen extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  const CheckoutScreen({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int quantity = 1;
  double taxPercent = 0.10;
  double deliveryCharges = 10;
  int _selectedPayment = 0;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    debugPrint("══════════════════════════════");
    debugPrint("💳 CHECKOUT SCREEN OPENED");
    debugPrint("   Product : ${widget.name}");
    debugPrint("   Price   : ${widget.price}");
    debugPrint("══════════════════════════════");

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  double get basePrice =>
      double.tryParse(widget.price.replaceAll("\$", "")) ?? 0;
  double get subtotal => basePrice * quantity;
  double get tax => subtotal * taxPercent;
  double get total => subtotal + tax + deliveryCharges;

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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProductCard(),
                          const SizedBox(height: 16),
                          _buildQuantityCard(),
                          const SizedBox(height: 16),
                          _sectionTitle("Delivery Information"),
                          const SizedBox(height: 12),
                          _buildTextField(firstNameController, "First Name",
                              Icons.person_outline_rounded),
                          _buildTextField(lastNameController, "Last Name",
                              Icons.person_outline_rounded),
                          _buildEmailField(),
                          _buildTextField(phoneController, "Mobile Number",
                              Icons.phone_outlined),
                          _buildTextField(addressController, "Delivery Address",
                              Icons.location_on_outlined),
                          const SizedBox(height: 8),
                          _sectionTitle("Payment Method"),
                          const SizedBox(height: 12),
                          _buildPaymentOptions(),
                          const SizedBox(height: 16),
                          _sectionTitle("Order Summary"),
                          const SizedBox(height: 12),
                          _buildBillSummary(),
                          const SizedBox(height: 24),
                          _buildPlaceOrderButton(context),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
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
            "Checkout",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E)),
          ),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
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
              width: 90,
              height: 90,
              color: const Color(0xFFE8F5E9),
              padding: const EdgeInsets.all(8),
              child: Image.asset(widget.image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            "Quantity",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E)),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (quantity > 1) {
                setState(() => quantity--);
                debugPrint(
                    "➖ Quantity decreased: $quantity  |  Product: ${widget.name}");
              }
            },
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.remove_rounded,
                  color: Color(0xFF2E7D32), size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => quantity++);
              debugPrint(
                  "➕ Quantity increased: $quantity  |  Product: ${widget.name}");
            },
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF00897B)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    final options = [
      {"icon": Icons.credit_card_rounded, "label": "Credit Card"},
      {"icon": Icons.money_rounded, "label": "Cash on Delivery"},
      {"icon": Icons.account_balance_wallet_rounded, "label": "EasyPaisa"},
    ];

    return Row(
      children: List.generate(options.length, (i) {
        final selected = _selectedPayment == i;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedPayment = i);
              debugPrint("💰 Payment method selected: ${options[i]["label"]}");
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF00897B)])
                    : null,
                color: selected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? Colors.transparent : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    options[i]["icon"] as IconData,
                    color: selected ? Colors.white : Colors.grey[500],
                    size: 22,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    options[i]["label"] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 10),
          _priceRow("Tax (10%)", "\$${tax.toStringAsFixed(2)}"),
          const SizedBox(height: 10),
          _priceRow("Delivery", "\$${deliveryCharges.toStringAsFixed(2)}"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey[100], thickness: 1.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400)),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            const payments = ["Credit Card", "Cash on Delivery", "EasyPaisa"];

            debugPrint("══════════════════════════════");
            debugPrint("✅ ORDER PLACED SUCCESSFULLY");
            debugPrint("── Product ─────────────────");
            debugPrint("   Name      : ${widget.name}");
            debugPrint("   Price     : ${widget.price}");
            debugPrint("   Qty       : $quantity");
            debugPrint("── Bill ─────────────────────");
            debugPrint("   Subtotal  : \$${subtotal.toStringAsFixed(2)}");
            debugPrint("   Tax (10%) : \$${tax.toStringAsFixed(2)}");
            debugPrint(
                "   Delivery  : \$${deliveryCharges.toStringAsFixed(2)}");
            debugPrint("   TOTAL     : \$${total.toStringAsFixed(2)}");
            debugPrint("── Delivery Info ────────────");
            debugPrint(
                "   Name      : ${firstNameController.text} ${lastNameController.text}");
            debugPrint("   Email     : ${emailController.text}");
            debugPrint("   Phone     : ${phoneController.text}");
            debugPrint("   Address   : ${addressController.text}");
            debugPrint("── Payment ──────────────────");
            debugPrint("   Method    : ${payments[_selectedPayment]}");
            debugPrint("══════════════════════════════");

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContinueScreen()));
          }
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
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (v) => (v == null || v.isEmpty) ? "$hint is required" : null,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v == null || v.isEmpty) return "Email is required";
          if (!v.contains("@")) return "Enter valid email";
          return null;
        },
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: "Email Address",
          hintStyle:
              TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.email_outlined,
              color: Color(0xFF4CAF50), size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    if (cart.items.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Ask user to pick a payment method first
      final selected = await Navigator.pushNamed(context, AppRoutes.paymentMethod) as int?;
      const _methods = ['Credit / Debit Card', 'PayPal', 'Apple Pay', 'Cash on Delivery'];
      final paymentMethod = (selected != null && selected >= 0 && selected < _methods.length) ? _methods[selected] : 'Unknown';
      await OrderService.placeOrder(
        items: cart.items.values.toList(),
        total: cart.totalAmount,
        address: 'Max Tiger, 00000, Al Garhoud, Dubai, UAE',
        notes: _notesCtrl.text,
        paymentMethod: paymentMethod,
      );
      
      cart.clear();
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.paymentSuccess);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                _stepDot('Cart', isDone: true),
                Expanded(child: Container(height: 2, color: const Color(0xFFFF9800))),
                _stepDot('Checkout', isDone: true, isActive: true),
                Expanded(child: Container(height: 2, color: const Color(0xFFEAECF0))),
                _stepDot('Payment', isDone: false),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.shippingAddress),
                      child: const Text('Edit', style: TextStyle(color: Color(0xFF2F80ED), fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEAECF0))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_on_outlined, color: Color(0xFF475467), size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Home', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                            SizedBox(height: 4),
                            Text('Max Tiger ( +100 123 1245 3534)', style: TextStyle(fontSize: 12, color: Color(0xFF475467))),
                            SizedBox(height: 2),
                            Text('00000, Al Garhoud, Dubai, United Arab Emirates', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Summary ( ${cart.itemCount} )', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))),
                const SizedBox(height: 8),
                ...cart.items.values.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEAECF0))),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item.image, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: const Color(0xFFF2F4F7))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                              const SizedBox(height: 4),
                              Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 13)),
                            ],
                          ),
                        ),
                        Text('Qty : ${item.quantity}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                      ],
                    ),
                  ),
                )).toList(),
                const SizedBox(height: 20),
                const Text('Notes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter additional notes here...',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEAECF0))),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Sub total', style: TextStyle(color: Color(0xFF667085), fontSize: 13)), Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF101828), fontSize: 13, fontWeight: FontWeight.w600))]),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Coupon Discount', style: TextStyle(color: Color(0xFF667085), fontSize: 13)), Text('-\$0.00', style: TextStyle(color: Color(0xFF667085), fontSize: 13, fontWeight: FontWeight.w600))]),
                      const Divider(height: 20, color: Color(0xFFEAECF0)),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))), Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kOrange))]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(backgroundColor: kNavy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepDot(String label, {required bool isDone, bool isActive = false}) {
    return Column(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: isDone ? const Color(0xFFFF9800) : const Color(0xFFEAECF0), shape: BoxShape.circle)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF101828) : const Color(0xFF98A2B3), fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';

class CancelRequestScreen extends StatefulWidget {
  const CancelRequestScreen({super.key});

  @override
  State<CancelRequestScreen> createState() => _CancelRequestScreenState();
}

class _CancelRequestScreenState extends State<CancelRequestScreen> {
  String _reason = 'Found a better price elsewhere';
  final _commentCtrl = TextEditingController();

  static const _reasons = [
    'Ordered by mistake',
    'Changed my mind',
    'Want to change size or color',
    'Found a better price elsewhere',
    'Placed duplicate order',
    'Payment issue / failed transaction',
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _showCancelConfirmationModal() {
    const kNavy = Color(0xFF1D2939);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: const Color(0xFFD0D5DD), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Text('Cancel Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to cancel this order?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Once cancelled, this order cannot be restored. You can always reorder later from your order history.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF667085), height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF98A2B3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('No, Don\'t cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showCancelledSuccessModal();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Yes, Cancel it', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showCancelledSuccessModal() {
    const kNavy = Color(0xFF1D2939);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70, height: 70,
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Order Canceled', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
              const SizedBox(height: 8),
              const Text(
                'Your order has been successfully cancelled. We\'ve processed your request and sent you a confirmation email with all the details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF667085), height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Back to home', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order Return',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Product Details Card
                const Text('Product Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(AppAssets.productFashion, width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: const Color(0xFFF2F4F7))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Order ID: #1234124', style: TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                            SizedBox(height: 2),
                            Text('Leather bag for men for casual looks and day',
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                            SizedBox(height: 4),
                            Text('\$9.00', style: TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.w800, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Reason for cancellation section matching 40_cancel_request.png
                const Text('Reason for cancelation', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))),
                const SizedBox(height: 4),
                const Text('Please select a reason for canceling your order. This helps us improve your shopping experience.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF667085), height: 1.4)),
                const SizedBox(height: 12),

                ..._reasons.map((r) {
                  final isSel = _reason == r;
                  return GestureDetector(
                    onTap: () => setState(() => _reason = r),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            isSel ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                            size: 20,
                            color: isSel ? const Color(0xFFFF9800) : const Color(0xFFD0D5DD),
                          ),
                          const SizedBox(width: 10),
                          Text(r, style: TextStyle(fontSize: 13, color: isSel ? const Color(0xFF101828) : const Color(0xFF344054), fontWeight: isSel ? FontWeight.w600 : FontWeight.w400)),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),

                // Comment box
                const Text('Comment', style: TextStyle(fontSize: 11, color: Color(0xFF667085))),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _commentCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter comment...',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
                  ),
                ),
              ],
            ),
          ),

          // Continue Button (Dark Navy)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _showCancelConfirmationModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

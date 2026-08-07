import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _rating = 4;
  final _commentCtrl = TextEditingController(text: 'The bag was very nice, i loved the color and material of the bag.');

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
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
        title: const Text('Leave a Review',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Product Summary Card matching 46_review.png
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(AppAssets.productFashion, width: 64, height: 64, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: const Color(0xFFF2F4F7))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Leather bag for men for casual looks and day',
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                            SizedBox(height: 3),
                            Text('+2 other products', style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
                            SizedBox(height: 4),
                            Text('Total shipping', style: TextStyle(fontSize: 10, color: Color(0xFF667085))),
                            Text('\$145.00', style: TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.w800, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // How is your order? Star Rating Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Column(
                    children: [
                      const Text('How is your order?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final val = index + 1;
                          return IconButton(
                            iconSize: 32,
                            icon: Icon(
                              val <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: const Color(0xFFFFC107),
                            ),
                            onPressed: () => setState(() => _rating = val),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Leave a Review Text Box & Photo Upload
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Leave a Review', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _commentCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your review here...',
                          hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Thumbnails + Camera circle button
                      Row(
                        children: [
                          _thumbPhoto(AppAssets.productFashion),
                          const SizedBox(width: 8),
                          _thumbPhoto(AppAssets.productShoe),
                          const SizedBox(width: 8),
                          _thumbPhoto(AppAssets.productHeadphone),
                          const SizedBox(width: 8),
                          _thumbPhoto(AppAssets.productSwitchConsole1),
                          const SizedBox(width: 8),
                          Container(
                            width: 44, height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFCCBC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFFF5722), size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Buttons: Maybe later & Submit review
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD0D5DD)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Maybe later', style: TextStyle(color: Color(0xFF344054), fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you! Your review has been submitted.')),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Submit review', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbPhoto(String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(img, width: 44, height: 44, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: const Color(0xFFEAECF0))),
    );
  }
}

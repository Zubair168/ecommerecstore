import 'package:flutter/material.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  int _selectedVoucher = 0;
  final _codeCtrl = TextEditingController();

  static const _vouchers = [
    {
      'title': 'Free Shipping on Orders Above \$30',
      'code': 'SHIPFREE',
      'sub': '',
    },
    {
      'title': '20% OFF on All Fashion Items',
      'code': 'FASHION20',
      'sub': 'Valid till Nov 30, 2025',
    },
    {
      'title': 'Buy 2 Get 1 Free on Women\'s Wear',
      'code': 'B2GTWOMEN',
      'sub': '',
    },
    {
      'title': 'Flat \$10 OFF your first order',
      'code': 'WELCOME10',
      'sub': 'For new users only',
    },
    {
      'title': 'Combo Offer- 40% OFF on Bag + Shoes',
      'code': 'COMBO40',
      'sub': 'Limited time only',
    },
  ];

  @override
  void dispose() {
    _codeCtrl.dispose();
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
        title: const Text('My Voucher',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF344054), size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header promo input container matching 48_voucher.png
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEAECF0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Have a promo code?',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFD0D5DD)),
                              ),
                              child: TextField(
                                controller: _codeCtrl,
                                decoration: const InputDecoration(
                                  hintText: 'Enter code here',
                                  hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_codeCtrl.text.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Voucher redeemed successfully!')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kNavy,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                elevation: 0,
                              ),
                              child: const Text('Redeem', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Voucher List Cards matching 48_voucher.png
                ...List.generate(_vouchers.length, (i) {
                  final v = _vouchers[i];
                  final isSelected = _selectedVoucher == i;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedVoucher = i),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF101828) : const Color(0xFFEAECF0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFECB3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.percent_rounded, size: 18, color: Color(0xFFFF9800)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v['title']!,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828)),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text('Use Code: ${v['code']!}',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
                                    if (v['sub']!.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Text(v['sub']!,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_rounded, color: Color(0xFF101828), size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Action Button (Dark Navy) matching 48_voucher.png
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voucher applied to your order!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Use Voucher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

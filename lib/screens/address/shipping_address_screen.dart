import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _addresses = [
    {
      'title': 'Home',
      'name': 'Max Tiger ( +100 123 1245 3534)',
      'address': '00000, Al Garhoud, Dubai, United Arab Emirates',
      'isDefault': true,
    },
    {
      'title': 'Office',
      'name': 'John Terry ( +100 123 1245 3534)',
      'address': '420 Market Street, Suite 201',
      'isDefault': false,
    },
    {
      'title': 'Grandmother\'s home',
      'name': 'Michael Owen ( +100 123 435 6475)',
      'address': '89 Lakewood Blvd, Miami, FL 33126',
      'isDefault': false,
    },
    {
      'title': 'Apartments building',
      'name': 'Nicolas Andre ( +100 312 465 1235)',
      'address': '225 North Michigan Avenue, Suite 800',
      'isDefault': false,
    },
    {
      'title': 'Suburban home',
      'name': 'Wayne ( +100 324 456 6798)',
      'address': '92 Elm Street, Seattle, WA 98109',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Shipping address',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, i) {
                final item = _addresses[i];
                final isSelected = _selectedIndex == i;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF475467)),
                                const SizedBox(width: 8),
                                Text(
                                  item['title'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.check_rounded, size: 16, color: Color(0xFF344054)),
                                const SizedBox(width: 4),
                                Text('Default', style: TextStyle(fontSize: 12, fontWeight: item['isDefault'] as bool ? FontWeight.w700 : FontWeight.w400, color: const Color(0xFF344054))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item['name'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF475467))),
                        const SizedBox(height: 2),
                        Text(item['address'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 20, height: 20,
                              child: Checkbox(
                                value: isSelected,
                                activeColor: const Color(0xFFFF9800),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => setState(() => _selectedIndex = i),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Use this as the shipping address',
                                style: TextStyle(fontSize: 12, color: Color(0xFF475467))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Add New Address Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.addAddress),
                icon: const Icon(Icons.add, size: 20, color: Color(0xFF101828)),
                label: const Text('Add new Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD0D5DD)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  int _categoryIndex = 0; // 0: Home, 1: Office
  bool _isDefault = true;

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
        title: const Text('Add new address',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _categoryIndex = 0),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: _categoryIndex == 0 ? const Color(0xFFF2F4F7) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.home_outlined, size: 18, color: Color(0xFF344054)),
                          SizedBox(width: 8),
                          Text('Home', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF344054))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _categoryIndex = 1),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: _categoryIndex == 1 ? const Color(0xFFF2F4F7) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD0D5DD)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.business_outlined, size: 18, color: Color(0xFF344054)),
                          SizedBox(width: 8),
                          Text('Office', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF344054))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildField('First name', 'Please enter your first name'),
            _buildField('Last name', 'Please enter your last name'),
            _buildField('Email address', 'Please enter your email address'),
            _buildField('Phone', 'Please input phone number'),
            _buildField('Company name', 'Please enter your company name'),
            _buildField('State', 'Please enter state'),
            _buildField('City', 'City'),
            _buildField('Street address', 'House number and street name'),
            _buildField(null, 'Apartment, suite, unit, etc'),
            _buildField('Postcode/ZIP', 'Please input Postcode'),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SET AS DEFAULT', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                Switch(
                  value: _isDefault,
                  activeThumbColor: kNavy,
                  activeTrackColor: kNavy.withValues(alpha: 0.5),
                  onChanged: (val) => setState(() => _isDefault = val),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New address saved successfully.')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String? label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF344054))),
            const SizedBox(height: 6),
          ],
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEAECF0))),
            ),
          ),
        ],
      ),
    );
  }
}

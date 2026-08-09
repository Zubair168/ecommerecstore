import 'package:flutter/material.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(20, 500);
  int _selectedCategory = 0;
  int _selectedSort = 0;
  double _minRating = 4.0;
  final Set<String> _selectedBrands = {'Nike', 'Sony'};

  // Dark navy used as primary selection color throughout (consistent with rest of app)
  static const _kNavy = Color(0xFF1D2939);
  static const _kNavySoft = Color(0xFFEEF1F5);

  static const _categories = ['All', 'Electronics', 'Fashion', 'Beauty', 'Sports', 'Furniture'];
  static const _sortOptions = ['Popularity', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Customer Rating'];
  static const _brands = ['Nike', 'Sony', 'Nintendo', 'Adidas', 'Apple', "Levi's", 'JBL', 'Samsung'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF344054), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter & Sort',
          style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _priceRange = const RangeValues(0, 1000);
              _selectedCategory = 0;
              _selectedSort = 0;
              _minRating = 0;
              _selectedBrands.clear();
            }),
            child: const Text('Reset',
                style: TextStyle(color: _kNavy, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEAECF0)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [

          // ── Category ──────────────────────────────────────────────────
          _SectionTitle(title: 'Category'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_categories.length, (i) {
              final isSelected = _selectedCategory == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? _kNavy : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected ? _kNavy : const Color(0xFFD0D5DD),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _kNavy.withValues(alpha: 0.14), blurRadius: 8, offset: const Offset(0, 3))]
                        : [],
                  ),
                  child: Text(
                    _categories[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF667085),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEAECF0)),
          const SizedBox(height: 16),

          // ── Sort By ───────────────────────────────────────────────────
          _SectionTitle(title: 'Sort By'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_sortOptions.length, (i) {
              final isSelected = _selectedSort == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedSort = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? _kNavy : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected ? _kNavy : const Color(0xFFD0D5DD),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _kNavy.withValues(alpha: 0.14), blurRadius: 8, offset: const Offset(0, 3))]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        _sortOptions[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEAECF0)),
          const SizedBox(height: 16),

          // ── Price Range ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(title: 'Price Range'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kNavySoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '\$${_priceRange.start.round()} – \$${_priceRange.end.round()}',
                  style: const TextStyle(
                      color: _kNavy, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _kNavy,
              inactiveTrackColor: const Color(0xFFD0D5DD),
              thumbColor: _kNavy,
              overlayColor: _kNavy.withValues(alpha: 0.12),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            ),
            child: RangeSlider(
              values: _priceRange,
              min: 0,
              max: 1000,
              divisions: 100,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFEAECF0)),
          const SizedBox(height: 16),

          // ── Minimum Rating ────────────────────────────────────────────
          _SectionTitle(title: 'Minimum Rating'),
          const SizedBox(height: 12),
          Row(
            children: [4.5, 4.0, 3.5, 3.0].map((r) {
              final isSelected = _minRating == r;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _minRating = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _kNavy : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: isSelected ? _kNavy : const Color(0xFFD0D5DD),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: _kNavy.withValues(alpha: 0.14), blurRadius: 8, offset: const Offset(0, 3))]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 14,
                            color: isSelected ? const Color(0xFFFDB022) : const Color(0xFFFDB022)),
                        const SizedBox(width: 4),
                        Text('$r+',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF667085),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEAECF0)),
          const SizedBox(height: 16),

          // ── Brand ─────────────────────────────────────────────────────
          _SectionTitle(title: 'Brand'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _brands.map((b) {
              final isSelected = _selectedBrands.contains(b);
              return GestureDetector(
                onTap: () => setState(() =>
                    isSelected ? _selectedBrands.remove(b) : _selectedBrands.add(b)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _kNavy : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected ? _kNavy : const Color(0xFFD0D5DD),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _kNavy.withValues(alpha: 0.14), blurRadius: 8, offset: const Offset(0, 3))]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                      ],
                      Text(b,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF667085),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
        ],
      ),

      // ── Apply Filter Button ───────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEAECF0))),
        ),
        child: Row(
          children: [
            // Quick Reset
            GestureDetector(
              onTap: () => setState(() {
                _priceRange = const RangeValues(0, 1000);
                _selectedCategory = 0;
                _selectedSort = 0;
                _minRating = 0;
                _selectedBrands.clear();
              }),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _kNavySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD0D5DD)),
                ),
                child: const Icon(Icons.tune_rounded, color: _kNavy, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            // Apply button
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: _kNavy,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: _kNavy.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828)));
  }
}

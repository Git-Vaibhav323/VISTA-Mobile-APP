import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 0,
      (_filters['maxPrice'] as double?) ?? 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Products',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _priceRange = const RangeValues(0, 1000);
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  _buildSectionTitle('Category'),
                  SizedBox(height: 2.h),
                  _buildCategoryFilter(),

                  SizedBox(height: 3.h),

                  // Price Range Filter
                  _buildSectionTitle('Price Range'),
                  SizedBox(height: 2.h),
                  _buildPriceRangeFilter(),

                  SizedBox(height: 3.h),

                  // Stock Status Filter
                  _buildSectionTitle('Stock Status'),
                  SizedBox(height: 2.h),
                  _buildStockStatusFilter(),

                  SizedBox(height: 3.h),

                  // Popularity Filter
                  _buildSectionTitle('Sort by Popularity'),
                  SizedBox(height: 2.h),
                  _buildPopularityFilter(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _filters['minPrice'] = _priceRange.start;
                  _filters['maxPrice'] = _priceRange.end;
                  widget.onApplyFilters(_filters);
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      'All',
      'Vegetables',
      'Spices',
      'Grains',
      'Dairy',
      'Fruits',
      'Oils'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: categories.map((category) {
        final isSelected = _filters['category'] == category;
        return GestureDetector(
          onTap: () {
            setState(() {
              _filters['category'] = category == 'All' ? null : category;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryLight : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? AppTheme.primaryLight : AppTheme.borderLight,
              ),
            ),
            child: Text(
              category,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.surfaceLight
                    : AppTheme.textPrimaryLight,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '₹${_priceRange.start.round()}',
            '₹${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              '₹${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockStatusFilter() {
    final stockOptions = [
      {'key': 'all', 'label': 'All Products'},
      {'key': 'in_stock', 'label': 'In Stock'},
      {'key': 'low_stock', 'label': 'Low Stock'},
      {'key': 'out_of_stock', 'label': 'Out of Stock'},
    ];

    return Column(
      children: stockOptions.map((option) {
        final isSelected = _filters['stockStatus'] == option['key'];
        return RadioListTile<String>(
          title: Text(
            option['label'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: option['key'] as String,
          groupValue: _filters['stockStatus'] as String? ?? 'all',
          onChanged: (value) {
            setState(() {
              _filters['stockStatus'] = value == 'all' ? null : value;
            });
          },
          activeColor: AppTheme.primaryLight,
        );
      }).toList(),
    );
  }

  Widget _buildPopularityFilter() {
    final sortOptions = [
      {'key': 'none', 'label': 'Default'},
      {'key': 'popular', 'label': 'Most Popular'},
      {'key': 'recent', 'label': 'Recently Added'},
      {'key': 'price_low', 'label': 'Price: Low to High'},
      {'key': 'price_high', 'label': 'Price: High to Low'},
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected = _filters['sortBy'] == option['key'];
        return RadioListTile<String>(
          title: Text(
            option['label'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: option['key'] as String,
          groupValue: _filters['sortBy'] as String? ?? 'none',
          onChanged: (value) {
            setState(() {
              _filters['sortBy'] = value == 'none' ? null : value;
            });
          },
          activeColor: AppTheme.primaryLight,
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/app_export.dart';
import './widgets/add_product_bottom_sheet_widget.dart';
import './widgets/bulk_operations_widget.dart';
import './widgets/category_tab_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_card_widget.dart';

class ProductCatalogManagement extends StatefulWidget {
  const ProductCatalogManagement({Key? key}) : super(key: key);

  @override
  State<ProductCatalogManagement> createState() =>
      _ProductCatalogManagementState();
}

class _ProductCatalogManagementState extends State<ProductCatalogManagement>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  Set<int> _selectedProducts = {};
  String _selectedCategory = 'All';
  Map<String, dynamic> _currentFilters = {};
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  bool _isListening = false;
  bool _speechEnabled = false;

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Spices',
    'Grains',
    'Dairy',
    'Fruits',
    'Oils',
    'Pulses'
  ];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _initSpeech();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _allProducts = [
      {
        'id': 1,
        'name': 'Fresh Tomatoes',
        'category': 'Vegetables',
        'price': 45.0,
        'stockLevel': 150,
        'description': 'Fresh red tomatoes from local farms',
        'imageUrl':
            'https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'id': 2,
        'name': 'Basmati Rice',
        'category': 'Grains',
        'price': 120.0,
        'stockLevel': 8,
        'description': 'Premium quality basmati rice',
        'imageUrl':
            'https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': 3,
        'name': 'Turmeric Powder',
        'category': 'Spices',
        'price': 85.0,
        'stockLevel': 0,
        'description': 'Pure turmeric powder for cooking',
        'imageUrl':
            'https://images.pexels.com/photos/4198015/pexels-photo-4198015.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(hours: 12)),
      },
      {
        'id': 4,
        'name': 'Fresh Milk',
        'category': 'Dairy',
        'price': 55.0,
        'stockLevel': 25,
        'description': 'Fresh cow milk from local dairy',
        'imageUrl':
            'https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(hours: 6)),
      },
      {
        'id': 5,
        'name': 'Green Chilies',
        'category': 'Vegetables',
        'price': 35.0,
        'stockLevel': 75,
        'description': 'Fresh green chilies for spicy dishes',
        'imageUrl':
            'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        'id': 6,
        'name': 'Coconut Oil',
        'category': 'Oils',
        'price': 180.0,
        'stockLevel': 12,
        'description': 'Pure coconut oil for cooking',
        'imageUrl':
            'https://images.pexels.com/photos/4022090/pexels-photo-4022090.jpeg',
        'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];
    _applyFilters();
  }

  void _initSpeech() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        _speechEnabled = await _speechToText.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      _speechEnabled = false;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more products (pagination simulation)
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    // Simulate loading more products
    if (!_isLoading && _filteredProducts.length < 50) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
              (product) => (product['category'] as String) == _selectedCategory)
          .toList();
    }

    // Search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((product) =>
              (product['name'] as String).toLowerCase().contains(searchTerm) ||
              (product['category'] as String)
                  .toLowerCase()
                  .contains(searchTerm))
          .toList();
    }

    // Additional filters
    if (_currentFilters.isNotEmpty) {
      // Price range filter
      if (_currentFilters['minPrice'] != null &&
          _currentFilters['maxPrice'] != null) {
        final minPrice = _currentFilters['minPrice'] as double;
        final maxPrice = _currentFilters['maxPrice'] as double;
        filtered = filtered.where((product) {
          final price = product['price'] as double;
          return price >= minPrice && price <= maxPrice;
        }).toList();
      }

      // Stock status filter
      if (_currentFilters['stockStatus'] != null) {
        final stockStatus = _currentFilters['stockStatus'] as String;
        filtered = filtered.where((product) {
          final stockLevel = product['stockLevel'] as int;
          switch (stockStatus) {
            case 'in_stock':
              return stockLevel > 10;
            case 'low_stock':
              return stockLevel > 0 && stockLevel <= 10;
            case 'out_of_stock':
              return stockLevel == 0;
            default:
              return true;
          }
        }).toList();
      }

      // Sort filter
      if (_currentFilters['sortBy'] != null) {
        final sortBy = _currentFilters['sortBy'] as String;
        switch (sortBy) {
          case 'popular':
            // Sort by stock level (higher stock = more popular)
            filtered.sort((a, b) =>
                (b['stockLevel'] as int).compareTo(a['stockLevel'] as int));
            break;
          case 'recent':
            filtered.sort((a, b) => (b['createdAt'] as DateTime)
                .compareTo(a['createdAt'] as DateTime));
            break;
          case 'price_low':
            filtered.sort((a, b) =>
                (a['price'] as double).compareTo(b['price'] as double));
            break;
          case 'price_high':
            filtered.sort((a, b) =>
                (b['price'] as double).compareTo(a['price'] as double));
            break;
        }
      }
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _startListening() async {
    if (_speechEnabled && !_isListening) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
          });
          _applyFilters();
        },
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_IN',
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _toggleProductSelection(int productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }

      if (_selectedProducts.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _enterMultiSelectMode(int productId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedProducts.add(productId);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'edit', color: AppTheme.primaryLight, size: 24),
              title: Text('Edit Product'),
              onTap: () {
                Navigator.pop(context);
                _editProduct(product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.secondaryLight,
                  size: 24),
              title: Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                _duplicateProduct(product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'inventory',
                  color: AppTheme.warningLight,
                  size: 24),
              title: Text('Update Stock'),
              onTap: () {
                Navigator.pop(context);
                _updateStock(product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'delete', color: AppTheme.errorLight, size: 24),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteProduct(product['id'] as int);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    // Show edit product dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: Text(
            'Edit functionality for ${product['name']} would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _duplicateProduct(Map<String, dynamic> product) {
    final duplicatedProduct = Map<String, dynamic>.from(product);
    duplicatedProduct['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedProduct['name'] = '${product['name']} (Copy)';
    duplicatedProduct['createdAt'] = DateTime.now();

    setState(() {
      _allProducts.insert(0, duplicatedProduct);
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product duplicated successfully')),
    );
  }

  void _updateStock(Map<String, dynamic> product) {
    final TextEditingController stockController = TextEditingController(
      text: product['stockLevel'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current stock: ${product['stockLevel']}'),
            SizedBox(height: 2.h),
            TextField(
              controller: stockController,
              decoration: InputDecoration(
                labelText: 'New Stock Level',
                hintText: 'Enter new stock quantity',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? 0;
              setState(() {
                product['stockLevel'] = newStock;
              });
              _applyFilters();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stock updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text(
            'Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allProducts
                    .removeWhere((product) => product['id'] == productId);
              });
              _applyFilters();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addProduct(Map<String, dynamic> productData) {
    setState(() {
      _allProducts.insert(0, productData);
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added successfully')),
    );
  }

  void _showAddProductSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductBottomSheetWidget(
        onAddProduct: _addProduct,
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _bulkUpdatePrices() {
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Update Prices'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Update prices for ${_selectedProducts.length} selected products'),
            SizedBox(height: 2.h),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'New Price (₹)',
                hintText: 'Enter new price',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text) ?? 0.0;
              if (newPrice > 0) {
                setState(() {
                  for (final product in _allProducts) {
                    if (_selectedProducts.contains(product['id'])) {
                      product['price'] = newPrice;
                    }
                  }
                });
                _applyFilters();
                _clearSelection();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Prices updated successfully')),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _bulkUpdateStock() {
    final TextEditingController stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Update Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Update stock for ${_selectedProducts.length} selected products'),
            SizedBox(height: 2.h),
            TextField(
              controller: stockController,
              decoration: InputDecoration(
                labelText: 'New Stock Level',
                hintText: 'Enter new stock quantity',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? 0;
              setState(() {
                for (final product in _allProducts) {
                  if (_selectedProducts.contains(product['id'])) {
                    product['stockLevel'] = newStock;
                  }
                }
              });
              _applyFilters();
              _clearSelection();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stock levels updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _bulkUpdateCategories() {
    String selectedCategory = 'Vegetables';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Bulk Update Categories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Update category for ${_selectedProducts.length} selected products'),
              SizedBox(height: 2.h),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'New Category',
                ),
                items: _categories.where((cat) => cat != 'All').map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  for (final product in _allProducts) {
                    if (_selectedProducts.contains(product['id'])) {
                      product['category'] = selectedCategory;
                    }
                  }
                });
                _applyFilters();
                _clearSelection();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Categories updated successfully')),
                );
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _bulkDeleteProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Products'),
        content: Text(
            'Are you sure you want to delete ${_selectedProducts.length} selected products? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allProducts.removeWhere(
                    (product) => _selectedProducts.contains(product['id']));
              });
              _applyFilters();
              _clearSelection();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Products deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Product Catalog'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to settings or more options
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          _applyFilters();
        },
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.surfaceLight,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.textSecondaryLight,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _applyFilters();
                                },
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme.textSecondaryLight,
                                  size: 20,
                                ),
                              )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                      ),
                      onChanged: (value) => _applyFilters(),
                    ),
                  ),
                  if (_speechEnabled) ...[
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: _isListening ? _stopListening : _startListening,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? AppTheme.primaryLight
                              : AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: CustomIconWidget(
                          iconName: _isListening ? 'mic' : 'mic_none',
                          color: _isListening
                              ? AppTheme.surfaceLight
                              : AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Category Tabs
            Container(
              height: 8.h,
              color: AppTheme.surfaceLight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryTabWidget(
                    category: category,
                    isSelected: _selectedCategory == category,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _applyFilters();
                    },
                  );
                },
              ),
            ),

            // Products Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? EmptyStateWidget(onAddProduct: _showAddProductSheet)
                  : GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(2.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                      ),
                      itemCount:
                          _filteredProducts.length + (_isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredProducts.length) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          );
                        }

                        final product = _filteredProducts[index];
                        final productId = product['id'] as int;
                        final isSelected =
                            _selectedProducts.contains(productId);

                        return ProductCardWidget(
                          product: product,
                          isSelected: isSelected,
                          onTap: _isMultiSelectMode
                              ? () => _toggleProductSelection(productId)
                              : null,
                          onLongPress: () => _isMultiSelectMode
                              ? null
                              : _enterMultiSelectMode(productId),
                          onEdit: () => _editProduct(product),
                          onDuplicate: () => _duplicateProduct(product),
                          onDelete: () => _deleteProduct(productId),
                          onUpdateStock: () => _updateStock(product),
                          onPriceUpdate: () {
                            // Quick price update
                            final TextEditingController priceController =
                                TextEditingController(
                              text: product['price'].toString(),
                            );
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Update Price'),
                                content: TextField(
                                  controller: priceController,
                                  decoration: InputDecoration(
                                    labelText: 'New Price (₹)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final newPrice = double.tryParse(
                                              priceController.text) ??
                                          0.0;
                                      if (newPrice > 0) {
                                        setState(() {
                                          product['price'] = newPrice;
                                        });
                                        _applyFilters();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onStockAlert: () {
                            // Set stock alert
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Stock alert set for ${product['name']}')),
                            );
                          },
                          onPromote: () {
                            // Promote product
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${product['name']} promoted successfully')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddProductSheet,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.surfaceLight,
                size: 24,
              ),
            ),
      bottomSheet: _isMultiSelectMode
          ? BulkOperationsWidget(
              selectedCount: _selectedProducts.length,
              onUpdatePrices: _bulkUpdatePrices,
              onUpdateStock: _bulkUpdateStock,
              onUpdateCategories: _bulkUpdateCategories,
              onDeleteSelected: _bulkDeleteProducts,
              onClearSelection: _clearSelection,
            )
          : null,
    );
  }
}

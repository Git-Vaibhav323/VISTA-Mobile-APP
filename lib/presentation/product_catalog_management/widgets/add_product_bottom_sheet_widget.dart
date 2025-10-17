import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddProductBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProduct;

  const AddProductBottomSheetWidget({
    Key? key,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  State<AddProductBottomSheetWidget> createState() =>
      _AddProductBottomSheetWidgetState();
}

class _AddProductBottomSheetWidgetState
    extends State<AddProductBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Vegetables';
  XFile? _selectedImage;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  bool _showScanner = false;
  MobileScannerController? _scannerController;

  final List<String> _categories = [
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
    _initializeCamera();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _cameraController?.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb && await Permission.camera.request().isGranted) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          final camera = _cameras!.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras!.first,
          );

          _cameraController = CameraController(
            camera,
            kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
          );

          await _cameraController!.initialize();

          if (!kIsWeb) {
            try {
              await _cameraController!.setFocusMode(FocusMode.auto);
              await _cameraController!.setFlashMode(FlashMode.auto);
            } catch (e) {
              // Ignore unsupported features
            }
          }

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Handle camera initialization error silently
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _selectedImage = photo;
          _showCamera = false;
        });
      } catch (e) {
        // Handle capture error
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      // Handle gallery error
    }
  }

  void _startBarcodeScanning() {
    setState(() {
      _showScanner = true;
      _scannerController = MobileScannerController();
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        // Simulate product lookup by barcode
        _fillProductFromBarcode(code);
        setState(() {
          _showScanner = false;
        });
        _scannerController?.dispose();
        _scannerController = null;
      }
    }
  }

  void _fillProductFromBarcode(String barcode) {
    // Mock product data based on barcode
    final mockProducts = {
      '1234567890': {
        'name': 'Organic Tomatoes',
        'category': 'Vegetables',
        'price': '45.00',
        'description': 'Fresh organic tomatoes from local farms',
      },
      '0987654321': {
        'name': 'Basmati Rice',
        'category': 'Grains',
        'price': '120.00',
        'description': 'Premium quality basmati rice',
      },
    };

    final productData = mockProducts[barcode];
    if (productData != null) {
      setState(() {
        _nameController.text = productData['name'] as String;
        _selectedCategory = productData['category'] as String;
        _priceController.text = productData['price'] as String;
        _descriptionController.text = productData['description'] as String;
      });
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'category': _selectedCategory,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'stockLevel': int.tryParse(_stockController.text) ?? 0,
        'description': _descriptionController.text,
        'imageUrl': _selectedImage?.path ??
            'https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg',
        'createdAt': DateTime.now(),
      };

      widget.onAddProduct(productData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera) {
      return _buildCameraView();
    }

    if (_showScanner) {
      return _buildScannerView();
    }

    return Container(
      height: 85.h,
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
                  'Add New Product',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _startBarcodeScanning,
                      icon: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: AppTheme.primaryLight,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textSecondaryLight,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Selection
                    _buildImageSection(),
                    SizedBox(height: 3.h),

                    // Product Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),

                    // Price and Stock Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price (₹)',
                              hintText: '0.00',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter price';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(
                              labelText: 'Stock Quantity',
                              hintText: '0',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter stock';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter product description',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Add Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitProduct,
                child: Text('Add Product'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),

        if (_selectedImage != null)
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: kIsWeb
                  ? Image.network(
                      _selectedImage!.path,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.borderLight,
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'image',
                              color: AppTheme.textSecondaryLight,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    )
                  : CustomImageWidget(
                      imageUrl: _selectedImage!.path,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.borderLight, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add_photo_alternate',
                  color: AppTheme.textSecondaryLight,
                  size: 48,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add Product Photo',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 2.h),

        // Image Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showCamera = true;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
                label: Text('Camera'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
                label: Text('Gallery'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraView() {
    return Container(
      height: 100.h,
      color: Colors.black,
      child: Stack(
        children: [
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryLight,
              ),
            ),

          // Camera Controls
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCamera = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Capture Button
                GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Gallery Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCamera = false;
                    });
                    _pickImageFromGallery();
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'photo_library',
                      color: Colors.white,
                      size: 24,
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

  Widget _buildScannerView() {
    return Container(
      height: 100.h,
      color: Colors.black,
      child: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onBarcodeDetected,
          ),

          // Scanner Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryLight, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Instructions
          Positioned(
            top: 15.h,
            left: 0,
            right: 0,
            child: Text(
              'Point camera at barcode',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 8.h,
            right: 4.w,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showScanner = false;
                });
                _scannerController?.dispose();
                _scannerController = null;
              },
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

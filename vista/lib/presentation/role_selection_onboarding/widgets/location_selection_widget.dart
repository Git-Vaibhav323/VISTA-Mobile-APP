import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSelectionWidget extends StatefulWidget {
  final Function(Map<String, String>) onLocationChanged;

  const LocationSelectionWidget({
    Key? key,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  String? selectedCity;
  String? selectedArea;
  final _areaController = TextEditingController();
  bool _isUsingGPS = false;

  final List<Map<String, dynamic>> cities = [
    {
      "name": "Mumbai",
      "hindi": "मुंबई",
      "areas": [
        "Andheri",
        "Bandra",
        "Colaba",
        "Dadar",
        "Goregaon",
        "Juhu",
        "Malad",
        "Powai",
        "Thane",
        "Vile Parle"
      ]
    },
    {
      "name": "Delhi",
      "hindi": "दिल्ली",
      "areas": [
        "Connaught Place",
        "Karol Bagh",
        "Lajpat Nagar",
        "Nehru Place",
        "Rajouri Garden",
        "Saket",
        "Chandni Chowk",
        "Dwarka",
        "Gurgaon",
        "Noida"
      ]
    },
    {
      "name": "Bangalore",
      "hindi": "बैंगलोर",
      "areas": [
        "Koramangala",
        "Indiranagar",
        "Whitefield",
        "Electronic City",
        "Marathahalli",
        "BTM Layout",
        "Jayanagar",
        "Rajajinagar",
        "HSR Layout",
        "Yelahanka"
      ]
    },
    {
      "name": "Chennai",
      "hindi": "चेन्नई",
      "areas": [
        "T. Nagar",
        "Anna Nagar",
        "Adyar",
        "Velachery",
        "Tambaram",
        "Porur",
        "OMR",
        "Mylapore",
        "Nungambakkam",
        "Guindy"
      ]
    },
    {
      "name": "Kolkata",
      "hindi": "कोलकाता",
      "areas": [
        "Park Street",
        "Salt Lake",
        "Howrah",
        "Ballygunge",
        "Alipore",
        "Gariahat",
        "Esplanade",
        "Shyambazar",
        "Tollygunge",
        "New Town"
      ]
    },
    {
      "name": "Pune",
      "hindi": "पुणे",
      "areas": [
        "Koregaon Park",
        "Baner",
        "Hinjewadi",
        "Kothrud",
        "Viman Nagar",
        "Aundh",
        "Wakad",
        "Hadapsar",
        "Magarpatta",
        "Pimpri"
      ]
    },
    {
      "name": "Hyderabad",
      "hindi": "हैदराबाद",
      "areas": [
        "Banjara Hills",
        "Jubilee Hills",
        "Gachibowli",
        "Hitech City",
        "Kondapur",
        "Madhapur",
        "Secunderabad",
        "Begumpet",
        "Kukatpally",
        "Miyapur"
      ]
    },
    {
      "name": "Ahmedabad",
      "hindi": "अहमदाबाद",
      "areas": [
        "Satellite",
        "Vastrapur",
        "Navrangpura",
        "Maninagar",
        "Bopal",
        "Prahlad Nagar",
        "SG Highway",
        "Chandkheda",
        "Ghatlodia",
        "Thaltej"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _areaController.addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    widget.onLocationChanged({
      'city': selectedCity ?? '',
      'area': selectedArea ?? _areaController.text,
      'isUsingGPS': _isUsingGPS.toString(),
    });
  }

  void _detectLocation() async {
    setState(() {
      _isUsingGPS = true;
    });

    HapticFeedback.lightImpact();

    // Simulate GPS detection
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      selectedCity = "Mumbai";
      selectedArea = "Andheri";
      _areaController.text = "Andheri West, Near Metro Station";
      _isUsingGPS = false;
    });

    _onLocationChanged();
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Quick Location Detection',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Let us detect your location automatically',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: ElevatedButton.icon(
                    onPressed: _isUsingGPS ? null : _detectLocation,
                    icon: _isUsingGPS
                        ? SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'my_location',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 4.w,
                          ),
                    label: Text(
                      _isUsingGPS ? 'Detecting...' : 'Use Current Location',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                  child:
                      Divider(color: AppTheme.lightTheme.colorScheme.outline)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                  child:
                      Divider(color: AppTheme.lightTheme.colorScheme.outline)),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Select City / शहर चुनें',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCity,
                hint: Text(
                  'Choose your city',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                isExpanded: true,
                items: cities
                    .map((city) => DropdownMenuItem<String>(
                          value: city["name"],
                          child: Text(
                            '${city["name"]} / ${city["hindi"]}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    selectedArea = null;
                    _areaController.clear();
                  });
                  _onLocationChanged();
                },
              ),
            ),
          ),
          if (selectedCity != null) ...[
            SizedBox(height: 2.h),
            Text(
              'Select Area / क्षेत्र चुनें',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedArea,
                  hint: Text(
                    'Choose your area',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  isExpanded: true,
                  items: (cities.firstWhere(
                              (city) => city["name"] == selectedCity)["areas"]
                          as List<String>)
                      .map((area) => DropdownMenuItem<String>(
                            value: area,
                            child: Text(
                              area,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedArea = value;
                    });
                    _onLocationChanged();
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Specific Address / विशिष्ट पता (Optional)',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _areaController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., Near Metro Station, Shop No. 15, Main Road',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

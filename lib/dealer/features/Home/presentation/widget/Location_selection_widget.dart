import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../page/google_map.dart';

class locationSelectWidget extends StatefulWidget {
  const locationSelectWidget({
    super.key,
    required this.location,
    required this.linkGoogle,
    required this.lat,
    required this.lon,
  });

  final TextEditingController location;
  final TextEditingController linkGoogle;
  final Function(String value) lat;
  final Function(String value) lon;
  
  @override
  State<locationSelectWidget> createState() => _locationSelectWidgetState();
}

class _locationSelectWidgetState extends State<locationSelectWidget> {
  @override
  void initState() {
    super.initState();
    // Listen to controller changes to update UI
    widget.location.addListener(_onLocationChanged);
  }

  @override
  void dispose() {
    widget.location.removeListener(_onLocationChanged);
    super.dispose();
  }

  void _onLocationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    // Debug: Print current location text
    print('📍 Location widget build: Current text = "${widget.location.text}"');
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use responsive width - full width minus padding, max 600px
        final containerWidth = constraints.maxWidth > 0 
            ? constraints.maxWidth 
            : (isSmallScreen ? screenWidth - 32.w : 358.w);
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          width: containerWidth,
          constraints: BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // SvgPicture.asset('assets/icons/svg.svg'),
              Icon(Icons.location_pin, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text('Location', style: AppTextStyle.poppins514),
              Text('*', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          SizedBox(height: 17.h),

          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    lat: (value) {
                      widget.lat(value);
                    },
                    lon: (value) {
                      widget.lon(value);
                    },
                  ),
                ),
              );
              
              // Update location field if address was returned
              if (result != null && result is String && result.isNotEmpty) {
                print('📍 Location widget: Received address: $result');
                widget.location.text = result;
                print('📍 Location widget: Controller text set to: ${widget.location.text}');
                // Force rebuild to update UI
                if (mounted) {
                  setState(() {
                    print('📍 Location widget: setState called, text is: ${widget.location.text}');
                  });
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.location.text.isEmpty
                          ? '📍 Select location on map'
                          : (widget.location.text.length > 40
                              ? '${widget.location.text.substring(0, 40)}...'
                              : widget.location.text),
                      style: AppTextStyle.poppins514.copyWith(
                        color: widget.location.text.isEmpty
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Icon(Icons.location_pin, color: AppColors.primary),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: TextFormField(
              controller: widget.location,
              decoration: InputDecoration(
                hintText: '123 Main Street, Cairo, Egypt',
              ),
            ),
          ),

          SizedBox(height: 12.h),
          // SizedBox(
          //   width: 324.w,
          //   height: 50.h,
          //   child: TextFormField(
          //     controller: linkGoogle,
          //     decoration: InputDecoration(
          //       hintText: 'Google Maps link (optional)',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
      },
    );
  }
}

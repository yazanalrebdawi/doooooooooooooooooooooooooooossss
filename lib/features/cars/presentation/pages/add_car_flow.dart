import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import 'add_car_step1.dart';
import 'add_car_step2.dart';
import 'add_car_step3.dart';
import 'add_car_step4.dart';

class AddCarFlow extends StatefulWidget {
  const AddCarFlow({super.key});

  @override
  State<AddCarFlow> createState() => _AddCarFlowState();
}

class _AddCarFlowState extends State<AddCarFlow> {
  final PageController _pageController = PageController();
  int currentPage = 1;
  final int totalPages = 4;
  bool isLast = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < totalPages) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 750),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      // Submit the car data
      _submitCar();
    }
  }

  void _submitCar() {
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)?.translate('success') ?? 'Success')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index + 1;
                  isLast = currentPage == totalPages;
                });
              },
              children: [
                AddCarStep1(onNext: _nextPage),
                AddCarStep2(onNext: _nextPage),
                AddCarStep3(onNext: _nextPage),
                AddCarStep4(onSubmit: _submitCar),
              ],
            ),
          ),
          _AddCarBottomSection(
            currentPage: currentPage,
            totalPages: totalPages,
            onNext: _nextPage,
            isLast: isLast,
          ),
        ],
      ),
    );
  }
}

class _AddCarBottomSection extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final bool isLast;

  const _AddCarBottomSection({
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Text(
            '$currentPage/$totalPages',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isLast ? Colors.green : const Color(0xFF7B4B2A),
                shape: BoxShape.circle,
              ),
              child: Icon(isLast ? Icons.check : Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 
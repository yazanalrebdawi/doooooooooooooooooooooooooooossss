// import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: const HomeScreen(),
// //     );
// //   }
// // }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;

//   final List<Widget> _pages = const [
//     Center(child: Text('📄 Page 1', style: TextStyle(fontSize: 28))),
//     Center(child: Text('📄 Page 2', style: TextStyle(fontSize: 28))),
//     Center(child: Text('📄 Page 3', style: TextStyle(fontSize: 28))),
//   ];

//   @override
//   void dispose() {
//     // هنا ما نستخدم context في dispose حتى نتجنب الخطأ
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onItemTapped(int index) {
//     setState(() => _currentIndex = index);
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: _pages,
//         onPageChanged: (index) {
//           setState(() => _currentIndex = index);
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// class TwoScreensPageView extends StatefulWidget {
//   const TwoScreensPageView({super.key});

//   @override
//   State<TwoScreensPageView> createState() => _TwoScreensPageViewState();
// }

// class _TwoScreensPageViewState extends State<TwoScreensPageView> {
//   final PageController _controller = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _controller,
//         children: [
//           // الشاشة الأولى
//           Container(
//             color: Colors.blue,
//             child: Center(
//               child: Text(
//                 "Screen 1",
//                 style: TextStyle(fontSize: 28, color: Colors.white),
//               ),
//             ),
//           ),

//           // الشاشة الثانية
//           Container(
//             color: Colors.green,
//             child: Center(
//               child: Text(
//                 "Screen 2",
//                 style: TextStyle(fontSize: 28, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:dooss_business_app/user/features/chat/presentation/manager/chat_cubit.dart';
import 'package:dooss_business_app/user/features/chat/presentation/pages/chats_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
// import '../../data/data_source/chat_remote_data_source.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/page/my_reels_page.dart';
import '../../../reels/presentation/widget/Custom_app_bar.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../widget/Category_Section_widget.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/priceAndQuantityWidget.dart';
import 'edit_Prodect_page.dart';

import 'package:flutter_svg/svg.dart';

import 'home_Page1.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        children: [
                   MyReelsPage(),
          HomePage1(),
       BlocProvider(create: (context) => ChatCubit(appLocator<ChatRemoteDataSource>()),
        child: ChatsListScreen())

 

          // Container(
          //   color: Colors.blue,
          //   child: const Center(
          //     child: Text(
          //       "Screen 1",
          //       style: TextStyle(fontSize: 28, color: Colors.white),
          //     ),
          //   ),
          // ),
          // Container(
          //   color: Colors.green,
          //   child: const Center(
          //     child: Text(
          //       "Screen 2",
          //       style: TextStyle(fontSize: 28, color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xffffffff),
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
          showSelectedLabels: false,   // إخفاء النص عند الاختيار
  showUnselectedLabels: false,
          selectedItemColor: AppColors.primary, // اللون عند الضغط أو الاختيار
  unselectedItemColor: Colors.grey, 
        items: [
          BottomNavigationBarItem(backgroundColor: AppColors.primary,
            icon: SvgPicture.asset('assets/icons/reels.svg',   color: _currentIndex == 0 ? AppColors.primary : Colors.grey,
             ),
            label: "",
            
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Screen 2",
          ),
           const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Screen 2",
          ),
        ],
      ),
    );
  }
}

// COMMENTED OUT - Notification Service
// import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_Cubit_dealers.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_state_dealers.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/features/auth/presentation/widgets/terms_and_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/style/app_text_style.dart';

import 'navigotorPage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 151.h, 20.w, 101.h),
          child: BlocListener<AuthCubitDealers, AuthStateDealers>(
            listener: (context, state) {
              if (state.dataUser != null) {
                // COMMENTED OUT - Notification Service
                // // Show foreground notification with translations
                // LocalNotificationService.instance.showNotification(
                //   id: 7,
                //   title: AppLocalizations.of(context)
                //           ?.translate('notificationDealerLoginSuccessTitle') ??
                //       'Dealer Login Successful',
                //   body: AppLocalizations.of(context)
                //           ?.translate('notificationDealerLoginSuccessBody') ??
                //       'Welcome back! You have successfully logged in.',
                // );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavigatorPage()),
                );
                BlocProvider.of<AppManagerCubit>(
                  context,
                );
                // .savedDataUser(state.dataUser!);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                loginHeader(),
                LoginForm(
                  userName: userName,
                  password: password,
                  termsAccepted: _termsAccepted,
                  onTermsChanged: (value) {
                    setState(() {
                      _termsAccepted = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        //  width: double.infinity,
                        decoration: BoxDecoration(color: Color(0xffD9D9D9)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 28.h,
                      ),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Color(0xff7f7f7f)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        //  width: double.infinity,
                        decoration: BoxDecoration(color: Color(0xffD9D9D9)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // BlocProvider.of<AuthCubitDealers>(context).SignIn();
                      },
                      child: customButtonPayWidget(
                        typePay: 'Apple Pay ',
                        icon: Icon(Icons.apple_sharp),
                      ),
                    ),
                    customButtonPayWidget(
                      typePay: 'Goolge Pay',
                      icon: Icon(Icons.apple_sharp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.userName,
    required this.password,
    required this.termsAccepted,
    required this.onTermsChanged,
  });

  final TextEditingController userName;
  final TextEditingController password;
  final bool termsAccepted;
  final ValueChanged<bool> onTermsChanged;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextFormField(
            controller: widget.userName,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              hintText: 'User Name',
            ),
          ),
          SizedBox(height: 18.h),
          TextFormField(
            controller: widget.password,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              hintText: 'Password',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Checkbox(
                        value: true,
                        // splashRadius: 0,
                        activeColor: Color(0xff349A51),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Color(0xff7f7f7f),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Color(0xff454545),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          TermsAndConditionsCheckbox(
            initialValue: widget.termsAccepted,
            onChanged: widget.onTermsChanged,
          ),
          SizedBox(height: 18.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  if (!widget.termsAccepted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                                  ?.translate('pleaseAcceptTermsAndConditions') ??
                              'Please accept the terms and conditions to continue',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  if (widget.userName.text.isEmpty || widget.password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter username and password'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  context.read<AuthCubitDealers>().signIn(
                        name: widget.userName.text,
                        password: widget.password.text,
                        code: '',
                      );
                },
                child: Container(
                width: double.infinity,
                height: 62.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff349A51),
                  borderRadius: BorderRadius.circular(62),
                ),
                  child: BlocBuilder<AuthCubitDealers, AuthStateDealers>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      return Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                height: 62.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffEDEDED),
                  borderRadius: BorderRadius.circular(62),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: Color(0xff349A51),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class loginHeader extends StatelessWidget {
  const loginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome Back\nReady to hit the road.',
      style: AppTextStyle.RobotoBlack630,
    );
  }
}

class customButtonPayWidget extends StatelessWidget {
  const customButtonPayWidget({
    super.key,
    required this.typePay,
    required this.icon,
  });
  final String typePay;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      width: double.infinity,
      height: 49.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xffEDEDED),
        borderRadius: BorderRadius.circular(62),
        border: Border.all(width: 1, color: Color(0xffD7D7D7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple_sharp, color: Color(0xff349A51)),
          SizedBox(width: 10.w),
          Text(
            typePay,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class CustomAppBarProfileWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;

  const CustomAppBarProfileWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.black54,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.3),
      leading: showBack
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black12),
            )
          : null,
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

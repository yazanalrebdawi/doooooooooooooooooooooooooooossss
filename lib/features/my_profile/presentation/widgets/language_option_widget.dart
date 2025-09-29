import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/core/models/language_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageOptionWidget extends StatefulWidget {
  final AppLanguageEnum selectedLanguage;
  final ValueChanged<AppLanguageEnum> onChanged;

  const LanguageOptionWidget({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  State<LanguageOptionWidget> createState() => _LanguageOptionWidgetState();
}

class _LanguageOptionWidgetState extends State<LanguageOptionWidget> {
  late AppLanguageEnum _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedLanguage;
  }

  void _onSelect(AppLanguageEnum language) {
    setState(() {
      _selected = language;
    });
    widget.onChanged(language);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          AppLanguageEnum.values.map((lang) {
            final info = languageMap[lang]!;
            final isSelected = _selected == lang;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onSelect(lang),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: info.colors,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    info.code,
                                    style: AppTextStyles.s14w600.copyWith(
                                      color: AppColors.buttonText,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    info.native,
                                    style: AppTextStyles.s16w500.copyWith(
                                      color: Color(0xff111827),
                                    ),
                                  ),
                                  Text(
                                    info.english,
                                    style: AppTextStyles.s14w400.copyWith(
                                      color: AppColors.rating,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey,
                                width: 2.w,
                              ),
                              color: Colors.transparent,
                            ),
                            child:
                                isSelected
                                    ? Center(
                                      child: Container(
                                        width: 12.w,
                                        height: 12.h,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: AppColors.field, thickness: 1.h, height: 8.h),
              ],
            );
          }).toList(),
    );
  }
}

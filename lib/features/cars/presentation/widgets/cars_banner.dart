import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';

class CarsBanner extends StatelessWidget {
  const CarsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Text(
              AppLocalizations.of(context)?.translate('getBestValue') ?? 'Get the best value for your car',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ).withThemeColor(context),
            ),
          ),
        ],
      ),
    );
  }
} 
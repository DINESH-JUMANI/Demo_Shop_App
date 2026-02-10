// Home Navigation Screen with Bottom Nav Bar

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_strings.dart';
import 'package:demo_shop_app/features/products/screens/product_screen.dart';
import 'package:demo_shop_app/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const ProductScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home_outlined),
            title: AppStrings.home,
            activeForegroundColor: AppColors.primaryLight,
            inactiveForegroundColor: AppColors.textSecondaryLight,
          ),
        ),
        PersistentTabConfig(
          screen: const SettingsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings_outlined),
            title: AppStrings.settings,
            activeForegroundColor: AppColors.primaryLight,
            inactiveForegroundColor: AppColors.textSecondaryLight,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.surfaceLight
              : AppColors.surfaceDark,
        ),
      ),
    );
  }
}

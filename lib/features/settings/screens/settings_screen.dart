// Settings Screen

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:demo_shop_app/core/constants/app_strings.dart';
import 'package:demo_shop_app/core/providers/providers.dart';
import 'package:demo_shop_app/core/services/local_storage_service.dart';
import 'package:demo_shop_app/core/services/theme_service.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:demo_shop_app/core/utils/app_snackbar.dart';
import 'package:demo_shop_app/core/widgets/app_bar_widget.dart';
import 'package:demo_shop_app/features/settings/widgets/section_title_widget.dart';
import 'package:demo_shop_app/features/settings/widgets/settings_card_widget.dart';
import 'package:demo_shop_app/features/settings/widgets/settings_tile_widget.dart';
import 'package:demo_shop_app/features/settings/widgets/theme_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const CustomAppBar(title: AppStrings.settingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            const SectionTitle(title: AppStrings.appearanceSection),
            const SizedBox(height: AppSizes.paddingMd),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.brightness_6_outlined,
                  iconColor: AppColors.primaryLight,
                  title: AppStrings.themeTitle,
                  subtitle: ThemeService.getThemeName(themeMode),
                  onTap: () => _showThemeDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXl),

            // About Section
            const SectionTitle(title: AppStrings.aboutSection),
            const SizedBox(height: AppSizes.paddingMd),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  iconColor: Colors.blue,
                  title: AppStrings.appVersionTitle,
                  subtitle: AppStrings.appVersion,
                  onTap: () {},
                  showTrailing: false,
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.code,
                  iconColor: Colors.green,
                  title: AppStrings.developerTitle,
                  subtitle: AppStrings.appDeveloper,
                  onTap: () {},
                  showTrailing: false,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXl),

            // Data Section
            const SectionTitle(title: AppStrings.dataSection),
            const SizedBox(height: AppSizes.paddingMd),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.delete_outline,
                  iconColor: AppColors.error,
                  title: AppStrings.clearCacheTitle,
                  subtitle: AppStrings.clearCacheSubtitle,
                  onTap: () => _showClearCacheDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.chooseTheme),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeOption(
              title: AppStrings.themeLight,
              icon: Icons.light_mode,
              value: ThemeMode.light,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            ThemeOption(
              title: AppStrings.themeDark,
              icon: Icons.dark_mode,
              value: ThemeMode.dark,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            ThemeOption(
              title: AppStrings.themeSystem,
              icon: Icons.settings_suggest,
              value: ThemeMode.system,
              groupValue: ref.read(themeModeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.clearCacheDialogTitle),
        content: const Text(AppStrings.clearCacheDialogMessage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              AppLogger.warning('Clearing cache');
              await LocalStorageService.remove(
                LocalStorageService.keyCachedProducts,
              );
              if (context.mounted) {
                Navigator.pop(context);
                AppSnackbar.success(context, AppStrings.cacheCleared);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.clear),
          ),
        ],
      ),
    );
  }
}

// Settings Tile Widget

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showTrailing = true,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.paddingXs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: iconColor.withAlpha(26),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Icon(icon, color: iconColor, size: AppSizes.iconMd),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryLight),
      ),
      trailing: showTrailing
          ? const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight)
          : null,
      onTap: onTap,
    );
  }
}

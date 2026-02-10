// Theme Option Widget

import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ThemeOption extends StatelessWidget {
  const ThemeOption({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  final String title;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primaryLight : null,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryLight,
                size: AppSizes.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

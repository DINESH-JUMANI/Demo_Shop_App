import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.bottom,
    this.elevation,
  });
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      bottom: bottom,
      elevation: elevation ?? AppSizes.appBarElevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    AppSizes.appBarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

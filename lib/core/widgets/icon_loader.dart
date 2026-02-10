import 'dart:math' as math;
import 'package:demo_shop_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class IconLoader extends StatefulWidget {
  const IconLoader({super.key});

  @override
  State<IconLoader> createState() => _IconLoaderState();
}

class _IconLoaderState extends State<IconLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: child,
            );
          },
          child: Image.asset(AppAssets.appIcon, width: 60, height: 60),
        ),
      ),
    );
  }
}

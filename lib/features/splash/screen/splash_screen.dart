// Splash Screen

import 'package:demo_shop_app/core/constants/app_assets.dart';
import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/routes/app_routes.dart';
import 'package:demo_shop_app/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    AppLogger.info('Splash screen initialized', 'SplashScreen');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Slide from top animation
    _slideAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Wobble animation (rotation)
    _rotationAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 0.1),
            weight: 20.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.1, end: -0.1),
            weight: 40.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: -0.1, end: 0.05),
            weight: 30.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.05, end: 0.0),
            weight: 10.0,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();

    // Navigate to home after 5 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        AppLogger.info('Navigating to home screen', 'SplashScreen');
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryLight,
              AppColors.primaryLight.withAlpha(204),
              AppColors.primaryLight.withAlpha(153),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Image.asset(
              AppAssets.appIcon,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

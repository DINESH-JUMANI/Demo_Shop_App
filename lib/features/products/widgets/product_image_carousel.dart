// Product Image Carousel Widget

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_shop_app/core/constants/app_colors.dart';
import 'package:demo_shop_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({super.key, required this.images});
  final List<String> images;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: AppSizes.carouselHeight,
            viewportFraction: 1.0,
            enableInfiniteScroll: widget.images.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: widget.images.map((imageUrl) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: AppColors.borderLight),
              errorWidget: (context, url, error) => Container(
                color: AppColors.borderLight,
                child: const Icon(
                  Icons.broken_image,
                  size: AppSizes.iconXxl,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            );
          }).toList(),
        ),

        // Image indicator
        if (widget.images.length > 1)
          Positioned(
            bottom: AppSizes.padding,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return Container(
                  width: AppSizes.spaceMd,
                  height: AppSizes.spaceMd,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == entry.key
                        ? Colors.white
                        : Colors.white.withAlpha(102),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

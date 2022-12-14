import 'package:flutter/material.dart';
import 'package:nopsuite_carousel_slider/effects/indicator_effect.dart';
import 'package:nopsuite_carousel_slider/pointer/indicator_painter.dart';
import 'package:nopsuite_carousel_slider/pointer/worm_painter.dart';

class WormEffect extends BasicIndicatorEffect {
  final WormType type;
  const WormEffect({
    double offset = 16.0,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = Colors.grey,
    Color activeDotColor = Colors.indigo,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
    this.type = WormType.normal,
  }) : super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
        );

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return WormPainter(count: count, offset: offset, effect: this);
  }
}

enum WormType { normal, thin }

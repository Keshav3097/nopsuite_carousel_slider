library nopsuite_carousel_slider;
import 'package:flutter/material.dart';
import 'package:nopsuite_carousel_slider/effects/indicator_effect.dart';
import 'package:nopsuite_carousel_slider/effects/worm_effect.dart';
typedef OnDotClicked = void Function(int index);

class NopSuiteCarouselSlider extends StatefulWidget {
  final PageController controller;
  final IndicatorEffect effect;
  final Axis axisDirection;
  final int count;
  final TextDirection? textDirection;
  final OnDotClicked? onDotClicked;
  final List<Widget> itemBuilder;

  NopSuiteCarouselSlider({
    Key? key,
    required this.controller,
    required this.count,
    required this.itemBuilder,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
  });

  @override
  State<NopSuiteCarouselSlider> createState() => _NopSuiteCarouselSliderState();
}

class _NopSuiteCarouselSliderState extends State<NopSuiteCarouselSlider> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        const SizedBox(height: 16),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: PageView.builder(
            controller: widget.controller,
            // itemCount: pages.length,
            itemBuilder: (_, index) {
              return widget.itemBuilder[index % widget.itemBuilder.length];
            },
          ),
        )
        ,

        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'Worm',
            style: TextStyle(color: Colors.black54),
          ),
        ),

        NopSuiteCarouselIndicator(
          controller: widget.controller,
          count: widget.itemBuilder.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 16,
            radius: 4,
            dotColor: Colors.black26,
            activeDotColor: Colors.black,
            type: WormType.normal,
            strokeWidth: 5,
          ),
        ),

        const SizedBox(height: 32.0),
      ],
    );
  }
}


class NopSuiteCarouselIndicator extends AnimatedWidget {
  // Page view controller
  final PageController controller;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  ///
  /// This will only rotate the canvas in which the dots
  /// are drawn,
  /// It will not affect [effect.dotWidth] and [effect.dotHeight]
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// on dot clicked callback
  final OnDotClicked? onDotClicked;

  NopSuiteCarouselIndicator({
    Key? key,
    required this.controller,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return SmoothIndicator(
      offset: _offset,
      count: count,
      effect: effect,
      textDirection: textDirection,
      axisDirection: axisDirection,
      onDotClicked: onDotClicked,
    );
  }

  double get _offset {
    try {
      var offset = controller.page ?? controller.initialPage.toDouble();
      return offset % count;
    } catch (_) {
      return controller.initialPage.toDouble();
    }
  }
}

class SmoothIndicator extends StatelessWidget {
  // to listen for page offset updates
  final double offset;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// on dot clicked callback
  final OnDotClicked? onDotClicked;

  /// canvas size
  final Size _size;

  SmoothIndicator({
    Key? key,
    required this.offset,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.effect = const WormEffect(),
    this.textDirection,
    this.onDotClicked,
  })  :
  // different effects have different sizes
  // so we calculate size based on the provided effect
        _size = effect.calculateSize(count),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // if textDirection is not provided use the nearest directionality up the widgets tree;
    final isRTL =
        (textDirection ?? Directionality.of(context)) == TextDirection.rtl;

    return RotatedBox(
      quarterTurns: axisDirection == Axis.vertical
          ? 1
          : isRTL
          ? 2
          : 0,
      child: GestureDetector(
        onTapUp: _onTap,
        child: CustomPaint(
          size: _size,
          // rebuild the painter with the new offset every time it updates
          painter: effect.buildPainter(count, offset),
        ),
      ),
    );
  }

  void _onTap(details) {
    if (onDotClicked != null) {
      var index = effect.hitTestDots(
        details.localPosition.dx,
        count,
        offset,
      );
      if (index != -1 && index != offset.toInt()) {
        onDotClicked?.call(index);
      }
    }
  }
}

class AnimatedSmoothIndicator extends ImplicitlyAnimatedWidget {
  final int activeIndex;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  final Axis axisDirection;

  /// The number of children in [PageView]
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// On dot clicked callback
  final Function(int index)? onDotClicked;

  AnimatedSmoothIndicator({
    Key? key,
    required this.activeIndex,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
    VoidCallback? onEnd,
  }) : super(
    key: key,
    duration: duration,
    curve: curve,
    onEnd: onEnd,
  );

  @override
  _AnimatedSmoothIndicatorState createState() =>
      _AnimatedSmoothIndicatorState();
}

class _AnimatedSmoothIndicatorState
    extends AnimatedWidgetBaseState<AnimatedSmoothIndicator> {
  Tween<double>? _offset;

  @override
  void forEachTween(visitor) {
    _offset = visitor(
      _offset,
      widget.activeIndex.toDouble(),
          (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final offset = _offset;
    if (offset == null) {
      throw 'Offset has not been initialized';
    }

    return SmoothIndicator(
      offset: offset.evaluate(animation),
      count: widget.count,
      effect: widget.effect,
      textDirection: widget.textDirection,
      axisDirection: widget.axisDirection,
      onDotClicked: widget.onDotClicked,
    );
  }
}

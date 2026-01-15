import 'package:flutter/material.dart';

/// Utility class for common animations
///
/// Provides reusable animation configurations and builders
/// for consistent animations throughout the app.
///
/// Requirements: 1.1, 9.1
class AnimationUtils {
  AnimationUtils._();

  /// Standard duration for page transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  /// Standard duration for widget animations
  static const Duration widgetAnimationDuration = Duration(milliseconds: 400);

  /// Standard curve for animations
  static const Curve standardCurve = Curves.easeOut;

  /// Stagger delay between list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Create a slide-up fade-in animation
  static Widget slideUpFadeIn({
    required Widget child,
    required Animation<double> animation,
    required Duration totalDuration,
    Duration delay = Duration.zero,
  }) {
    final delayedAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          delay.inMilliseconds / totalDuration.inMilliseconds,
          1.0,
          curve: standardCurve,
        ),
      ),
    );

    return FadeTransition(
      opacity: delayedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(delayedAnimation),
        child: child,
      ),
    );
  }

  /// Create a staggered list animation
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    required Animation<double> animation,
    required Duration totalDuration,
  }) {
    final delay = staggerDelay * index;
    return slideUpFadeIn(
      child: child,
      animation: animation,
      totalDuration: totalDuration,
      delay: delay,
    );
  }

  /// Create a scale fade-in animation
  static Widget scaleFadeIn({
    required Widget child,
    required Animation<double> animation,
    required Duration totalDuration,
    Duration delay = Duration.zero,
  }) {
    final delayedAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          delay.inMilliseconds / totalDuration.inMilliseconds,
          1.0,
          curve: standardCurve,
        ),
      ),
    );

    return FadeTransition(
      opacity: delayedAnimation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(delayedAnimation),
        child: child,
      ),
    );
  }
}

/// Widget that animates its child with a slide-up fade-in effect
///
/// Automatically starts the animation when the widget is built.
class AnimatedSlideUpFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedSlideUpFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AnimationUtils.widgetAnimationDuration,
  });

  @override
  State<AnimatedSlideUpFadeIn> createState() => _AnimatedSlideUpFadeInState();
}

class _AnimatedSlideUpFadeInState extends State<AnimatedSlideUpFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: AnimationUtils.standardCurve,
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}

/// Widget that animates a number counting up
///
/// Useful for displaying financial metrics with a smooth count-up effect.
class AnimatedCountUp extends StatefulWidget {
  final double value;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimals;

  const AnimatedCountUp({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1000),
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 2,
  });

  @override
  State<AnimatedCountUp> createState() => _AnimatedCountUpState();
}

class _AnimatedCountUpState extends State<AnimatedCountUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value.toStringAsFixed(widget.decimals)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

/// Page route with custom slide transition
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  SlidePageRoute({
    required this.page,
    this.direction = AxisDirection.left,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AnimationUtils.pageTransitionDuration,
          reverseTransitionDuration: AnimationUtils.pageTransitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case AxisDirection.up:
                begin = const Offset(0, 1);
                break;
              case AxisDirection.down:
                begin = const Offset(0, -1);
                break;
              case AxisDirection.left:
                begin = const Offset(1, 0);
                break;
              case AxisDirection.right:
                begin = const Offset(-1, 0);
                break;
            }

            final tween = Tween(begin: begin, end: Offset.zero);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: AnimationUtils.standardCurve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

/// Fade page route transition
class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AnimationUtils.pageTransitionDuration,
          reverseTransitionDuration: AnimationUtils.pageTransitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

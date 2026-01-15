import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom page transitions for smooth navigation
///
/// Provides fade and slide transitions for better UX
///
/// Requirements: 1.1, 9.1
class PageTransitions {
  /// Fade transition for page navigation
  static Transition get fade => Transition.fadeIn;

  /// Slide transition from right
  static Transition get slideRight => Transition.rightToLeft;

  /// Slide transition from left
  static Transition get slideLeft => Transition.leftToRight;

  /// Zoom transition
  static Transition get zoom => Transition.zoom;

  /// Custom fade and slide transition
  static GetPageRoute customFadeSlide({
    required Widget page,
    required String name,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return GetPageRoute(
      page: () => page,
      routeName: name,
      transition: Transition.fadeIn,
      transitionDuration: duration,
      curve: Curves.easeInOut,
    );
  }

  /// Custom slide up transition (for modals)
  static GetPageRoute slideUp({
    required Widget page,
    required String name,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return GetPageRoute(
      page: () => page,
      routeName: name,
      transition: Transition.downToUp,
      transitionDuration: duration,
      curve: Curves.easeOut,
    );
  }
}

/// Custom route transition builder for more control
class CustomPageTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  CustomPageTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            );

            // Slide transition
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.1, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Hero animation wrapper for smooth transitions between screens
class HeroWrapper extends StatelessWidget {
  final String tag;
  final Widget child;

  const HeroWrapper({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}

/// Animated list item for staggered animations
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Stagger the animation based on index
    Future.delayed(widget.delay * widget.index, () {
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
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

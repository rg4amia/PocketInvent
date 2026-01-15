import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Skeleton loader widget for showing loading placeholders
///
/// Provides a shimmer effect while content is loading to improve
/// perceived performance and user experience.
///
/// Requirements: 1.1, 9.1
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.textSecondary.withValues(alpha: 0.1),
                AppColors.textSecondary.withValues(alpha: 0.2),
                AppColors.textSecondary.withValues(alpha: 0.1),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for card-like content
class SkeletonCard extends StatelessWidget {
  final double? height;

  const SkeletonCard({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            width: 100,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          SkeletonLoader(
            width: double.infinity,
            height: 24,
            borderRadius: BorderRadius.circular(4),
          ),
          const Spacer(),
          SkeletonLoader(
            width: 150,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for list items
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SkeletonLoader(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                SkeletonLoader(
                  width: 200,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SkeletonLoader(
            width: 60,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loader for the dashboard metrics
class SkeletonDashboard extends StatelessWidget {
  const SkeletonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector skeleton
          SkeletonLoader(
            width: double.infinity,
            height: 48,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),

          // Metrics card skeleton
          const SkeletonCard(height: 200),
          const SizedBox(height: 16),

          // Quick stats grid skeleton
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: List.generate(
              4,
              (index) => const SkeletonCard(height: 100),
            ),
          ),
          const SizedBox(height: 16),

          // Charts skeleton
          const SkeletonCard(height: 300),
        ],
      ),
    );
  }
}

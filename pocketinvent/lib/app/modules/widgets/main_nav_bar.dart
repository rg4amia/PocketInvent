import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_pages.dart';

/// Navigation item model
class NavItem {
  final IconData icon;
  final String label;
  final String route;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// Main Navigation Bar Widget
/// Provides bottom navigation with 4 sections: Dashboard, Inventaire, Transactions, Profil
class MainNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int? transactionBadgeCount;

  const MainNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.transactionBadgeCount,
  });

  /// Navigation items configuration
  static const List<NavItem> items = [
    NavItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: Routes.DASHBOARD,
    ),
    NavItem(
      icon: Icons.inventory_2_rounded,
      label: 'Inventaire',
      route: Routes.HOME,
    ),
    NavItem(
      icon: Icons.receipt_long_rounded,
      label: 'Transactions',
      route: Routes.TRANSACTIONS,
    ),
    NavItem(
      icon: Icons.person_rounded,
      label: 'Profil',
      route: Routes.HUB,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _buildNavItem(
              item: items[index],
              index: index,
              isSelected: currentIndex == index,
              showBadge: index == 2 &&
                  transactionBadgeCount != null &&
                  transactionBadgeCount! > 0,
              badgeCount: transactionBadgeCount,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavItem item,
    required int index,
    required bool isSelected,
    bool showBadge = false,
    int? badgeCount,
  }) {
    final color =
        isSelected ? AppColors.primaryBlue : AppColors.textPlaceholder;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    item.icon,
                    color: color,
                    size: 24,
                  ),
                  if (showBadge)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundPrimary,
                            width: 2,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            badgeCount! > 99 ? '99+' : badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: color,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

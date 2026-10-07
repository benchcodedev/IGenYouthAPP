import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CategoryCardItem {
  final String id;
  final String title;
  final int count;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final VoidCallback onTap;

  const CategoryCardItem({
    required this.id,
    required this.title,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.badgeColor = AppColors.yellowHighlight,
    this.badgeTextColor = AppColors.maroonDark,
    required this.onTap,
  });
}

class StackedCategoryCard extends StatefulWidget {
  final CategoryCardItem item;
  final bool isFirst;
  final bool isLast;

  const StackedCategoryCard({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<StackedCategoryCard> createState() => _StackedCategoryCardState();
}

class _StackedCategoryCardState extends State<StackedCategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: item.onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Protruding Top Notched Tab (Signature Faith Notes Feature)
              Center(
                child: Container(
                  width: 72,
                  height: 9,
                  decoration: BoxDecoration(
                    color: item.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
              // Main Card Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: item.backgroundColor.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Title, Badge & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: item.textColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Count Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.badgeColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item.count.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: item.badgeTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.normal,
                              color: item.textColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Right Icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.textColor.withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.textColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

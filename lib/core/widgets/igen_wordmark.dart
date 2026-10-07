import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class IGenWordmark extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showSubtitle;
  final bool isDark;

  const IGenWordmark({
    super.key,
    this.size = 22,
    this.color,
    this.showSubtitle = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? (isDark ? AppColors.darkTextPrimary : AppColors.maroon);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Brand Symbol: Stylized Latin Cross with modern rounded geometry
        Container(
          width: size * 1.1,
          height: size * 1.25,
          margin: const EdgeInsets.only(right: 10),
          child: CustomPaint(
            painter: _IGenCrossPainter(color: effectiveColor),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'IGen Youth',
              style: GoogleFonts.outfit(
                fontSize: size,
                fontWeight: FontWeight.w800,
                color: effectiveColor,
                letterSpacing: -0.5,
              ),
            ),
            if (showSubtitle) ...[
              const SizedBox(height: 1),
              Text(
                '@igen.youthxteens',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w600,
                  color: effectiveColor.withValues(alpha: 0.7),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _IGenCrossPainter extends CustomPainter {
  final Color color;

  _IGenCrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final stemWidth = size.width * 0.32;
    final stemHeight = size.height;
    final crossHeight = size.height * 0.28;
    final crossTop = size.height * 0.26;

    final stemRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.5),
        width: stemWidth,
        height: stemHeight,
      ),
      Radius.circular(stemWidth * 0.35),
    );

    final crossRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, crossTop, size.width, crossHeight),
      Radius.circular(crossHeight * 0.4),
    );

    canvas.drawRRect(stemRRect, paint);
    canvas.drawRRect(crossRRect, paint);
  }

  @override
  bool shouldRepaint(covariant _IGenCrossPainter oldDelegate) =>
      oldDelegate.color != color;
}

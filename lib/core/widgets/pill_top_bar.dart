import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';

/// The signature Maroon Pill Shortcut Bar from the reference design.
class PillShortcutBar extends StatelessWidget {
  final VoidCallback onJadwalTap;
  final VoidCallback onBantuanTap;
  final VoidCallback onPengaturanTap;

  const PillShortcutBar({
    super.key,
    required this.onJadwalTap,
    required this.onBantuanTap,
    required this.onPengaturanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
              icon: LucideIcons.calendarDays,
              label: 'Jadwal',
              onTap: onJadwalTap,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              icon: LucideIcons.helpCircle,
              label: 'Bantuan',
              onTap: onBantuanTap,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              icon: LucideIcons.settings2,
              label: 'Pengaturan',
              onTap: onPengaturanTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.22),
    );
  }
}

/// The signature Maroon Action Bar used on Detail / Editor screens (Screen 3)
class PillDetailActionBar extends StatelessWidget {
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onActionTap;
  final VoidCallback onHelpTap;
  final VoidCallback onShareTap;
  final VoidCallback onCalendarTap;

  const PillDetailActionBar({
    super.key,
    required this.actionLabel,
    this.actionIcon = LucideIcons.ticket,
    required this.onActionTap,
    required this.onHelpTap,
    required this.onShareTap,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Yellow Circle Action Pill (e.g. "Daftar Event")
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.yellowHighlight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(actionIcon, size: 16, color: AppColors.maroonDark),
                  const SizedBox(width: 8),
                  Text(
                    actionLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroonDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // 3 Action Buttons on the right (Help, Share, Calendar)
          _buildCircleIcon(LucideIcons.helpCircle, onHelpTap),
          const SizedBox(width: 4),
          _buildCircleIcon(LucideIcons.share2, onShareTap),
          const SizedBox(width: 4),
          _buildCircleIcon(LucideIcons.calendarPlus, onCalendarTap),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: Colors.white, size: 17),
      ),
    );
  }
}

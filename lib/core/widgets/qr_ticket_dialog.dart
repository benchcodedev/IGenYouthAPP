import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_colors.dart';
import '../../data/models/event_registration_model.dart';
import '../../data/models/event_model.dart';

class QrTicketDialog extends StatelessWidget {
  final EventRegistrationModel registration;
  final EventModel event;
  final VoidCallback? onSimulateCheckIn;

  const QrTicketDialog({
    super.key,
    required this.registration,
    required this.event,
    this.onSimulateCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ticket Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.maroon,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.yellowHighlight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.ticket, size: 20, color: AppColors.maroonDark),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIKET MASUK EVENT',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.yellowHighlight,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          event.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Ticket Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // QR Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight, width: 1.5),
                    ),
                    child: QrImageView(
                      data: registration.qrCode,
                      version: QrVersions.auto,
                      size: 190.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.maroon,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.maroonDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Code label
                  Text(
                    registration.qrCode,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info rows
                  _buildInfoRow('Peserta', registration.userName),
                  const SizedBox(height: 6),
                  _buildInfoRow('WhatsApp', registration.userWa.isEmpty ? '-' : registration.userWa),
                  const SizedBox(height: 6),
                  _buildInfoRow('Lokasi', event.lokasi),
                  const SizedBox(height: 6),
                  _buildInfoRow('Status', registration.status, isStatus: true),
                  const SizedBox(height: 20),
                  // Buttons
                  if (onSimulateCheckIn != null && !registration.isCheckedIn)
                    ElevatedButton.icon(
                      onPressed: onSimulateCheckIn,
                      icon: const Icon(LucideIcons.scanLine, size: 18),
                      label: const Text('Simulasi Scan Check-In (Admin)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: value == 'Checked-In' ? AppColors.success : AppColors.yellowHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: value == 'Checked-In' ? Colors.white : AppColors.maroonDark,
              ),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
      ],
    );
  }
}

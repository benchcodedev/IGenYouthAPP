import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'title': 'Pengingat Youth Night: H-3',
      'body': 'Jangan lupa ibadah akbar Youth Night Radical Grace Jumat ini jam 18:30 WIB di Main Hall!',
      'time': '10 menit lalu',
      'icon': LucideIcons.calendar,
      'isRead': false,
    },
    {
      'id': 'notif_2',
      'title': 'Pengumuman Penting: Early Bird Youth Camp',
      'body': 'Slot kuota early bird tinggal 42 kursi lagi. Segera amankan pendaftaranmu!',
      'time': '2 jam lalu',
      'icon': LucideIcons.bell,
      'isRead': false,
    },
    {
      'id': 'notif_3',
      'title': 'Permintaan Komsel Telah Disetujui!',
      'body': 'Selamat bergabung di Alpha Tribe Barat! Leader Kak Kevin akan segera menghubungimu.',
      'time': '1 hari lalu',
      'icon': LucideIcons.userCheck,
      'isRead': true,
    },
    {
      'id': 'notif_4',
      'title': 'Renungan Hari Ini Telah Terbit',
      'body': '"Jangan Biarkan Siapapun Meremehkan Masa Mudamu" - 1 Timotius 4:12.',
      'time': '2 hari lalu',
      'icon': LucideIcons.bookOpen,
      'isRead': true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const IGenWordmark(size: 20),
                  const Spacer(),
                  TextButton(
                    onPressed: _markAllRead,
                    child: Text(
                      'Tandai Dibaca',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.maroon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  final isRead = notif['isRead'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: !isRead
                            ? AppColors.maroon.withValues(alpha: 0.3)
                            : (isDark ? Colors.white12 : AppColors.borderLight),
                        width: !isRead ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: !isRead ? AppColors.softMint : (isDark ? Colors.white12 : AppColors.softBg),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            notif['icon'] as IconData,
                            size: 18,
                            color: !isRead ? AppColors.maroon : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: !isRead ? FontWeight.w700 : FontWeight.w600,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (!isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif['body'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  height: 1.45,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif['time'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

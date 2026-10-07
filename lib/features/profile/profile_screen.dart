import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/qr_ticket_dialog.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/komsel_repository.dart';
import '../../data/repositories/devotion_repository.dart';
import '../welcome/auth_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider);
    final registrations = ref.watch(registrationsProvider);
    final komselRequests = ref.watch(komselRequestsProvider);
    final events = ref.watch(eventRepositoryProvider);
    final devotions = ref.watch(devotionRepositoryProvider);
    final themeMode = ref.watch(themeModeProvider);

    final isDark = themeMode == ThemeMode.dark;
    final isGuest = user == null || user.isGuest;

    final myRegistrations = user != null
        ? registrations.where((r) => r.userId == user.id).toList()
        : [];
    final myKomselRequests = user != null
        ? komselRequests.where((r) => r.userId == user.id).toList()
        : [];
    final favoriteDevotions = devotions.where((d) => d.isFavorite).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const IGenWordmark(size: 20),
                  Text(
                    'Profil & Akun',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.maroon,
                          backgroundImage: user != null && user.fotoUrl.isNotEmpty
                              ? NetworkImage(user.fotoUrl)
                              : null,
                          child: user == null || user.fotoUrl.isEmpty
                              ? const Icon(LucideIcons.user, size: 40, color: Colors.white)
                              : null,
                        ),
                        if (user != null && user.isAdmin)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.yellowHighlight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.shieldCheck, size: 16, color: AppColors.maroonDark),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.nama ?? 'Tamu IGen',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Masuk untuk mendaftar event & komsel',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.maroon,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Role: ${user?.role.name.toUpperCase() ?? 'GUEST'} • ${user?.kategori.name.toUpperCase() ?? 'YOUTH'}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellowHighlight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isGuest)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const AuthDialog(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowHighlight,
                          foregroundColor: AppColors.maroonDark,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Masuk / Buat Akun'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // DEMO ROLE SWITCHER (For Testing & Verification)
              Text(
                'Ubah Role Akun (Untuk Demo)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    _buildRoleChip(ref, user?.role, UserRole.guest, 'Tamu'),
                    _buildRoleChip(ref, user?.role, UserRole.member, 'Member'),
                    _buildRoleChip(ref, user?.role, UserRole.leader, 'Leader'),
                    _buildRoleChip(ref, user?.role, UserRole.admin, 'Admin'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ADMIN PANEL BUTTON (If role is Admin or Leader)
              if (user != null && user.isLeader) ...[
                InkWell(
                  onTap: () => context.push('/admin'),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.maroon,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.maroon.withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.yellowHighlight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.shieldCheck, size: 20, color: AppColors.maroonDark),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Panel Kontrol Admin & Leader',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Kelola event, komsel, scan QR check-in & broadcast',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevronRight, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Tiket & Event Saya
              Text(
                'Tiket & Event Saya (${myRegistrations.length})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (myRegistrations.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Belum ada tiket event yang terdaftar.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                ...myRegistrations.map((reg) {
                  final ev = events.firstWhere(
                    (e) => e.id == reg.eventId,
                    orElse: () => events.first,
                  );
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.softMint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(LucideIcons.qrCode, color: AppColors.maroon, size: 20),
                      ),
                      title: Text(
                        ev.judul,
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Status: ${reg.status} • Kode: ${reg.qrCode}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => QrTicketDialog(
                              registration: reg,
                              event: ev,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowHighlight,
                          foregroundColor: AppColors.maroonDark,
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Buka QR', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 20),

              // Komsel Saya
              Text(
                'Komsel Saya',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (myKomselRequests.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Kamu belum mengajukan atau bergabung ke komsel.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                ...myKomselRequests.map((km) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.users, color: AppColors.maroon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              km.komselNama,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Status: ${km.status.toUpperCase()}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: km.isApproved ? AppColors.success : AppColors.yellowHighlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          km.isApproved ? 'Aktif' : 'Menunggu',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: km.isApproved ? Colors.white : AppColors.maroonDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              const SizedBox(height: 20),

              // Pengaturan Section
              Text(
                'Pengaturan & Preferensi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Mode Gelap (Dark Mode)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      secondary: const Icon(LucideIcons.moon, size: 20),
                      value: isDark,
                      activeTrackColor: AppColors.yellowHighlight,
                      onChanged: (val) {
                        ref.read(themeModeProvider.notifier).state =
                            val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(LucideIcons.heart, size: 20),
                      title: Text(
                        'Renungan Favorit (${favoriteDevotions.length})',
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, size: 18),
                      onTap: () => context.push('/devotions'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(LucideIcons.bell, size: 20),
                      title: Text(
                        'Pusat Notifikasi',
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, size: 18),
                      onTap: () => context.push('/notifications'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(LucideIcons.logOut, size: 20, color: AppColors.redAccent),
                      title: Text(
                        'Keluar dari Akun',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.redAccent,
                        ),
                      ),
                      onTap: () {
                        ref.read(authRepositoryProvider.notifier).logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Anda telah keluar dari akun.'),
                            backgroundColor: AppColors.maroon,
                          ),
                        );
                      },
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

  Widget _buildRoleChip(
    WidgetRef ref,
    UserRole? currentRole,
    UserRole targetRole,
    String label,
  ) {
    final isSelected = currentRole == targetRole;
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(authRepositoryProvider.notifier).switchRole(targetRole);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellowHighlight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.maroonDark : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

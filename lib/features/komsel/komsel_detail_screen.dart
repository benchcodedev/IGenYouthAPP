import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/pill_top_bar.dart';
import '../../data/models/komsel_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/komsel_repository.dart';

class KomselDetailScreen extends ConsumerStatefulWidget {
  final String komselId;

  const KomselDetailScreen({super.key, required this.komselId});

  @override
  ConsumerState<KomselDetailScreen> createState() => _KomselDetailScreenState();
}

class _KomselDetailScreenState extends ConsumerState<KomselDetailScreen> {
  bool _isAdminEditMode = false;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    final komsel = ref.read(komselRepositoryProvider.notifier).getById(widget.komselId);
    _titleController = TextEditingController(text: komsel?.nama ?? '');
    _descController = TextEditingController(text: komsel?.deskripsi ?? '');
    _alamatController = TextEditingController(text: komsel?.alamat ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _openWhatsApp(String wa, String komselNama) async {
    final clean = wa.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean?text=Halo%20Kak,%20saya%20tertarik%20tanya%20seputar%20komsel%20$komselNama');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap(String alamat, double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleAjukanGabung(KomselModel komsel) {
    final user = ref.read(authRepositoryProvider);
    if (user == null || user.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masuk atau buat akun terlebih dahulu untuk bergabung ke komsel.'),
          backgroundColor: AppColors.maroon,
        ),
      );
      return;
    }

    ref.read(komselRequestsProvider.notifier).requestJoin(
      komselId: komsel.id,
      komselNama: komsel.nama,
      userId: user.id,
      userName: user.nama,
      userWa: user.wa,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permintaan bergabung dengan ${komsel.nama} berhasil diajukan!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _saveAdminEdits(KomselModel komsel) {
    final updated = komsel.copyWith(
      nama: _titleController.text.trim(),
      deskripsi: _descController.text.trim(),
      alamat: _alamatController.text.trim(),
    );
    ref.read(komselRepositoryProvider.notifier).updateKomsel(updated);
    setState(() => _isAdminEditMode = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan data komsel berhasil disimpan!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final komselList = ref.watch(komselRepositoryProvider);
    final komsel = komselList.firstWhere(
      (k) => k.id == widget.komselId,
      orElse: () => komselList.first,
    );

    final user = ref.watch(authRepositoryProvider);
    final requests = ref.watch(komselRequestsProvider);
    final userRequest = user != null
        ? requests.where((r) => r.komselId == komsel.id && r.userId == user.id).firstOrNull
        : null;

    final isAdmin = user != null && user.isAdmin;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    final headerDateStr = DateFormat('d MMMM, yyyy', 'id').format(now);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrowLeft, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      const IGenWordmark(size: 20),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 14, color: AppColors.maroon),
                      const SizedBox(width: 6),
                      Text(
                        headerDateStr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Signature Maroon Action Bar
              PillDetailActionBar(
                actionLabel: userRequest?.isApproved == true
                    ? 'Sudah Bergabung'
                    : (userRequest?.isPending == true ? 'Menunggu Approval' : 'Gabung Komsel'),
                actionIcon: LucideIcons.userPlus,
                onActionTap: () => _handleAjukanGabung(komsel),
                onHelpTap: () => _openWhatsApp(komsel.leaderWa, komsel.nama),
                onShareTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tautan komsel "${komsel.nama}" disalin ke clipboard!'),
                      backgroundColor: AppColors.maroon,
                    ),
                  );
                },
                onCalendarTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Jadwal rutin ${komsel.hari} ditambahkan ke kalender.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Admin Toggle Button
              if (isAdmin) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      if (_isAdminEditMode) {
                        _saveAdminEdits(komsel);
                      } else {
                        setState(() => _isAdminEditMode = true);
                      }
                    },
                    icon: Icon(_isAdminEditMode ? LucideIcons.check : LucideIcons.pencil, size: 16),
                    label: Text(_isAdminEditMode ? 'Simpan Perubahan' : 'Mode Edit Admin'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.maroon,
                      textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],

              // Big Outline Title Field (Faith Notes Screen 3 layout)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isAdminEditMode ? AppColors.maroon : (isDark ? Colors.white12 : AppColors.borderLight),
                    width: _isAdminEditMode ? 2 : 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.users,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _isAdminEditMode
                          ? TextField(
                              controller: _titleController,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            )
                          : Text(
                              komsel.nama,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Two Pill Dropdowns Side by Side (Wilayah & Hari)
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownPill(
                      icon: LucideIcons.mapPin,
                      label: komsel.wilayah,
                      context: context,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownPill(
                      icon: LucideIcons.calendar,
                      label: komsel.hari,
                      context: context,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Detail Section Header
              Text(
                'Detail',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              // Yellow Time Chip + Category
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.yellowHighlight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      komsel.jam,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.maroonDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Kategori: ${komsel.kategori}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Description Text Box
              _isAdminEditMode
                  ? TextField(
                      controller: _descController,
                      maxLines: 5,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        height: 1.6,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurface : Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  : Text(
                      komsel.deskripsi,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        height: 1.6,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
                      ),
                    ),
              const SizedBox(height: 24),

              // Quota / Members Progress Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kapasitas Komsel',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${komsel.anggotaCount} / ${komsel.kuota} Anggota',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.maroon,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (komsel.anggotaCount / komsel.kuota).clamp(0.0, 1.0),
                        backgroundColor: AppColors.softMint,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellowHighlight),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location & Address Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, color: AppColors.redAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            komsel.alamat,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _openMap(komsel.alamat, komsel.lat, komsel.lng),
                      icon: const Icon(LucideIcons.externalLink, size: 16),
                      label: const Text('Petunjuk Arah Google Maps'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Komsel Leader Profile & Direct WhatsApp Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.borderLight,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(komsel.leaderFoto),
                      backgroundColor: AppColors.maroon,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            komsel.leaderName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Leader Komsel ${komsel.wilayah}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(komsel.leaderWa, komsel.nama),
                      icon: const Icon(LucideIcons.messageCircle, size: 16),
                      label: const Text('Chat WA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(110, 42),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Big Action Button: Ajukan Gabung / Status
              ElevatedButton(
                onPressed: () => _handleAjukanGabung(komsel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: userRequest?.isApproved == true
                      ? AppColors.success
                      : (userRequest?.isPending == true ? AppColors.mauve : AppColors.yellowHighlight),
                  foregroundColor: (userRequest != null) ? Colors.white : AppColors.maroonDark,
                  minimumSize: const Size(double.infinity, 58),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      userRequest?.isApproved == true
                          ? LucideIcons.checkCheck
                          : (userRequest?.isPending == true ? LucideIcons.clock : LucideIcons.userPlus),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      userRequest?.isApproved == true
                          ? 'Kamu Anggota Komsel Ini'
                          : (userRequest?.isPending == true
                              ? 'Permintaan Terkirim (Menunggu Persetujuan)'
                              : 'Ajukan Gabung Komsel Ini'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
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

  Widget _buildDropdownPill({
    required IconData icon,
    required String label,
    required BuildContext context,
    required bool isDark,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(LucideIcons.chevronDown, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
        ],
      ),
    );
  }
}

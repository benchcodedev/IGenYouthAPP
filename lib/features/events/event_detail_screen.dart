import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/pill_top_bar.dart';
import '../../core/widgets/qr_ticket_dialog.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/event_repository.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isAdminEditMode = false;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _lokasiController;

  @override
  void initState() {
    super.initState();
    final event = ref.read(eventRepositoryProvider.notifier).getById(widget.eventId);
    _titleController = TextEditingController(text: event?.judul ?? '');
    _descController = TextEditingController(text: event?.deskripsi ?? '');
    _lokasiController = TextEditingController(text: event?.lokasi ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  void _openWhatsApp(String wa, String eventJudul) async {
    final cleanWa = wa.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanWa?text=Halo%20Kak,%20saya%20mau%20tanya%20seputar%20event%20$eventJudul');
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

  void _handleDaftar(EventModel event) {
    final user = ref.read(authRepositoryProvider);
    if (user == null || user.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masuk atau buat akun terlebih dahulu untuk mendaftar event.'),
          backgroundColor: AppColors.maroon,
        ),
      );
      return;
    }

    final regNotifier = ref.read(registrationsProvider.notifier);
    final reg = regNotifier.register(
      eventId: event.id,
      userId: user.id,
      userName: user.nama,
      userWa: user.wa,
    );
    ref.read(eventRepositoryProvider.notifier).decrementQuota(event.id);

    _showTicket(reg, event);
  }

  void _showTicket(dynamic reg, EventModel event) {
    showDialog(
      context: context,
      builder: (_) => QrTicketDialog(
        registration: reg,
        event: event,
        onSimulateCheckIn: () {
          ref.read(registrationsProvider.notifier).checkInWithQr(reg.qrCode);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check-in Berhasil! Kehadiran telah tercatat.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _saveAdminEdits(EventModel event) {
    final updated = event.copyWith(
      judul: _titleController.text.trim(),
      deskripsi: _descController.text.trim(),
      lokasi: _lokasiController.text.trim(),
    );
    ref.read(eventRepositoryProvider.notifier).updateEvent(updated);
    setState(() => _isAdminEditMode = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan event berhasil disimpan!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventRepositoryProvider);
    final event = events.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => events.first,
    );

    final user = ref.watch(authRepositoryProvider);
    final registrations = ref.watch(registrationsProvider);
    final isRegistered = user != null &&
        registrations.any((r) => r.eventId == event.id && r.userId == user.id);
    final existingReg = isRegistered
        ? registrations.firstWhere((r) => r.eventId == event.id && r.userId == user.id)
        : null;

    final isAdmin = user != null && user.isAdmin;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    final headerDateStr = DateFormat('d MMMM, yyyy', 'id').format(now);
    final timeStr = DateFormat('HH:mm', 'id').format(event.mulai);
    final fullDateStr = DateFormat('EEEE, d MMMM yyyy', 'id').format(event.mulai);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row (Wordmark + Date)
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

              // Signature Maroon Action Bar (Exact Layout as Reference Screen 3)
              PillDetailActionBar(
                actionLabel: isRegistered ? 'Lihat Tiket' : 'Daftar Event',
                actionIcon: isRegistered ? LucideIcons.qrCode : LucideIcons.ticket,
                onActionTap: () {
                  if (isRegistered && existingReg != null) {
                    _showTicket(existingReg, event);
                  } else {
                    _handleDaftar(event);
                  }
                },
                onHelpTap: () => _openWhatsApp(event.picWa, event.judul),
                onShareTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tautan event "${event.judul}" disalin ke clipboard!'),
                      backgroundColor: AppColors.maroon,
                    ),
                  );
                },
                onCalendarTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event ditambahkan ke Google Calendar / Kalender HP.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Poster Banner Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    event.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.maroon,
                      child: const Icon(LucideIcons.image, color: Colors.white54, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Admin Toggle Button
              if (isAdmin) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      if (_isAdminEditMode) {
                        _saveAdminEdits(event);
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

              // Big Outline Title Field (Faith Notes Screen 3 "Sermon Title" block)
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
                      LucideIcons.fileText,
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
                              event.judul,
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

              // Two Pill Dropdowns Side by Side (Faith Notes Screen 3 layout)
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownPill(
                      icon: LucideIcons.tag,
                      label: event.kategoriLabel,
                      context: context,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownPill(
                      icon: LucideIcons.mapPin,
                      label: event.lokasi.split(',').first,
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

              // Yellow Time Chip + Date Information (Faith Notes Screen 3 "08:30" chip)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.yellowHighlight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$timeStr WIB',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.maroonDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    fullDateStr,
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
                      maxLines: 6,
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
                      event.deskripsi,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        height: 1.6,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
                      ),
                    ),
              const SizedBox(height: 24),

              // Location & Map Preview Card
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
                            event.lokasi,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.alamat,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _openMap(event.alamat, event.lat, event.lng),
                      icon: const Icon(LucideIcons.externalLink, size: 16),
                      label: const Text('Buka di Google Maps'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // PIC / Leader Contact Card
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
                      radius: 22,
                      backgroundColor: AppColors.maroon,
                      child: const Icon(LucideIcons.userCheck, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.picName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'PIC / Koordinator Acara',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(event.picWa, event.judul),
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

              // Bottom Big Registration Pill Button
              ElevatedButton(
                onPressed: () {
                  if (isRegistered && existingReg != null) {
                    _showTicket(existingReg, event);
                  } else {
                    _handleDaftar(event);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRegistered ? AppColors.maroon : AppColors.yellowHighlight,
                  foregroundColor: isRegistered ? Colors.white : AppColors.maroonDark,
                  minimumSize: const Size(double.infinity, 58),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isRegistered ? LucideIcons.qrCode : LucideIcons.ticket,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isRegistered ? 'Buka Tiket QR Kamu' : 'Daftar Sekarang (Sisa ${event.sisaKuota} slot)',
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

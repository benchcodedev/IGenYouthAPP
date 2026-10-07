import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../data/models/event_model.dart';
import '../../data/models/announcement_model.dart';
import '../../data/models/devotion_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/komsel_repository.dart';
import '../../data/repositories/announcement_repository.dart';
import '../../data/repositories/devotion_repository.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _qrInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _qrInputController.dispose();
    super.dispose();
  }

  void _showQuickEditWordOfTheDayDialog(DevotionModel current) {
    final ayatCtrl = TextEditingController(text: current.ayat);
    final refCtrl = TextEditingController(text: current.referensi);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Word of the Day',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.maroon,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildField('Referensi Nats', refCtrl, 'mis. Filipi 4:13'),
                const SizedBox(height: 12),
                _buildField('Isi Ayat Firman', ayatCtrl, 'Ketik teks ayat...', maxLines: 4),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (ayatCtrl.text.trim().isEmpty || refCtrl.text.trim().isEmpty) return;
                    ref.read(devotionRepositoryProvider.notifier).updateWordOfTheDayText(
                          ayat: ayatCtrl.text.trim(),
                          referensi: refCtrl.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Word of the Day berhasil diperbarui dan tampil di Beranda!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowHighlight,
                    foregroundColor: AppColors.maroonDark,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Simpan & Tampilkan di Beranda', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDevotionDialog() {
    final titleCtrl = TextEditingController();
    final verseCtrl = TextEditingController();
    final refCtrl = TextEditingController();
    final reflCtrl = TextEditingController();
    final prayerCtrl = TextEditingController();
    final authorCtrl = TextEditingController(text: 'Pastor Youth');
    bool setAsWordOfTheDay = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tambah Renungan Baru',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.maroon,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildField('Judul Renungan', titleCtrl, 'mis. Berani Melangkah dengan Iman'),
                  const SizedBox(height: 10),
                  _buildField('Referensi Alkitab', refCtrl, 'mis. Mazmur 23:1'),
                  const SizedBox(height: 10),
                  _buildField('Teks Nats Ayat', verseCtrl, 'Ketik teks ayat...', maxLines: 3),
                  const SizedBox(height: 10),
                  _buildField('Refleksi / Isi Renungan', reflCtrl, 'Penjelasan singkat & aplikasi...', maxLines: 3),
                  const SizedBox(height: 10),
                  _buildField('Doa Hari Ini', prayerCtrl, 'Doa singkat...', maxLines: 2),
                  const SizedBox(height: 10),
                  _buildField('Penulis / Pengkhotbah', authorCtrl, 'mis. Pastor Andre Tan'),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: setAsWordOfTheDay,
                    onChanged: (val) => setDialogState(() => setAsWordOfTheDay = val ?? true),
                    title: Text(
                      'Jadikan "Word of the Day" di Beranda hari ini',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.maroon,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.trim().isEmpty || verseCtrl.text.trim().isEmpty || refCtrl.text.trim().isEmpty) {
                        return;
                      }
                      final newDev = DevotionModel(
                        id: 'dev_${DateTime.now().millisecondsSinceEpoch}',
                        tanggal: DateTime.now(),
                        judul: titleCtrl.text.trim(),
                        ayat: verseCtrl.text.trim(),
                        referensi: refCtrl.text.trim(),
                        refleksi: reflCtrl.text.trim().isEmpty ? 'Refleksi firman Tuhan.' : reflCtrl.text.trim(),
                        doa: prayerCtrl.text.trim(),
                        penulis: authorCtrl.text.trim().isEmpty ? 'Pastor Youth' : authorCtrl.text.trim(),
                        isWordOfTheDay: setAsWordOfTheDay,
                      );

                      final notifier = ref.read(devotionRepositoryProvider.notifier);
                      notifier.addDevotion(newDev);
                      if (setAsWordOfTheDay) {
                        notifier.setWordOfTheDay(newDev.id);
                      }

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Renungan baru berhasil diterbitkan!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Terbitkan Renungan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final quotaCtrl = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buat Event Baru',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.maroon,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildField('Judul Event', titleCtrl, 'mis. Youth Worship Gathering'),
                const SizedBox(height: 10),
                _buildField('Lokasi Acara', locCtrl, 'mis. Chapel Lt. 2'),
                const SizedBox(height: 10),
                _buildField('Kuota Peserta', quotaCtrl, '100', isNumber: true),
                const SizedBox(height: 10),
                _buildField('Deskripsi Singkat', descCtrl, 'Deskripsi lengkap event...', maxLines: 3),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.isEmpty) return;
                    final kuota = int.tryParse(quotaCtrl.text) ?? 100;
                    final newEvent = EventModel(
                      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
                      judul: titleCtrl.text.trim(),
                      deskripsi: descCtrl.text.trim().isEmpty ? 'Acara persekutuan spesial IGen Youth.' : descCtrl.text.trim(),
                      posterUrl: 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=800&q=80',
                      mulai: DateTime.now().add(const Duration(days: 7, hours: 18)),
                      selesai: DateTime.now().add(const Duration(days: 7, hours: 21)),
                      lokasi: locCtrl.text.trim().isEmpty ? 'Gedung Gereja' : locCtrl.text.trim(),
                      alamat: 'Jl. Boulevard Raya Blok QJ No. 1, Jakarta',
                      kuota: kuota,
                      sisaKuota: kuota,
                      kategori: EventCategory.youthNight,
                    );
                    ref.read(eventRepositoryProvider.notifier).addEvent(newEvent);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Event baru berhasil dipublikasikan!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowHighlight,
                    foregroundColor: AppColors.maroonDark,
                    minimumSize: const Size(double.infinity, 50),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Simpan & Terbitkan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kirim Pengumuman Baru',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildField('Judul Pengumuman', titleCtrl, 'Judul informasi...'),
              const SizedBox(height: 10),
              _buildField('Isi Pengumuman', bodyCtrl, 'Isi pesan lengkap...', maxLines: 4),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.isEmpty) return;
                  final newAnn = AnnouncementModel(
                    id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
                    judul: titleCtrl.text.trim(),
                    isi: bodyCtrl.text.trim(),
                    label: 'Umum',
                    tanggal: DateTime.now(),
                    author: 'Admin IGen',
                  );
                  ref.read(announcementRepositoryProvider.notifier).addAnnouncement(newAnn);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengumuman baru berhasil disebarkan!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Kirim Pengumuman'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: AppColors.softBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            style: GoogleFonts.plusJakartaSans(fontSize: 13.5),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _handleQrCheckIn() {
    final qr = _qrInputController.text.trim();
    if (qr.isEmpty) return;

    final success = ref.read(registrationsProvider.notifier).checkInWithQr(qr);
    if (success) {
      _qrInputController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SUKSES! Peserta dengan kode QR "$qr" berhasil Check-In.'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('KODE QR TIDAK DITEMUKAN: "$qr". Periksa kembali kode.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final events = ref.watch(eventRepositoryProvider);
    final registrations = ref.watch(registrationsProvider);
    final komselRequests = ref.watch(komselRequestsProvider);
    final announcements = ref.watch(announcementRepositoryProvider);
    final devotions = ref.watch(devotionRepositoryProvider);
    final todayDevotion = ref.watch(todayDevotionProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const IGenWordmark(size: 20),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.maroon,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'ADMIN DASHBOARD',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.yellowHighlight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.yellowHighlight,
                indicatorWeight: 3,
                labelColor: isDark ? AppColors.yellowHighlight : AppColors.maroon,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'QR Scan'),
                  Tab(text: 'Event'),
                  Tab(text: 'Komsel'),
                  Tab(text: 'Info'),
                  Tab(text: 'Firman'),
                ],
              ),
            ),
            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1: QR Check-In Scanner Simulation & Registrations List
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // QR Scanner Simulator Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.maroon,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(LucideIcons.scanLine, color: AppColors.yellowHighlight, size: 22),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Simulator Check-In Scanner',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ketik atau tempel kode tiket QR peserta di bawah ini untuk check-in instan (contoh: IGEN-CAMP26-ARIEL-001):',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: TextField(
                                        controller: _qrInputController,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Kode Tiket / QR...',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: _handleQrCheckIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.yellowHighlight,
                                      foregroundColor: AppColors.maroonDark,
                                      minimumSize: const Size(90, 44),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: const Text('Check-In'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Daftar Pendaftar & Kehadiran (${registrations.length})',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        ...registrations.map((r) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: r.isCheckedIn ? AppColors.success : AppColors.softMint,
                                child: Icon(
                                  r.isCheckedIn ? LucideIcons.check : LucideIcons.ticket,
                                  size: 16,
                                  color: r.isCheckedIn ? Colors.white : AppColors.maroon,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.userName,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${r.qrCode} • WA: ${r.userWa}',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: r.isCheckedIn ? AppColors.success : AppColors.yellowHighlight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  r.status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: r.isCheckedIn ? Colors.white : AppColors.maroonDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  // TAB 2: Manage Events (CRUD)
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAddEventDialog,
                        icon: const Icon(LucideIcons.plus, size: 18),
                        label: const Text('Buat Event Baru'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowHighlight,
                          foregroundColor: AppColors.maroonDark,
                          minimumSize: const Size(double.infinity, 50),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...events.map((e) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.judul, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                                  Text('${e.lokasi} • Kuota: ${e.sisaKuota}/${e.kuota}', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.redAccent),
                              onPressed: () {
                                ref.read(eventRepositoryProvider.notifier).deleteEvent(e.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Event telah dihapus.')),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),

                  // TAB 3: Komsel Join Request Approvals
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        'Persetujuan Gabung Komsel (${komselRequests.length})',
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ...komselRequests.map((req) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  req.userName,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 14.5, fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: req.isApproved ? AppColors.success : AppColors.yellowHighlight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    req.status.toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: req.isApproved ? Colors.white : AppColors.maroonDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Target: ${req.komselNama} • WA: ${req.userWa}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textSecondary),
                            ),
                            if (req.isPending) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        ref.read(komselRequestsProvider.notifier).rejectRequest(req.id);
                                      },
                                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                                      child: const Text('Tolak'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ref.read(komselRequestsProvider.notifier).approveRequest(req.id);
                                        ref.read(komselRepositoryProvider.notifier).incrementMember(req.komselId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Permintaan disetujui! Anggota telah bergabung.'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(0, 36),
                                      ),
                                      child: const Text('Setujui'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )),
                    ],
                  ),

                  // TAB 4: Manage Announcements & Push Simulation
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAddAnnouncementDialog,
                        icon: const Icon(LucideIcons.send, size: 18),
                        label: const Text('Buat & Broadcast Pengumuman'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...announcements.map((a) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (a.pinned) const Icon(LucideIcons.pin, size: 14, color: AppColors.maroon),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          a.judul,
                                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(a.label, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(a.pinned ? LucideIcons.pinOff : LucideIcons.pin, size: 18),
                              onPressed: () {
                                ref.read(announcementRepositoryProvider.notifier).togglePin(a.id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.redAccent),
                              onPressed: () {
                                ref.read(announcementRepositoryProvider.notifier).deleteAnnouncement(a.id);
                              },
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),

                  // TAB 5: Manage Word of the Day & Devotions
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Active Word of the Day Highlight Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.softMint,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: AppColors.maroon.withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(LucideIcons.sparkles, size: 16, color: AppColors.maroon),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Word of the Day Aktif',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.maroon,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellowHighlight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Tampil di Beranda',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.maroonDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '“${todayDevotion.ayat}”',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              todayDevotion.referensi,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.maroonDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _showQuickEditWordOfTheDayDialog(todayDevotion),
                                icon: const Icon(LucideIcons.pencil, size: 16),
                                label: const Text('Edit Langsung Ayat Ini'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.maroon,
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      ElevatedButton.icon(
                        onPressed: _showAddDevotionDialog,
                        icon: const Icon(LucideIcons.plus, size: 18),
                        label: const Text('Buat Renungan Harian Baru'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowHighlight,
                          foregroundColor: AppColors.maroonDark,
                          minimumSize: const Size(double.infinity, 48),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Pilih Renungan untuk Word of the Day (${devotions.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...devotions.map((d) {
                        final isActive = d.id == todayDevotion.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive ? AppColors.yellowHighlight : AppColors.borderLight,
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      d.judul,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.yellowHighlight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'AKTIF',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.maroonDark,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                d.referensi,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.maroon,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                d.ayat,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!isActive)
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        ref.read(devotionRepositoryProvider.notifier).setWordOfTheDay(d.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('"${d.referensi}" sekarang menjadi Word of the Day di Beranda!'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      },
                                      icon: const Icon(LucideIcons.star, size: 14),
                                      label: const Text('Jadikan Word of the Day'),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(0, 34),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.redAccent),
                                    onPressed: () {
                                      ref.read(devotionRepositoryProvider.notifier).deleteDevotion(d.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

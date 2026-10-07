import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/pill_top_bar.dart';
import '../../core/widgets/pill_search_bar.dart';
import '../../core/widgets/stacked_category_card.dart';
import '../../core/widgets/word_of_the_day_card.dart';
import '../../core/widgets/event_carousel_card.dart';
import '../../core/widgets/countdown_card.dart';
import '../../core/widgets/qr_ticket_dialog.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/komsel_repository.dart';
import '../../data/repositories/announcement_repository.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/devotion_repository.dart';
import '../../data/repositories/dummy_data.dart';
import '../../data/models/event_model.dart';
import '../../data/models/komsel_model.dart';
import '../../data/models/announcement_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openHelpWhatsApp() async {
    final uri = Uri.parse('https://wa.me/6281234567890?text=Halo%20Admin%20IGen%20Youth,%20saya%20butuh%20bantuan');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleDaftarEvent(EventModel event) {
    final user = ref.read(authRepositoryProvider);
    if (user == null || user.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masuk atau buat akun terlebih dahulu untuk mendaftar event.'),
          backgroundColor: AppColors.maroon,
        ),
      );
      context.push('/profile');
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

    showDialog(
      context: context,
      builder: (_) => QrTicketDialog(
        registration: reg,
        event: event,
        onSimulateCheckIn: () {
          regNotifier.checkInWithQr(reg.qrCode);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check-in berhasil! Selamat menikmati event.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider);
    final events = ref.watch(eventRepositoryProvider);
    final komselList = ref.watch(komselRepositoryProvider);
    final announcements = ref.watch(announcementRepositoryProvider);
    final activities = ref.watch(activityRepositoryProvider);
    final todayDevotion = ref.watch(todayDevotionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Indonesian formatted date for header (matching Faith Notes reference)
    final now = DateTime.now();
    final headerDateStr = DateFormat('d MMMM, yyyy', 'id').format(now);

    final bool isAdmin = user != null && user.isAdmin;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row: Wordmark on Left, Date + Icon on Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const IGenWordmark(size: 21),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.calendar,
                          size: 15,
                          color: AppColors.maroon,
                        ),
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

                // Maroon Pill Shortcut Bar (Jadwal, Bantuan, Pengaturan)
                PillShortcutBar(
                  onJadwalTap: () => context.push('/activities'),
                  onBantuanTap: _openHelpWhatsApp,
                  onPengaturanTap: () => context.push('/profile'),
                ),
                const SizedBox(height: 14),

                // Outline Pill Search Bar
                PillSearchBar(
                  controller: _searchController,
                  hintText: 'Cari event, komsel, info...',
                  onChanged: (val) {
                    setState(() => _searchQuery = val.trim().toLowerCase());
                  },
                ),
                const SizedBox(height: 18),

                // Search Results if Query is active
                if (_searchQuery.isNotEmpty) ...[
                  _buildSearchResults(events, komselList, announcements),
                ] else ...[
                  // Categories Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => context.push('/events'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(82, 34),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: Text(
                              'Add New',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isAdmin) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => context.push('/admin'),
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.yellowHighlight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.plus,
                                  size: 18,
                                  color: AppColors.maroonDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // The 5 STACKED CATEGORY CARDS with top notched tab
                  StackedCategoryCard(
                    item: CategoryCardItem(
                      id: 'cat_info',
                      title: 'Semua Info',
                      count: announcements.length,
                      subtitle: 'pengumuman & kabar terbaru',
                      icon: LucideIcons.newspaper,
                      backgroundColor: AppColors.catInfo,
                      onTap: () => context.push('/announcements'),
                    ),
                    isFirst: true,
                  ),
                  StackedCategoryCard(
                    item: CategoryCardItem(
                      id: 'cat_event',
                      title: 'Event',
                      count: events.length,
                      subtitle: 'acara dan kegiatan spesial',
                      icon: LucideIcons.calendar,
                      backgroundColor: AppColors.catEvent,
                      onTap: () => context.push('/events'),
                    ),
                  ),
                  StackedCategoryCard(
                    item: CategoryCardItem(
                      id: 'cat_komsel',
                      title: 'Komsel',
                      count: komselList.length,
                      subtitle: 'temukan komunitas sel kamu',
                      icon: LucideIcons.users,
                      backgroundColor: AppColors.catKomsel,
                      textColor: AppColors.maroonDark,
                      badgeColor: AppColors.maroon,
                      badgeTextColor: Colors.white,
                      onTap: () => context.push('/komsel'),
                    ),
                  ),
                  StackedCategoryCard(
                    item: CategoryCardItem(
                      id: 'cat_activities',
                      title: 'Kegiatan Rutin',
                      count: activities.length,
                      subtitle: 'jadwal ibadah & pelayanan mingguan',
                      icon: LucideIcons.clock,
                      backgroundColor: AppColors.catActivities,
                      onTap: () => context.push('/activities'),
                    ),
                  ),
                  StackedCategoryCard(
                    item: CategoryCardItem(
                      id: 'cat_gallery',
                      title: 'Galeri',
                      count: DummyData.galleryItems.length,
                      subtitle: 'foto dan momen kebersamaan',
                      icon: LucideIcons.image,
                      backgroundColor: AppColors.catGallery,
                      onTap: () => context.push('/gallery'),
                    ),
                    isLast: true,
                  ),
                  const SizedBox(height: 24),

                  // Section: Word of the Day (Ayat Hari Ini)
                  Text(
                    'Word of the day',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  WordOfTheDayCard(
                    verse: todayDevotion.ayat,
                    reference: todayDevotion.referensi,
                    onTap: () => context.push('/devotions'),
                  ),
                  const SizedBox(height: 24),

                  // Section: Countdown Ibadah Youth
                  const CountdownServiceCard(),
                  const SizedBox(height: 28),

                  // Section: Event Mendatang Carousel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Mendatang',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/events'),
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.maroon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCarouselCard(
                          event: event,
                          onTap: () => context.push('/events/${event.id}'),
                          onDaftarTap: () => _handleDaftarEvent(event),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    List<EventModel> events,
    List<KomselModel> komsel,
    List<AnnouncementModel> announcements,
  ) {
    final matchedEvents = events.where((e) =>
      e.judul.toLowerCase().contains(_searchQuery) ||
      e.deskripsi.toLowerCase().contains(_searchQuery) ||
      e.lokasi.toLowerCase().contains(_searchQuery)
    ).toList();

    final matchedKomsel = komsel.where((k) =>
      k.nama.toLowerCase().contains(_searchQuery) ||
      k.wilayah.toLowerCase().contains(_searchQuery) ||
      k.hari.toLowerCase().contains(_searchQuery)
    ).toList();

    final matchedAnnouncements = announcements.where((a) =>
      a.judul.toLowerCase().contains(_searchQuery) ||
      a.isi.toLowerCase().contains(_searchQuery)
    ).toList();

    if (matchedEvents.isEmpty && matchedKomsel.isEmpty && matchedAnnouncements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(LucideIcons.searchX, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Tidak ada hasil untuk "$_searchQuery"',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (matchedEvents.isNotEmpty) ...[
          Text(
            'Event Ditemukan (${matchedEvents.length})',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...matchedEvents.map((e) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.calendar, color: AppColors.redAccent),
            ),
            title: Text(e.judul, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            subtitle: Text('${e.lokasi} • Sisa ${e.sisaKuota} slot', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
            trailing: const Icon(LucideIcons.chevronRight, size: 16),
            onTap: () => context.push('/events/${e.id}'),
          )),
          const SizedBox(height: 16),
        ],
        if (matchedKomsel.isNotEmpty) ...[
          Text(
            'Komsel Ditemukan (${matchedKomsel.length})',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...matchedKomsel.map((k) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellowHighlight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.users, color: AppColors.maroonDark),
            ),
            title: Text(k.nama, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            subtitle: Text('${k.wilayah} • ${k.hari} ${k.jam}', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
            trailing: const Icon(LucideIcons.chevronRight, size: 16),
            onTap: () => context.push('/komsel/${k.id}'),
          )),
          const SizedBox(height: 16),
        ],
        if (matchedAnnouncements.isNotEmpty) ...[
          Text(
            'Info & Pengumuman (${matchedAnnouncements.length})',
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...matchedAnnouncements.map((a) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.maroon.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.newspaper, color: AppColors.maroon),
            ),
            title: Text(a.judul, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            subtitle: Text(a.author, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
            trailing: const Icon(LucideIcons.chevronRight, size: 16),
            onTap: () => context.push('/announcements'),
          )),
        ],
      ],
    );
  }
}

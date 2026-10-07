import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/pill_search_bar.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<String> _filters = [
    'Semua',
    'Youth Night',
    'Camp',
    'Outing',
    'Worship Night',
    'Bakti Sosial',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredEvents = events.where((e) {
      final matchesQuery = e.judul.toLowerCase().contains(_searchQuery) ||
          e.lokasi.toLowerCase().contains(_searchQuery);
      if (!matchesQuery) return false;

      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Youth Night') return e.kategori == EventCategory.youthNight;
      if (_selectedFilter == 'Camp') return e.kategori == EventCategory.camp;
      if (_selectedFilter == 'Outing') return e.kategori == EventCategory.outing;
      if (_selectedFilter == 'Worship Night') return e.kategori == EventCategory.worshipNight;
      if (_selectedFilter == 'Bakti Sosial') return e.kategori == EventCategory.baksos;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  const IGenWordmark(size: 20),
                  const Spacer(),
                  Text(
                    'Agenda & Event',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PillSearchBar(
                controller: _searchController,
                hintText: 'Cari acara youth & teens...',
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
            ),
            const SizedBox(height: 12),
            // Filters Horizontal List
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return InkWell(
                    onTap: () => setState(() => _selectedFilter = filter),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.maroon
                            : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.maroon
                              : (isDark ? Colors.white12 : AppColors.borderLight),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Events List
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada event yang sesuai kriteria.',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        final dateStr = DateFormat('d MMM yyyy, HH:mm', 'id').format(event.mulai);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => context.push('/events/${event.id}'),
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Poster Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: Image.network(
                                        event.posterUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          color: AppColors.maroon,
                                          child: const Icon(LucideIcons.calendar, color: Colors.white, size: 28),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.softMint,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                event.kategoriLabel,
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.maroonDark,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              event.isGratis ? 'GRATIS' : 'Rp ${NumberFormat('#,###', 'id').format(event.harga)}',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w800,
                                                color: event.isGratis ? AppColors.success : AppColors.maroon,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          event.judul,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(LucideIcons.clock, size: 13, color: AppColors.textMuted),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                dateStr,
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 11.5,
                                                  color: AppColors.textMuted,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

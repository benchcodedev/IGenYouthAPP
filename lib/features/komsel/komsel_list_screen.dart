import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../core/widgets/pill_search_bar.dart';
import '../../data/repositories/komsel_repository.dart';

class KomselListScreen extends ConsumerStatefulWidget {
  const KomselListScreen({super.key});

  @override
  ConsumerState<KomselListScreen> createState() => _KomselListScreenState();
}

class _KomselListScreenState extends ConsumerState<KomselListScreen> {
  String _selectedWilayah = 'Semua Wilayah';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<String> _wilayahFilters = [
    'Semua Wilayah',
    'Jakarta Barat',
    'Jakarta Selatan',
    'Jakarta Utara',
    'Jakarta Pusat',
    'Jakarta Timur & Pusat',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openWhatsApp(String wa, String komselNama) async {
    final clean = wa.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean?text=Halo%20Kak,%20saya%20tertarik%20gabung%20komsel%20$komselNama');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final komselList = ref.watch(komselRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = komselList.where((k) {
      final matchesQuery = k.nama.toLowerCase().contains(_searchQuery) ||
          k.leaderName.toLowerCase().contains(_searchQuery) ||
          k.alamat.toLowerCase().contains(_searchQuery);
      if (!matchesQuery) return false;

      if (_selectedWilayah != 'Semua Wilayah' && k.wilayah != _selectedWilayah) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  const IGenWordmark(size: 20),
                  const Spacer(),
                  Text(
                    'Komunitas Sel',
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
                hintText: 'Cari nama komsel, leader, lokasi...',
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
            ),
            const SizedBox(height: 12),
            // Wilayah Filters
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _wilayahFilters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final wilayah = _wilayahFilters[index];
                  final isSelected = wilayah == _selectedWilayah;
                  return InkWell(
                    onTap: () => setState(() => _selectedWilayah = wilayah),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.yellowHighlight
                            : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.yellowHighlight
                              : (isDark ? Colors.white12 : AppColors.borderLight),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        wilayah,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.maroonDark
                              : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // List of Komsel Cards
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada komsel ditemukan.',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final komsel = filtered[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => context.push('/komsel/${komsel.id}'),
                            borderRadius: BorderRadius.circular(26),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row: Kategori chip + Member Count badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.softMint,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          komsel.kategori,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.maroonDark,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(LucideIcons.users, size: 14, color: AppColors.maroon),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${komsel.anggotaCount}/${komsel.kuota} Anggota',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.maroon,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    komsel.nama,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    komsel.deskripsi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Schedule & Location
                                  Row(
                                    children: [
                                      const Icon(LucideIcons.clock, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${komsel.hari}, ${komsel.jam}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          komsel.wilayah,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  // Leader row + Chat WA
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(komsel.leaderFoto),
                                        backgroundColor: AppColors.maroon,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              komsel.leaderName,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              'Komsel Leader',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () => _openWhatsApp(komsel.leaderWa, komsel.nama),
                                        icon: const Icon(LucideIcons.messageCircle, size: 14, color: Color(0xFF25D366)),
                                        label: const Text('Chat Leader'),
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(110, 36),
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                        ),
                                      ),
                                    ],
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

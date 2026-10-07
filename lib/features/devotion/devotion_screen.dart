import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../data/models/devotion_model.dart';
import '../../data/repositories/devotion_repository.dart';

class DevotionScreen extends ConsumerStatefulWidget {
  const DevotionScreen({super.key});

  @override
  ConsumerState<DevotionScreen> createState() => _DevotionScreenState();
}

class _DevotionScreenState extends ConsumerState<DevotionScreen> {
  int _selectedIndex = 0;

  void _showShareCardDialog(DevotionModel dev) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Shareable Graphic Card
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const IGenWordmark(size: 20, color: Colors.white, showSubtitle: true),
                    const SizedBox(height: 24),
                    Text(
                      '“${dev.ayat}”',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.yellowHighlight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        dev.referensi,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.maroonDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Renungan Harian IGen Youth',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white60,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.maroonDark,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gambar renungan siap dibagikan ke Instagram Story & WhatsApp!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(LucideIcons.share2, size: 16),
                        label: const Text('Bagikan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowHighlight,
                          foregroundColor: AppColors.maroonDark,
                        ),
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

  @override
  Widget build(BuildContext context) {
    final devotions = ref.watch(devotionRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentDevotion = devotions.isNotEmpty ? devotions[_selectedIndex] : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header
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
                  Text(
                    'Renungan Harian',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
            ),
            // Days horizontal timeline bar
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: devotions.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dev = devotions[index];
                  final isSelected = index == _selectedIndex;
                  final dayLabel = DateFormat('E, d MMM', 'id').format(dev.tanggal);

                  return InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        dayLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
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
            // Devotion Content Body
            Expanded(
              child: currentDevotion == null
                  ? const Center(child: Text('Tidak ada renungan.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Scripture Card in soft mint
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppColors.softMint,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '“${currentDevotion.ayat}”',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    currentDevotion.referensi,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.maroonDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title & Favorite Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  currentDevotion.judul,
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  currentDevotion.isFavorite ? LucideIcons.heart : LucideIcons.heart,
                                  color: currentDevotion.isFavorite ? AppColors.redAccent : AppColors.textMuted,
                                ),
                                onPressed: () {
                                  ref.read(devotionRepositoryProvider.notifier).toggleFavorite(currentDevotion.id);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Refleksi oleh ${currentDevotion.penulis}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Reflection paragraph
                          Text(
                            currentDevotion.refleksi,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              height: 1.7,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Prayer section
                          if (currentDevotion.doa.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: BorderRadius.circular(22),
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
                                      const Icon(LucideIcons.sparkles, size: 16, color: AppColors.yellowHighlight),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Doa Hari Ini',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentDevotion.doa,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Share as Card Button
                          ElevatedButton.icon(
                            onPressed: () => _showShareCardDialog(currentDevotion),
                            icon: const Icon(LucideIcons.share2, size: 18),
                            label: const Text('Bagikan sebagai Kartu Cantik'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellowHighlight,
                              foregroundColor: AppColors.maroonDark,
                              minimumSize: const Size(double.infinity, 54),
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

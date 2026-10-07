import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/igen_wordmark.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_dialog.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onMulaiSekarang() {
    ref.read(authRepositoryProvider.notifier).loginAsGuest();
    context.go('/home');
  }

  void _showLoginDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const AuthDialog(initialIsRegister: false),
    );
    if (result == true && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top App Bar / Wordmark
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      const IGenWordmark(size: 24, showSubtitle: true),
                      const Spacer(),
                      // Subtle Tagline Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          'Youth & Teens',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.maroon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Rounded Maroon Block
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        decoration: BoxDecoration(
                          color: AppColors.maroon,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.maroonDark.withValues(alpha: 0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Stack(
                            children: [
                              // Subtle Background Geometric Cross
                              Positioned(
                                top: -30,
                                left: -20,
                                child: Text(
                                  '✝',
                                  style: TextStyle(
                                    fontSize: 180,
                                    color: Colors.white.withValues(alpha: 0.03),
                                  ),
                                ),
                              ),
                              // Youth Photo / Illustration at the right
                              Positioned(
                                right: -25,
                                bottom: 120,
                                top: 40,
                                width: 230,
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [Colors.transparent, Colors.black],
                                      stops: [0.0, 0.4],
                                    ).createShader(rect);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              // Content Overlay
                              Padding(
                                padding: const EdgeInsets.fromLTRB(26, 36, 26, 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome to',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.yellowHighlight,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'IGen Youth',
                                      style: GoogleFonts.outfit(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -1,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        'Tempat anak muda bertumbuh, berkumpul, dan melayani bersama.',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white.withValues(alpha: 0.9),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    // Big Yellow Pill Button
                                    ElevatedButton(
                                      onPressed: _onMulaiSekarang,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.yellowHighlight,
                                        foregroundColor: AppColors.maroonDark,
                                        minimumSize: const Size(double.infinity, 58),
                                        shape: const StadiumBorder(),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Mulai Sekarang',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(LucideIcons.arrowRight, size: 18),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // White link button below
                                    Center(
                                      child: TextButton(
                                        onPressed: _showLoginDialog,
                                        child: Text(
                                          'Sudah punya akun? Masuk',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.white70,
                                          ),
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

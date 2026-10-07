import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthDialog extends ConsumerStatefulWidget {
  final bool initialIsRegister;

  const AuthDialog({
    super.key,
    this.initialIsRegister = false,
  });

  @override
  ConsumerState<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends ConsumerState<AuthDialog> {
  late bool _isRegister;
  final _emailController = TextEditingController(text: 'ariel@igenyouth.id');
  final _passwordController = TextEditingController(text: 'password123');
  final _namaController = TextEditingController(text: 'Ariel Wijono');
  final _waController = TextEditingController(text: '6281234567890');
  UserCategory _kategori = UserCategory.youth;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _waController.dispose();
    super.dispose();
  }

  void _submit() {
    final authNotifier = ref.read(authRepositoryProvider.notifier);
    if (_isRegister) {
      if (_namaController.text.isEmpty || _emailController.text.isEmpty) return;
      authNotifier.register(
        nama: _namaController.text,
        email: _emailController.text,
        wa: _waController.text,
        tglLahir: DateTime(2004, 5, 12),
        kategori: _kategori,
      );
    } else {
      if (_emailController.text.isEmpty) return;
      authNotifier.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 22, 16, 20),
                decoration: const BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isRegister ? 'Buat Akun IGen' : 'Masuk ke IGen Youth',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isRegister
                                ? 'Bergabung dengan keluarga pemuda & remaja'
                                : 'Akses event, komsel, & tiket digital kamu',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isRegister) ...[
                      _buildTextField(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        hint: 'mis. Ariel Wijono',
                        icon: LucideIcons.user,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _waController,
                        label: 'Nomor WhatsApp',
                        hint: '081234567890',
                        icon: LucideIcons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Kategori Usia',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryOption(
                              'Youth (17–28 th)',
                              UserCategory.youth,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildCategoryOption(
                              'Teens (12–16 th)',
                              UserCategory.teens,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'nama@email.com (ketik "admin" utk test admin)',
                      icon: LucideIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Kata Sandi',
                      hint: '••••••••',
                      icon: LucideIcons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 22),
                    // Submit button
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowHighlight,
                        foregroundColor: AppColors.maroonDark,
                      ),
                      child: Text(
                        _isRegister ? 'Daftar Sekarang' : 'Masuk',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Switch login/register
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => _isRegister = !_isRegister),
                        child: Text(
                          _isRegister
                              ? 'Sudah punya akun? Masuk'
                              : 'Belum punya akun? Buat Akun Baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.maroon,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.softBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1.2),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String title, UserCategory category) {
    final isSelected = _kategori == category;
    return InkWell(
      onTap: () => setState(() => _kategori = category),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.maroon : AppColors.softBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.maroon : AppColors.borderLight,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

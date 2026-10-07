import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import 'dummy_data.dart';

final authRepositoryProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(DummyData.currentUser);

  void loginAsGuest() {
    state = UserModel(
      id: 'guest_user',
      nama: 'Tamu IGen',
      email: 'guest@igenyouth.id',
      wa: '',
      tglLahir: DateTime(2005, 1, 1),
      kategori: UserCategory.youth,
      role: UserRole.guest,
    );
  }

  void login({
    required String email,
    required String password,
  }) {
    if (email.toLowerCase().contains('admin')) {
      state = DummyData.adminUser;
    } else {
      state = DummyData.currentUser.copyWith(email: email);
    }
  }

  void register({
    required String nama,
    required String email,
    required String wa,
    required DateTime tglLahir,
    required UserCategory kategori,
  }) {
    state = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      nama: nama,
      email: email,
      wa: wa,
      tglLahir: tglLahir,
      kategori: kategori,
      role: UserRole.member,
      fotoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    );
  }

  void switchRole(UserRole newRole) {
    if (state == null) return;
    if (newRole == UserRole.admin) {
      state = DummyData.adminUser;
    } else if (newRole == UserRole.guest) {
      loginAsGuest();
    } else {
      state = DummyData.currentUser.copyWith(role: newRole);
    }
  }

  void logout() {
    loginAsGuest();
  }
}

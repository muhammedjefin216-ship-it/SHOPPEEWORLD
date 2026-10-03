// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthRepository {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   User? get currentUser => _supabase.auth.currentUser;
//   Session? get currentSession => _supabase.auth.currentSession;

//   // SIGN UP
//   Future<User?> signUp({
//     required String name,
//     required String phone,
//     required String email,
//     required String password,
//   }) async {
//     final response = await _supabase.auth.signUp(
//       email: email,
//       password: password,
//       // Pass extra profile fields as user metadata
//       data: {
//         'name': name,
//         'phone': phone,
//       },
//     );

//     final user = response.user;
//     if (user == null) {
//       throw Exception("Signup failed");
//     }

//     return user;
//   }

//   // VERIFY OTP
//   Future<AuthResponse> verifySignupOtp({
//     required String email,
//     required String token,
//   }) async {
//     final response = await _supabase.auth.verifyOTP(
//       email: email,
//       token: token,
//       type: OtpType.signup,
//     );

//     // Create the profile row AFTER verification (when session is active)
//     final user = response.user;
//     if (user != null) {
//       await _supabase.from("profiles").upsert({
//         "id": user.id,
//         "name": user.userMetadata?['name'] ?? '',
//         "phone": user.userMetadata?['phone'] ?? '',
//         "email": email,
//       });
//     }

//     return response;
//   }

//   // RESEND OTP
//   Future<void> resendSignupOtp({
//     required String email,
//   }) async {
//     await _supabase.auth.resend(
//       type: OtpType.signup,
//       email: email,
//     );
//   }

//   // LOGIN
//   Future<AuthResponse> login({
//     required String email,
//     required String password,
//   }) async {
//     return await _supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // LOGOUT
//   Future<void> logout() async {
//     await _supabase.auth.signOut();
//   }
// }

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================================================
  // CURRENT AUTH STATE
  // =========================================================

  User? get currentUser => _supabase.auth.currentUser;

  Session? get currentSession => _supabase.auth.currentSession;

  bool get isLoggedIn => currentUser != null;

  // =========================================================
  // SIGN UP
  // =========================================================

  Future<User?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'phone': phone,
      },
    );

    final user = response.user;

    if (user == null) {
      throw Exception('Signup failed');
    }

    return user;
  }

  // =========================================================
  // VERIFY SIGNUP OTP
  // =========================================================

  Future<AuthResponse> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('Email verification failed');
    }

    // Create / update profile after verification
    await _supabase.from('profiles').upsert({
      'id': user.id,
      'name': user.userMetadata?['name'] ?? '',
      'phone': user.userMetadata?['phone'] ?? '',
      'email': user.email ?? email,
    });

    return response;
  }

  // =========================================================
  // RESEND SIGNUP OTP
  // =========================================================

  Future<void> resendSignupOtp({
    required String email,
  }) async {
    await _supabase.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null || response.session == null) {
      throw Exception('Login failed');
    }

    return response;
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
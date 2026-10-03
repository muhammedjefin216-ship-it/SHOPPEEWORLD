import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppee_world/user/repositories/auth_repository.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authLoadingProvider =
    StateProvider<bool>((ref) => false);
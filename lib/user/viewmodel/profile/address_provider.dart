import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/models/profile/address_model.dart';
import 'package:shoppee_world/user/repositories/address_repositery.dart';

/// Place at: lib/user/viewmodel/address/address_provider.dart

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository();
});

/// The signed-in user's saved addresses.
/// Call `ref.invalidate(addressesProvider)` after any change to reload.
final addressesProvider =
    FutureProvider.autoDispose<List<AddressModel>>((ref) {
  return ref.watch(addressRepositoryProvider).getAddresses();
});
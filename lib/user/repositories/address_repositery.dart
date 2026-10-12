import 'package:shoppee_world/user/models/profile/address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/// Place at: lib/user/repositories/address_repository.dart
class AddressRepository {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _table = 'user_addresses';

  /// Default address first, then newest first.
  Future<List<AddressModel>> getAddresses() async {
    final data = await _client
        .from(_table)
        .select()
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map(
          (row) => AddressModel.fromMap(
            Map<String, dynamic>.from(row as Map),
          ),
        )
        .toList();
  }

  Future<AddressModel> addAddress(AddressModel address) async {
    final userId = _client.auth.currentUser!.id;

    final row = await _client
        .from(_table)
        .insert({
          ...address.toMap(),
          'user_id': userId,
        })
        .select()
        .single();

    return AddressModel.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> updateAddress(AddressModel address) async {
    await _client
        .from(_table)
        .update(address.toMap())
        .eq('id', address.id);
  }

  Future<void> deleteAddress(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  /// Makes one address the default and clears the flag on the others,
  /// in a single database transaction.
  Future<void> setDefault(String id) async {
    await _client.rpc(
      'set_default_address',
      params: {'p_address_id': id},
    );
  }
}
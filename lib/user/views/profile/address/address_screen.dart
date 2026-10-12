import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/models/profile/address_model.dart';
import 'package:shoppee_world/user/viewmodel/profile/address_provider.dart';
import 'package:shoppee_world/user/views/profile/address/address_form_screen.dart';

/// Place at: lib/user/views/profile/addresses_screen.dart
///
/// With [selectMode] = true, tapping an address closes the screen and
/// returns it (for use at checkout). Normal mode is the address book.
class AddressesScreen extends ConsumerWidget {
  final bool selectMode;

  const AddressesScreen({
    super.key,
    this.selectMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    final addresses = addressesAsync.maybeWhen(
      data: (list) => list,
      orElse: () => <AddressModel>[],
    );

    return Scaffold(
      backgroundColor: AppTokens.background,

      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTokens.textPrimary,
            size: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          selectMode ? 'Select address' : 'Delivery addresses',
          style:GoogleFonts.poppins(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppTokens.border,
          ),
        ),
      ),

      body: addressesAsync.when(
        loading: () {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppTokens.textSecondary,
                strokeWidth: 2,
              ),
            ),
          );
        },

        error: (error, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Failed to load addresses',
                    style: AppTokens.bodyStrong.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: AppTokens.s16),
                  OutlinedButton(
                    onPressed: () {
                      ref.invalidate(addressesProvider);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTokens.textPrimary,
                      side: const BorderSide(
                        color: AppTokens.borderStrong,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusButton,
                        ),
                      ),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        },

        data: (list) {
          if (list.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppTokens.gutter,
              AppTokens.s16,
              AppTokens.gutter,
              AppTokens.s24,
            ),
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppTokens.s12),
            itemBuilder: (context, index) {
              final address = list[index];

              return _AddressCard(
                address: address,
                selectMode: selectMode,
                onTap: () {
                  Navigator.pop(context, address);
                },
                onEdit: () {
                  _openForm(
                    context,
                    address: address,
                    isFirstAddress: false,
                  );
                },
                onDelete: () {
                  _confirmDelete(context, ref, address, list);
                },
                onSetDefault: () {
                  _setDefault(context, ref, address);
                },
              );
            },
          );
        },
      ),

      // ADD ADDRESS BUTTON
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTokens.background,
          border: Border(
            top: BorderSide(color: AppTokens.border),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTokens.gutter,
              AppTokens.s12,
              AppTokens.gutter,
              AppTokens.s12,
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                _openForm(
                  context,
                  isFirstAddress: addresses.isEmpty,
                );
              },
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text('Add new address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.accent,
                foregroundColor: AppTokens.onAccent,
                minimumSize: const Size.fromHeight(52),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTokens.radiusButton,
                  ),
                ),
                textStyle: AppTokens.button.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // EMPTY STATE
  // ----------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.border),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppTokens.textSecondary,
                size: 36,
              ),
            ),
            const SizedBox(height: AppTokens.s24),
            Text(
              'No saved addresses',
              style: AppTokens.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppTokens.s8),
            Text(
              'Add a delivery address to check out faster.',
              textAlign: TextAlign.center,
              style: AppTokens.body.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ACTIONS
  // ----------------------------------------------------------

  void _openForm(
    BuildContext context, {
    AddressModel? address,
    required bool isFirstAddress,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddressFormScreen(
          address: address,
          isFirstAddress: isFirstAddress,
        ),
      ),
    );
  }

  Future<void> _setDefault(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) async {
    try {
      await ref.read(addressRepositoryProvider).setDefault(address.id);

      ref.invalidate(addressesProvider);

      if (!context.mounted) return;

      _showMessage(context, 'Default address updated');
    } catch (e) {
      debugPrint('Set default address error: $e');

      if (!context.mounted) return;

      _showMessage(context, 'Could not update default address');
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
    List<AddressModel> allAddresses,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTokens.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusSheet),
            side: const BorderSide(color: AppTokens.border),
          ),
          title: Text(
            'Delete address?',
            style: AppTokens.headline.copyWith(fontSize: 22),
          ),
          content: Text(
            'This address will be removed from your account.',
            style: AppTokens.body.copyWith(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                'Cancel',
                style: AppTokens.button.copyWith(
                  fontSize: 15,
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                'Delete',
                style: AppTokens.button.copyWith(
                  fontSize: 15,
                  color: AppTokens.danger,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(addressRepositoryProvider);

      await repository.deleteAddress(address.id);

      // If the default address was deleted, promote the next one.
      if (address.isDefault) {
        final remaining =
            allAddresses.where((a) => a.id != address.id).toList();

        if (remaining.isNotEmpty) {
          await repository.setDefault(remaining.first.id);
        }
      }

      ref.invalidate(addressesProvider);

      if (!context.mounted) return;

      _showMessage(context, 'Address deleted');
    } catch (e) {
      debugPrint('Delete address error: $e');

      if (!context.mounted) return;

      _showMessage(context, 'Could not delete address');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          side: const BorderSide(color: AppTokens.borderStrong),
        ),
        content: Text(
          message,
          style: AppTokens.bodyStrong.copyWith(fontSize: 15),
        ),
      ),
    );
  }
}

// ================================================================
// ADDRESS CARD
// ================================================================

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool selectMode;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.selectMode,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  IconData get _labelIcon {
    switch (address.label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline_rounded;
      default:
        return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: selectMode ? onTap : null,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTokens.s16),
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            border: Border.all(
              color: address.isDefault
                  ? AppTokens.accent
                  : AppTokens.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LABEL + DEFAULT TAG
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.background,
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusSm,
                      ),
                      border: Border.all(color: AppTokens.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _labelIcon,
                          size: 16,
                          color: AppTokens.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          address.label,
                          style: AppTokens.bodyStrong.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (address.isDefault) ...[
                    const SizedBox(width: AppTokens.s8),
                    Text(
                      'Default',
                      style: AppTokens.bodyStrong.copyWith(
                        fontSize: 13,
                        color: AppTokens.accent,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppTokens.s12),

              // NAME + PHONE
              Text(
                address.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTokens.bodyStrong.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                address.phone,
                style: AppTokens.caption.copyWith(fontSize: 14),
              ),

              const SizedBox(height: AppTokens.s8),

              // ADDRESS
              Text(
                address.fullAddress,
                style: AppTokens.body.copyWith(fontSize: 14),
              ),

              const SizedBox(height: AppTokens.s12),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppTokens.border,
              ),

              const SizedBox(height: AppTokens.s4),

              // ACTIONS
              Row(
                children: [
                  _action(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppTokens.textSecondary,
                    onTap: onEdit,
                  ),
                  const SizedBox(width: AppTokens.s4),
                  _action(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete',
                    color: AppTokens.danger,
                    onTap: onDelete,
                  ),
                  const Spacer(),
                  if (!address.isDefault)
                    _action(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Set as default',
                      color: AppTokens.accent,
                      onTap: onSetDefault,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s8,
          vertical: AppTokens.s8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTokens.bodyStrong.copyWith(
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/models/profile/address_model.dart';
import 'package:shoppee_world/user/viewmodel/profile/address_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

/// Place at: lib/user/views/profile/address_form_screen.dart
///
/// Pass [address] to edit an existing one. [isFirstAddress] makes the new
/// address the default automatically.
class AddressFormScreen extends ConsumerStatefulWidget {
  final AddressModel? address;
  final bool isFirstAddress;

  const AddressFormScreen({
    super.key,
    this.address,
    this.isFirstAddress = false,
  });

  @override
  ConsumerState<AddressFormScreen> createState() =>
      _AddressFormScreenState();
}

class _AddressFormScreenState
    extends ConsumerState<AddressFormScreen> {
  static const List<String> _labels = ['Home', 'Work', 'Other'];

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  String _label = 'Home';
  bool _makeDefault = false;
  bool _isSaving = false;

  bool get _isEditing => widget.address != null;

  // The default address can't be switched off here: another address has
  // to be made the default instead.
  bool get _defaultLocked =>
      widget.isFirstAddress || (widget.address?.isDefault ?? false);

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    if (address != null) {
      _label = address.label;
      _nameController.text = address.fullName;
      _phoneController.text = address.phone;
      _pincodeController.text = address.pincode;
      _addressLineController.text = address.addressLine;
      _areaController.text = address.area;
      _landmarkController.text = address.landmark ?? '';
      _cityController.text = address.city;
      _stateController.text = address.state;
      _makeDefault = address.isDefault;
    } else {
      // Pre-fill name and phone from the account.
      final user = Supabase.instance.client.auth.currentUser;

      _nameController.text =
          user?.userMetadata?['name']?.toString() ?? '';
      _phoneController.text =
          user?.userMetadata?['phone']?.toString() ?? '';

      _makeDefault = widget.isFirstAddress;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _addressLineController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // SAVE
  // ----------------------------------------------------------

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(addressRepositoryProvider);

      final draft = AddressModel(
        id: widget.address?.id ?? '',
        label: _label,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        pincode: _pincodeController.text.trim(),
        addressLine: _addressLineController.text.trim(),
        area: _areaController.text.trim(),
        landmark: _landmarkController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        isDefault: false,
      );

      if (_isEditing) {
        await repository.updateAddress(draft);

        if (_makeDefault && !(widget.address!.isDefault)) {
          await repository.setDefault(widget.address!.id);
        }
      } else {
        final saved = await repository.addAddress(draft);

        if (_makeDefault) {
          await repository.setDefault(saved.id);
        }
      }

      if (!mounted) return;

      ref.invalidate(addressesProvider);

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Address save error: $e');

      if (!mounted) return;

      _showMessage('Failed to save address. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
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

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
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
          _isEditing ? 'Edit address' : 'Add address',
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

      body: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          AppTokens.gutter + 4,
          AppTokens.s24,
          AppTokens.gutter + 4,
          AppTokens.s32,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ADDRESS TYPE
              _fieldLabel('Save address as'),

              const SizedBox(height: AppTokens.s8),

              Row(
                children: _labels.map((label) {
                  final selected = _label == label;

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: AppTokens.s8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _label = label;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTokens.fill
                              : AppTokens.background,
                          borderRadius: BorderRadius.circular(
                            AppTokens.radiusMd,
                          ),
                          border: Border.all(
                            color: selected
                                ? AppTokens.fill
                                : AppTokens.border,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTokens.bodyStrong.copyWith(
                            fontSize: 15,
                            color: selected
                                ? AppTokens.onFill
                                : AppTokens.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppTokens.s24),

              _fieldLabel('Full name'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _nameController,
                hint: 'Name of the person receiving the order',
                capitalization: TextCapitalization.words,
                validator: (v) => _required(v, 'a name'),
              ),

              const SizedBox(height: AppTokens.s20),

              _fieldLabel('Phone number'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _phoneController,
                hint: '10-digit mobile number',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                digitsOnly: true,
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return 'Enter a phone number';
                  if (text.length != 10) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppTokens.s20),

              _fieldLabel('Pincode'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _pincodeController,
                hint: '6-digit pincode',
                keyboardType: TextInputType.number,
                maxLength: 6,
                digitsOnly: true,
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return 'Enter a pincode';
                  if (text.length != 6) {
                    return 'Enter a valid 6-digit pincode';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppTokens.s20),

              _fieldLabel('House / flat / building'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _addressLineController,
                hint: 'e.g. 12B, Green Park Apartments',
                capitalization: TextCapitalization.sentences,
                validator: (v) => _required(v, 'your house or building'),
              ),

              const SizedBox(height: AppTokens.s20),

              _fieldLabel('Street / area'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _areaController,
                hint: 'Street, area or locality',
                capitalization: TextCapitalization.sentences,
                validator: (v) => _required(v, 'your street or area'),
              ),

              const SizedBox(height: AppTokens.s20),

              _fieldLabel('Landmark (optional)'),
              const SizedBox(height: AppTokens.s8),
              _field(
                controller: _landmarkController,
                hint: 'e.g. Near the bus stand',
                capitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: AppTokens.s20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('City'),
                        const SizedBox(height: AppTokens.s8),
                        _field(
                          controller: _cityController,
                          hint: 'City',
                          capitalization: TextCapitalization.words,
                          validator: (v) => _required(v, 'a city'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTokens.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('State'),
                        const SizedBox(height: AppTokens.s8),
                        _field(
                          controller: _stateController,
                          hint: 'State',
                          capitalization: TextCapitalization.words,
                          action: TextInputAction.done,
                          validator: (v) => _required(v, 'a state'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTokens.s24),

              // DEFAULT TOGGLE
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _defaultLocked
                    ? null
                    : () {
                        setState(() {
                          _makeDefault = !_makeDefault;
                        });
                      },
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: _makeDefault
                            ? AppTokens.accent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _makeDefault
                              ? AppTokens.accent
                              : AppTokens.borderStrong,
                          width: 1.5,
                        ),
                      ),
                      child: _makeDefault
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: AppTokens.onAccent,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppTokens.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make this my default address',
                            style: AppTokens.bodyStrong.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          if (_defaultLocked)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                widget.isFirstAddress
                                    ? 'Your first address is the default.'
                                    : 'To change it, set another address as default.',
                                style: AppTokens.caption.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTokens.s32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.accent,
                    foregroundColor: AppTokens.onAccent,
                    disabledBackgroundColor:
                        AppTokens.accent.withValues(alpha: .5),
                    disabledForegroundColor: AppTokens.onAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusButton,
                      ),
                    ),
                    textStyle: AppTokens.button.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTokens.onAccent,
                          ),
                        )
                      : const Text('Save address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HELPERS
  // ----------------------------------------------------------

  String? _required(String? value, String what) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $what';
    }
    return null;
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppTokens.bodyStrong.copyWith(
        fontSize: 15,
        color: AppTokens.textSecondary,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    TextInputAction action = TextInputAction.next,
    int? maxLength,
    bool digitsOnly = false,
    String? Function(String?)? validator,
  }) {
    OutlineInputBorder outline(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      textInputAction: action,
      maxLength: maxLength,
      cursorColor: AppTokens.accent,
      validator: validator,
      inputFormatters: [
        if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
      ],
      style: AppTokens.bodyStrong.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        hintStyle: AppTokens.body.copyWith(
          fontSize: 15,
          color: AppTokens.textTertiary,
        ),
        errorStyle: AppTokens.caption.copyWith(
          fontSize: 13,
          color: AppTokens.danger,
        ),
        filled: true,
        fillColor: AppTokens.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: 18,
        ),
        border: outline(AppTokens.border),
        enabledBorder: outline(AppTokens.border),
        focusedBorder: outline(AppTokens.accent, 1.5),
        errorBorder: outline(AppTokens.danger),
        focusedErrorBorder: outline(AppTokens.danger, 1.5),
      ),
    );
  }
}
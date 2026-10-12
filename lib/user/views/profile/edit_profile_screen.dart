import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  // Storage bucket that holds profile photos.
  static const String _avatarBucket = 'avatars';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Read-only email field. Created once instead of on every rebuild.
  final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;

  // PROFILE PHOTO STATE
  // Newly picked photo (uploaded when the user taps Save).
  File? _pickedImage;

  // Photo already saved on the account.
  String _currentAvatarUrl = '';

  // True when the user chose "Remove photo".
  bool _removeAvatar = false;

  final _supabase = Supabase.instance.client;

  bool get _hasImage =>
      _pickedImage != null ||
      (!_removeAvatar && _currentAvatarUrl.isNotEmpty);

  @override
  void initState() {
    super.initState();

    final user = _supabase.auth.currentUser;

    _nameController.text =
        user?.userMetadata?['name']?.toString() ?? '';

    _phoneController.text =
        user?.userMetadata?['phone']?.toString() ?? '';

    _emailController.text = user?.email ?? '';

    _currentAvatarUrl =
        user?.userMetadata?['avatar_url']?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // PICK PHOTO
  // ----------------------------------------------------------

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _pickedImage = File(picked.path);
        _removeAvatar = false;
      });
    } catch (e) {
      debugPrint('Image pick error: $e');

      if (!mounted) return;

      _showMessage('Could not open the photo picker');
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTokens.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusSheet),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTokens.s8,
              0,
              AppTokens.s8,
              AppTokens.s8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Choose from gallery',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _sheetOption(
                  icon: Icons.photo_camera_outlined,
                  label: 'Take a photo',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_hasImage)
                  _sheetOption(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove photo',
                    color: AppTokens.danger,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        _pickedImage = null;
                        _removeAvatar = true;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppTokens.textPrimary,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        label,
        style: AppTokens.bodyStrong.copyWith(
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // UPLOAD PHOTO
  // ----------------------------------------------------------

  /// Uploads the picked photo and returns its public URL.
  Future<String> _uploadAvatar(File file) async {
    final userId = _supabase.auth.currentUser!.id;

    final path = '$userId/avatar.jpg';

    await _supabase.storage.from(_avatarBucket).upload(
          path,
          file,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final publicUrl =
        _supabase.storage.from(_avatarBucket).getPublicUrl(path);

    // The file name stays the same when a photo is replaced, so add a
    // timestamp to stop the old image being served from cache.
    return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
  }

  // ----------------------------------------------------------
  // SAVE
  // ----------------------------------------------------------

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your name');
      return;
    }

    if (phone.isEmpty) {
      _showMessage('Please enter your phone number');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? avatarUrl;

      if (_pickedImage != null) {
        avatarUrl = await _uploadAvatar(_pickedImage!);
      } else if (_removeAvatar) {
        avatarUrl = '';
      }

      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': name,
            'phone': phone,
            'avatar_url': ?avatarUrl,
          },
        ),
      );

      if (!mounted) return;

      _showMessage('Profile updated successfully');

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Profile update error: $e');

      if (!mounted) return;

      _showMessage(
        'Failed to update profile. Please try again.',
      );
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
  // AVATAR
  // ----------------------------------------------------------

  Widget _avatarPlaceholder() {
    return const Center(
      child: Icon(
        Icons.person_outline_rounded,
        color: AppTokens.textSecondary,
        size: 52,
      ),
    );
  }

  Widget _buildAvatar() {
    Widget content;

    if (_pickedImage != null) {
      content = Image.file(
        _pickedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (!_removeAvatar && _currentAvatarUrl.isNotEmpty) {
      content = Image.network(
        _currentAvatarUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _avatarPlaceholder();
        },
      );
    } else {
      content = _avatarPlaceholder();
    }

    return GestureDetector(
      onTap: _isSaving ? null : _showImageOptions,
      child: SizedBox(
        height: 112,
        width: 112,
        child: Stack(
          children: [
            Container(
              height: 112,
              width: 112,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.border),
              ),
              child: ClipOval(child: content),
            ),

            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppTokens.accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTokens.background,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppTokens.onAccent,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          'Edit profile',
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
        padding: const EdgeInsets.fromLTRB(
          AppTokens.gutter + 4,
          AppTokens.s24,
          AppTokens.gutter + 4,
          AppTokens.s32,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // PROFILE PHOTO
            Center(child: _buildAvatar()),

            const SizedBox(height: AppTokens.s8),

            Center(
              child: TextButton(
                onPressed: _isSaving ? null : _showImageOptions,
                child: Text(
                  _hasImage ? 'Change photo' : 'Add photo',
                  style: AppTokens.bodyStrong.copyWith(
                    fontSize: 15,
                    color: AppTokens.accent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            _label('Name'),

            const SizedBox(height: AppTokens.s8),

            _textField(
              controller: _nameController,
              hint: 'Enter your name',
              icon: Icons.person_outline,
            ),

            const SizedBox(height: AppTokens.s24),

            _label('Phone number'),

            const SizedBox(height: AppTokens.s8),

            _textField(
              controller: _phoneController,
              hint: 'Enter your phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: AppTokens.s24),

            _label('Email'),

            const SizedBox(height: AppTokens.s8),

            _textField(
              controller: _emailController,
              hint: 'Email',
              icon: Icons.email_outlined,
              enabled: false,
            ),

            const SizedBox(height: AppTokens.s32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.accent,
                  foregroundColor: AppTokens.onAccent,
                  disabledBackgroundColor:
                      AppTokens.accent.withValues(alpha: .5),
                  disabledForegroundColor:
                      AppTokens.onAccent,
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
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTokens.onAccent,
                        ),
                      )
                    : const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTokens.bodyStrong.copyWith(
        fontSize: 15,
        color: AppTokens.textSecondary,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    OutlineInputBorder outline(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      cursorColor: AppTokens.accent,
      style: AppTokens.bodyStrong.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: enabled
            ? AppTokens.textPrimary
            : AppTokens.textSecondary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTokens.body.copyWith(
          fontSize: 16,
          color: AppTokens.textTertiary,
        ),
        prefixIcon: Icon(
          icon,
          color: AppTokens.textSecondary,
          size: 22,
        ),
        suffixIcon: enabled
            ? null
            : const Icon(
                Icons.lock_outline_rounded,
                color: AppTokens.textTertiary,
                size: 20,
              ),
        filled: true,
        fillColor:
            enabled ? AppTokens.surface : AppTokens.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: 18,
        ),
        border: outline(AppTokens.border),
        enabledBorder: outline(AppTokens.border),
        focusedBorder: outline(AppTokens.accent, 1.5),
        disabledBorder: outline(AppTokens.border),
      ),
    );
  }
}
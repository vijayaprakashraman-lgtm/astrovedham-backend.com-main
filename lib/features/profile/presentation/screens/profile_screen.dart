import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/services/local_storage_service.dart';
import 'package:astrovedham/core/services/auth_service.dart';
import 'package:astrovedham/core/providers/auth_provider.dart';
import 'package:astrovedham/core/utils/phone_utils.dart';


import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final instance = LocalStorageService.instance;
    final name = instance.getName() ?? 'profile.default_name'.tr();
    final email = instance.getEmail();
    final mobile = instance.getMobile();
    final gender = instance.getGender();
    final imagePath = instance.getImagePath();

    final String subText = (email != null && email.isNotEmpty)
        ? email
        : (mobile != null && mobile.isNotEmpty
              ? mobile
              : 'profile.email_not_added'.tr());

    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(title: 'profile.title'.tr(), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _staggeredAnimation(
                index: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ProfileImagePicker(
                        imagePath: imagePath,
                        onEdit: _handleImageSelection,
                      ),
                      const SizedBox(width: 20),
                      ProfileIdentitySection(
                        name: name,
                        subText: subText,
                        onEdit: () => _showEditNameSheet(context, name),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _staggeredAnimation(
                index: 1,
                child: ProfileSection(
                  title: 'profile.personal_info'.tr(),
                  children: [
                    ProfileInfoRow(
                      icon: Icons.phone_android_rounded,
                      label: 'profile.phone'.tr(),
                      value: mobile ?? 'profile.mobile_not_added'.tr(),
                      onTap: (mobile == null || mobile.isEmpty) ? () => _showEditPhoneSheet(context, mobile) : null,
                    ),
                    const Divider(
                      height: 1,
                      indent: 70,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    ProfileInfoRow(
                      icon: Icons.wc_rounded,
                      label: 'forms.gender'.tr(),
                      value: _getLocalizedGender(gender),
                      onTap: (gender == null || gender.isEmpty) ? () => _showEditGenderSheet(context, gender) : null,
                    ),
                    const Divider(
                      height: 1,
                      indent: 70,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    ProfileInfoRow(
                      icon: Icons.email_rounded,
                      label: 'profile.email'.tr(),
                      value: email ?? 'profile.email_not_added'.tr(),
                      onTap: () => _showEditEmailSheet(context, email),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _staggeredAnimation(
                index: 2,
                child: ProfileSection(
                  title: 'settings.language'.tr(),
                  children: [
                    ProfileInfoRow(
                      icon: Icons.translate_rounded,
                      label: 'settings.language'.tr(),
                      value: context.locale.languageCode == 'ta'
                          ? 'தமிழ்'
                          : 'English',
                      onTap: () => _showLanguageSelector(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _staggeredAnimation(
                index: 3,
                child: ProfileSection(
                  title: 'profile.information'.tr(),
                  children: [
                    LegalInformationRow(
                      icon: Icons.shield_moon_rounded,
                      title: 'profile.privacy_policy'.tr(),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                    ),
                    const Divider(
                      height: 1,
                      indent: 70,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    LegalInformationRow(
                      icon: Icons.gavel_rounded,
                      title: 'profile.terms'.tr(),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.termsAndConditions,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 70,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    LegalInformationRow(
                      icon: Icons.help_outline_rounded,
                      title: 'profile.contact_us'.tr(),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.contactUs),
                    ),
                    const Divider(
                      height: 1,
                      indent: 70,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    LegalInformationRow(
                      icon: Icons.info_outline_rounded,
                      title: 'profile.about_app'.tr(),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.about),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Builder(
                builder: (context) {
                  final authProvider = context.watch<AuthProvider>();
                  if (authProvider.isAuthenticated) {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final auth = context.read<AuthProvider>();
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              'profile.logout_confirm_title'.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            content: Text(
                              'profile.logout_confirm_message'.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'common.cancel'.tr(),
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.alertRed,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'logout'.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          if (!mounted) return;
                          await auth.logout();
                          navigator.pushNamedAndRemoveUntil(
                            AppRoutes.login,
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: Text(
                        'logout'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.alertRed,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                    );
                  } else {
                    return ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      icon: const Icon(Icons.login_rounded, color: Colors.white),
                      label: Text(
                        'auth.login'.tr().toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedGender(String? gender) {
    if (gender == null) return 'profile.gender_not_added'.tr();
    switch (gender.toLowerCase()) {
      case 'male':
        return 'common.male'.tr();
      case 'female':
        return 'common.female'.tr();
      case 'other':
        return 'profile.other'.tr();
      default:
        return gender;
    }
  }

  Widget _staggeredAnimation({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Future<void> _handleImageSelection() async {
    final ImagePicker picker = ImagePicker();
    final imagePath = LocalStorageService.instance.getImagePath();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                (imagePath == null
                        ? 'profile.select_source'
                        : 'profile.change_profile_picture')
                    .tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 24),
              _buildPickerOption(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'profile.camera'.tr(),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(picker, ImageSource.camera);
                },
              ),
              _buildPickerOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'profile.gallery'.tr(),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(picker, ImageSource.gallery);
                },
              ),
              if (imagePath != null)
                _buildPickerOption(
                  context,
                  icon: Icons.delete_outline_rounded,
                  label: 'profile.remove_photo'.tr(),
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    LocalStorageService.instance.setImagePath(null).then((_) {
                      setState(() {});
                    });
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withAlpha((0.1 * 255).toInt())
              : AppColors.softLavender,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primaryPurple,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _pickImage(ImagePicker picker, ImageSource source) async {
    try {
      if (source == ImageSource.camera && !kIsWeb) {
        final status = await Permission.camera.request();
        if (status.isPermanentlyDenied) {
          _showPermissionDialog('profile.camera_permission_required'.tr());
          return;
        } else if (!status.isGranted) {
          return;
        }
      }

      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        await LocalStorageService.instance.setImagePath(image.path);
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('profile.permission_denied'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('profile.open_settings'.tr()),
          ),
        ],
      ),
    );
  }

  void _showEditNameSheet(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.enter_name'.tr(),
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'forms.full_name_hint'.tr(),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final newName = controller.text.trim();
                          if (newName.isNotEmpty) {
                            setSheetState(() => isSaving = true);
                            try {
                              final email = LocalStorageService.instance.getEmail() ?? '';
                              await AuthService.instance.updateProfile(
                                name: newName,
                                email: email,
                              );
                              if (mounted) {
                                Navigator.pop(context);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('profile.update_success'.tr()),
                                    backgroundColor: AppColors.successGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              setSheetState(() => isSaving = false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString().replaceAll('Exception: ', '')),
                                    backgroundColor: AppColors.alertRed,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'profile.save'.tr().toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'profile.cancel'.tr(),
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPhoneSheet(BuildContext context, String? currentMobile) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: currentMobile);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile.phone'.tr(),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'forms.mobile_hint'.tr(),
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                    ),
                    validator: (value) {
                      return validatePhone(value);
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              setBottomSheetState(() => isSaving = true);
                              try {
                                final rawMobile = controller.text.trim();
                                final normalized = normalizePhone(rawMobile);
                                await AuthService.instance.updatePhone(normalized);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('profile.update_success'.tr()),
                                      backgroundColor: AppColors.successGreen,
                                    ),
                                  );
                                }
                              } catch (e) {
                                setBottomSheetState(() => isSaving = false);
                                if (context.mounted) {
                                  String errMessage = e.toString().replaceAll('Exception: ', '').trim();
                                  if (errMessage.contains('already associated') || errMessage.contains('already exists')) {
                                    errMessage = 'This mobile number is already associated with another account.';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errMessage),
                                      backgroundColor: AppColors.alertRed,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'profile.save'.tr().toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'profile.cancel'.tr(),
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditEmailSheet(BuildContext context, String? currentEmail) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: currentEmail);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile.edit_email'.tr(),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'forms.email_hint'.tr(),
                      prefixIcon: const Icon(Icons.email_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'profile.invalid_email'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final newEmail = controller.text.trim();
                              setSheetState(() => isSaving = true);
                              try {
                                final name = LocalStorageService.instance.getName() ?? '';
                                await AuthService.instance.updateProfile(
                                  name: name,
                                  email: newEmail,
                                );
                                if (mounted) {
                                  Navigator.pop(context);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('profile.update_success'.tr()),
                                      backgroundColor: AppColors.successGreen,
                                    ),
                                  );
                                }
                              } catch (e) {
                                setSheetState(() => isSaving = false);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString().replaceAll('Exception: ', '')),
                                      backgroundColor: AppColors.alertRed,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'profile.save'.tr().toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'profile.cancel'.tr(),
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditGenderSheet(BuildContext context, String? currentGender) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile.select_gender'.tr(),
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            _buildGenderOption('Male', currentGender),
            _buildGenderOption('Female', currentGender),
            _buildGenderOption('Other', currentGender),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, String? current) {
    final isSelected = gender.toLowerCase() == current?.toLowerCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.softLavender : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryPurple : AppColors.border,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Icon(
          gender == 'Male'
              ? Icons.male_rounded
              : (gender == 'Female' ? Icons.female_rounded : Icons.wc_rounded),
          color: isSelected ? AppColors.primaryPurple : AppColors.hintText,
        ),
        title: Text(
          _getLocalizedGender(gender),
          style: TextStyle(
            color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryPurple,
              )
            : null,
        onTap: () async {
          final navigator = Navigator.of(context);
          await LocalStorageService.instance.setGender(gender);
          if (mounted) {
            navigator.pop();
            setState(() {});
          }
        },
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'settings.language'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 24),
              _buildLanguageOption(context, 'English', const Locale('en')),
              const SizedBox(height: 12),
              _buildLanguageOption(context, 'தமிழ்', const Locale('ta')),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    Locale locale,
  ) {
    final isSelected = context.locale == locale;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () async {
          final navigator = Navigator.of(context);
          await context.setLocale(locale);
          if (mounted) {
            navigator.pop();
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.softLavender : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primaryPurple : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : AppColors.primaryText,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

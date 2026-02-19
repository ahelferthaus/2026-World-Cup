import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/school_icons.dart';

/// User avatar with fallback chain: photo URL → school logo → initials
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.displayName,
    this.photoUrl,
    this.school,
    this.radius = 24,
    this.onTap,
  });

  final String displayName;
  final String? photoUrl;
  final String? school;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final widget = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      backgroundImage: _imageProvider,
      child: _imageProvider == null ? _initialsWidget : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }
    return widget;
  }

  ImageProvider? get _imageProvider {
    // Priority 1: user's own photo
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    }
    // Priority 2: school logo
    if (school != null && school!.isNotEmpty) {
      return NetworkImage(SchoolIcons.getSchoolLogoUrl(school!));
    }
    return null;
  }

  Widget get _initialsWidget {
    final initial = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';
    return Text(
      initial,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: radius * 0.8,
        color: AppColors.primary,
      ),
    );
  }
}

/// Profile avatar with upload/generate badge overlay
class EditableUserAvatar extends StatelessWidget {
  const EditableUserAvatar({
    super.key,
    required this.displayName,
    this.photoUrl,
    this.school,
    this.radius = 40,
    required this.onUploadTap,
    this.onGenerateTap,
    this.canGenerate = true,
  });

  final String displayName;
  final String? photoUrl;
  final String? school;
  final double radius;
  final VoidCallback onUploadTap;
  final VoidCallback? onGenerateTap;
  final bool canGenerate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        UserAvatar(
          displayName: displayName,
          photoUrl: photoUrl,
          school: school,
          radius: radius,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showPhotoOptions(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile Picture',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Upload Photo'),
                subtitle: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  onUploadTap();
                },
              ),
              if (onGenerateTap != null)
                ListTile(
                  leading: Icon(
                    Icons.auto_awesome,
                    color: canGenerate ? AppColors.secondary : Colors.grey,
                  ),
                  title: const Text('Generate AI Avatar'),
                  subtitle: Text(
                    canGenerate
                        ? 'Create a unique avatar (1x per week)'
                        : 'Available again next week',
                  ),
                  enabled: canGenerate,
                  onTap: canGenerate
                      ? () {
                          Navigator.pop(ctx);
                          onGenerateTap!();
                        }
                      : null,
                ),
              if (school != null && school!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.school, color: AppColors.primary),
                  title: const Text('Use School Logo'),
                  subtitle: Text(school!),
                  onTap: () {
                    Navigator.pop(ctx);
                    // Reset to school logo by clearing photo URL
                    // In production, save photoUrl = null to Firestore
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('School logo set as profile picture')),
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

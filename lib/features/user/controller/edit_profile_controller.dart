import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController with ChangeNotifier {
  final nameController = TextEditingController();
  final gradeController = TextEditingController();

  bool isSaving = false;
  String imageUrl = '';
  File? uImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      uImage = File(pickedFile.path);
      notifyListeners();

      final uploadedUrl = await _uploadImageToSupabase(uImage!);
      if (uploadedUrl != null) {
        await _updateUserPhotoUrl(uploadedUrl);
        imageUrl = uploadedUrl;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Photo updated successfully")),
        );
      }
    } catch (e) {
      log("Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking/uploading image: $e")),
      );
    }
  }

  Future<String?> _uploadImageToSupabase(File image) async {
    try {
      final userId = SupabaseHelper.getCurrentUserId();
      if (userId == null) return null;

      final fileName =
          '$userId-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}.jpg';
      final bytes = await image.readAsBytes();

      await SupabaseHelper.client.storage
          .from('user-profile')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      return SupabaseHelper.client.storage
          .from('user-profile')
          .getPublicUrl(fileName);
    } catch (e) {
      log("Upload failed: $e");
      return null;
    }
  }

  Future<void> _updateUserPhotoUrl(String url) async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    await SupabaseHelper.client
        .from('users')
        .update({'user_photo': url})
        .eq('id', userId);
  }

  Future<void> resetProfilePhoto(BuildContext context) async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    await SupabaseHelper.client
        .from('users')
        .update({'user_photo': null})
        .eq('id', userId);

    imageUrl = '';
    uImage = null;
    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile photo reset")));
  }

  Future<void> loadInitialData() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final user =
        await SupabaseHelper.client
            .from('users')
            .select('full_name, grade, user_photo')
            .eq('id', userId)
            .maybeSingle();

    if (user != null) {
      nameController.text = user['full_name'] ?? '';
      gradeController.text = user['grade'] ?? '';
      imageUrl = user['user_photo'] ?? '';
    }

    notifyListeners();
  }

  Future<void> saveChanges(BuildContext context) async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    try {
      isSaving = true;
      notifyListeners();

      await SupabaseHelper.client
          .from('users')
          .update({
            'full_name': nameController.text.trim(),
            'grade': gradeController.text.trim(),
          })
          .eq('id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    gradeController.dispose();
    super.dispose();
  }
}

import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/user/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController()..loadInitialData(),
      child: const _EditProfileForm(),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<EditProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body:
          ctrl.isSaving
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (_) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text("Change Photo"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ctrl.pickImage(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.restore),
                                      title: const Text("Reset to Default"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ctrl.resetProfilePhoto(context);
                                      },
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              ctrl.uImage != null
                                  ? FileImage(ctrl.uImage!)
                                  : (ctrl.imageUrl.isNotEmpty
                                          ? NetworkImage(ctrl.imageUrl)
                                          : null)
                                      as ImageProvider?,
                          child:
                              ctrl.uImage == null && ctrl.imageUrl.isEmpty
                                  ? Text(
                                    SupabaseHelper.getInitials(
                                      ctrl.nameController.text,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: ctrl.nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: ctrl.gradeController,
                      decoration: const InputDecoration(
                        labelText: "Grade",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () => ctrl.saveChanges(context),
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
    );
  }
}

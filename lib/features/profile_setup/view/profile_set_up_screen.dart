import 'package:aurio/features/profile_setup/controller/profile_setup_controller.dart';
import 'package:aurio/shared/widgets/reuable_header.dart';
import 'package:aurio/shared/widgets/reusable_button.dart';
import 'package:aurio/shared/widgets/reusable_text_form_field.dart';
import 'package:aurio/features/bottom_navbar/view/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSetUpScreen extends StatefulWidget {
  const ProfileSetUpScreen({super.key});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  String _selectedDifficulty = 'Easy';

  @override
  Widget build(BuildContext context) {
    final profileCtrl = context.watch<ProfileSetupController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            ReusableHeader(textContent: "Set Up Your Profile"),
            const SizedBox(height: 24),
            Text("Add your subjects"),
            const SizedBox(height: 10),

            /// Subject input + dropdown + add
            Row(
              children: [
                Expanded(
                  child: ReusableTextFormField(
                    labelText: "Type a subject",
                    controller: profileCtrl.subjectController,
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedDifficulty,
                  items:
                      ["Easy", "Medium", "Hard"].map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final subject = profileCtrl.subjectController.text.trim();
                    if (subject.isNotEmpty) {
                      profileCtrl.addSubject(subject, _selectedDifficulty);
                      profileCtrl.subjectController.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Subject list with delete + difficulty
            if (profileCtrl.subjects.isNotEmpty)
              Column(
                children: List.generate(profileCtrl.subjects.length, (index) {
                  final subject = profileCtrl.subjects[index];
                  return Card(
                    child: ListTile(
                      title: Text(subject['subject']!),
                      subtitle: Text("Difficulty: ${subject['difficulty']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          profileCtrl.removeSubject(index);
                        },
                      ),
                    ),
                  );
                }),
              ),

            const SizedBox(height: 20),

            Text("Daily study hours"),
            Slider(
              value: profileCtrl.dailyHours,
              min: 0,
              max: 12,
              divisions: 12,
              label: "${profileCtrl.dailyHours.round()}h",
              onChanged: (value) => profileCtrl.updateHours(value),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("0h"), Text("12h")],
            ),

            const SizedBox(height: 20),
            ReusableButton(
              btnText: "Save and generate plan",
              onValidSubmit: () async {
                final error = await profileCtrl.saveToSupabase();
                if (error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                  return;
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const BottomNavbar()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

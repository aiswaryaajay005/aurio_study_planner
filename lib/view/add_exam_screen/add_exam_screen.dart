import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController subjectController = TextEditingController();
  DateTime? selectedDate;

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Add Exam")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: "Subject Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                selectedDate != null
                    ? "Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}"
                    : "Choose Exam Date",
                style: TextStyle(color: ColorConstants.textColor),
              ),
              trailing: Icon(
                Icons.calendar_today,
                color: ColorConstants.accentColor,
              ),
              onTap: () => pickDate(context),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Save to Supabase (exams table)
                Navigator.pop(context);
              },
              child: const Text("Save Exam"),
            ),
          ],
        ),
      ),
    );
  }
}

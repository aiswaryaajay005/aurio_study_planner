import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class SubmitFeedbackScreen extends StatefulWidget {
  const SubmitFeedbackScreen({super.key});

  @override
  State<SubmitFeedbackScreen> createState() => _SubmitFeedbackScreenState();
}

class _SubmitFeedbackScreenState extends State<SubmitFeedbackScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = "Bug";

  void _submitFeedback() {
    final String message = _messageController.text.trim();
    final String type = _selectedType;

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback.")),
      );
      return;
    }

    // TODO: Send feedback to Supabase database here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Feedback Submitted Successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Submit Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: "Select Feedback Type",
                border: OutlineInputBorder(),
              ),
              items:
                  ["Bug", "Suggestion", "General"].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Enter your feedback",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _submitFeedback,
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

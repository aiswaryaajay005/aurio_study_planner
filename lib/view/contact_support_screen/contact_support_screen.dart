import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supportMethods = ["Email", "WhatsApp", "Facebook", "Telegram"];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Contact Support")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: supportMethods.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(supportMethods[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Placeholder for linking support
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supportMethods = [
      {
        "label": "Email",
        "value": "support@aurio.app",
        "icon": Icons.email,
        "action": "mailto:support@aurio.app",
      },
      {
        "label": "WhatsApp",
        "value": "+91 98765 43210",
        "icon": Icons.message_rounded,
        "action": "https://wa.me/919876543210",
      },
      {
        "label": "Telegram",
        "value": "@AurioSupportBot",
        "icon": Icons.send,
        "action": "https://t.me/AurioSupportBot",
      },
      {
        "label": "Facebook",
        "value": "facebook.com/aurioapp",
        "icon": Icons.facebook,
        "action": "https://facebook.com/aurioapp",
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Contact Support")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: supportMethods.length,
        itemBuilder: (context, index) {
          final item = supportMethods[index];
          return Card(
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData?,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(item['label'] as String),
              subtitle: Text(item['value'].toString()),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final url = Uri.parse(item['action'].toString() ?? '');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

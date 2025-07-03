import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceLinksScreen extends StatelessWidget {
  const ResourceLinksScreen({super.key});

  final List<Map<String, String>> resources = const [
    {"title": "Khan Academy", "url": "https://www.khanacademy.org/"},
    {"title": "GeeksforGeeks", "url": "https://www.geeksforgeeks.org/"},
    {"title": "Coursera", "url": "https://www.coursera.org/"},
    {
      "title": "YouTube Study Playlists",
      "url": "https://www.youtube.com/results?search_query=study+playlist",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Helpful Resources")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final item = resources[index];
          return Card(
            child: ListTile(
              title: Text(item['title']!),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => launchUrl(Uri.parse(item['url']!)),
            ),
          );
        },
      ),
    );
  }
}

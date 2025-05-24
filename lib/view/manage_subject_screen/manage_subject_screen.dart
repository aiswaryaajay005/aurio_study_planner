import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class ManageSubjectsScreen extends StatelessWidget {
  const ManageSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = ["Math", "Physics", "Chemistry"];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Manage Subjects")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              subjects[index],
              style: TextStyle(color: ColorConstants.textColor),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Subject"),
                content: TextField(
                  decoration: const InputDecoration(hintText: "Subject Name"),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Add subject logic here
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/global_widgets/reuable_header.dart';
import 'package:aurio/global_widgets/reusable_button.dart';
import 'package:aurio/global_widgets/reusable_text_form_field.dart';
import 'package:aurio/view/bottom_navbar/bottom_navbar.dart';
import 'package:aurio/view/home_screen/home_screen.dart';
import 'package:aurio/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileSetUpScreen extends StatefulWidget {
  const ProfileSetUpScreen({super.key});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  double hourScale = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(height: 100),
              ReusableHeader(textContent: "Set Up Your Profile"),
              SizedBox(height: 24),
              Text(
                "Add your subjects",
                style: TextStyle(
                  color: ColorConstants.accentColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ReusableTextFormField(labelText: "Type a subject"),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.add, color: ColorConstants.accentColor),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Choose the diifficulty level",
                style: TextStyle(
                  color: ColorConstants.accentColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Column(
                spacing: 5,
                children: List.generate(
                  3,
                  (index) => Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 50,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorConstants.primaryColor,
                          ),
                          child: Row(
                            children: [
                              Text("Maths"),
                              Spacer(),
                              Icon(
                                Icons.delete,
                                color: ColorConstants.accentColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: "Easy",
                              child: Text("Easy"),
                            ),
                            DropdownMenuItem(
                              value: "Medium",
                              child: Text("Medium"),
                            ),
                            DropdownMenuItem(
                              value: "Hard",
                              child: Text("Hard"),
                            ),
                          ],
                          onChanged: (value) {
                            // handle dropdown change
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text("Daily study hours"),
              SizedBox(height: 20),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: ColorConstants.primaryColor,
                  inactiveTrackColor: Colors.purple.withOpacity(0.2),
                  trackHeight: 2.5,
                  thumbColor: ColorConstants.primaryColor,
                  overlayColor: ColorConstants.accentColor,
                  valueIndicatorColor: Colors.purple,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8.0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16.0,
                  ),
                ),
                child: Slider(
                  value: hourScale,
                  min: 0,
                  max: 12,
                  divisions: 12,
                  label: "${hourScale.round()}h",
                  onChanged: (value) {
                    setState(() {
                      hourScale = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0h", style: TextStyle(color: ColorConstants.textColor)),
                  Text(
                    "12h",
                    style: TextStyle(color: ColorConstants.textColor),
                  ),
                ],
              ),
              ReusableButton(
                btnText: "Save and generate plan",
                onValidSubmit:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavbar()),
                      (route) => false,
                    ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

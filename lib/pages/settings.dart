import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {  

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool darkMode = false;

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ), 
        body: Material(
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'Common',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onTap: () {},
                  ),
                  SettingsTile.switchTile(
                    title: 'Dark Mode',
                    leading: Icon(Icons.lightbulb_outline),
                    switchValue: darkMode,
                    onToggle: (bool darkMode) {}
                  ),
                ],
              ),
              SettingsSection(
                title: 'Account Security',
                tiles: [
                  SettingsTile(
                    title: 'Change Email',
                    leading: Icon(Icons.email),
                    onTap: () {},
                  ),
                  SettingsTile(
                    title: 'Change Password',
                    leading: Icon(Icons.lock),
                    onTap: () {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                tiles: [
                  SettingsTile(
                    title: 'Terms of Service',
                    leading: Icon(Icons.email),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
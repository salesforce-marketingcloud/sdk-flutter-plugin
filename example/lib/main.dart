import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sfmc/sfmc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _systemToken = 'Not available';
  String _deviceId = 'Not available';
  String _pushStatus = 'Not available';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String systemToken;
    try {
      systemToken = await SFMCSdk.getSystemToken() ?? 'Not Available';
    } on PlatformException {
      systemToken = 'Failed to get system token.';
    }

    String deviceId;
    try {
      deviceId = await SFMCSdk.getDeviceId() ?? 'Not Available';
    } on PlatformException {
      deviceId = 'Failed to get device ID.';
    }

    String pushStatus;
    try {
      pushStatus = await SFMCSdk.isPushEnabled() == true
          ? "Push is Enabled"
          : "Push is Disabled";
    } on PlatformException {
      pushStatus = 'Failed to get Push Status.';
    }

    if (!mounted) return;

    setState(() {
      _systemToken = systemToken;
      _deviceId = deviceId;
      _pushStatus = pushStatus;
    });
  }

  void _showToast(String message) {
    // Implement your toast display logic here.
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(56, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SFMC Flutter SDK Example'),
          backgroundColor: const Color.fromARGB(255, 2, 172, 240),
        ),
        body: Container(
          color: const Color(0xFFF8F8F8), // Set background color for ListView
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: <Widget>[
              buildCard(
                "System Token",
                "Get the system token from the SFMC SDK using SFMCSdk.getSystemToken().",
                () {
                  initPlatformState();
                  _showToast("System Token Updated");
                },
                'GET SYSTEM TOKEN',
                content: _systemToken,
              ),
              buildCard(
                "Device ID",
                "Get the device ID from the SFMC SDK using SFMCSdk.getDeviceId().",
                () {
                  initPlatformState();
                  _showToast("Device ID Updated");
                },
                'GET DEVICE ID',
                content: _deviceId,
              ),
              buildCard(
                "Check Push Status",
                "Check if push notifications are enabled or disabled using SFMCSdk.isPushEnabled().",
                () {
                  initPlatformState();
                  _showToast("Push Status Updated");
                },
                'UPDATE PUSH STATUS',
                content: _pushStatus,
              ),
              buildCard(
                "Enable Push",
                "Enable push notifications using SFMCSdk.enablePush().",
                () {
                  SFMCSdk.enablePush();
                  _showToast("Push Enabled");
                },
                'ENABLE PUSH',
              ),
              buildCard(
                "Disable Push",
                "Disable push notifications using SFMCSdk.disablePush().",
                () {
                  SFMCSdk.disablePush();
                  _showToast("Push Disabled");
                },
                'DISABLE PUSH',
              ),
              buildCard(
                "Enable Logging",
                "Enable logging for the SFMC SDK using SFMCSdk.enableLogging().",
                () {
                  SFMCSdk.enableLogging();
                  _showToast("Logging Enabled");
                },
                'ENABLE LOGGING',
              ),
              buildCard(
                "Disable Logging",
                "Disable logging for the SFMC SDK using SFMCSdk.disableLogging().",
                () {
                  SFMCSdk.disableLogging();
                  _showToast("Logging Disabled");
                },
                'DISABLE LOGGING',
              ),
              buildCard(
                "Log SDK State",
                "Log the state of the SFMC SDK using SFMCSdk.logSdkState().",
                () {
                  SFMCSdk.logSdkState();
                  _showToast("SDK state logged.");
                },
                'LOG SDK STATE',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardWithInput(String title, String description,
      Function buttonAction, String buttonText,
      {bool isTwoInputs = false}) {
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    return Card(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Text(description,
                        style: const TextStyle(color: Colors.black54))),
                TextFormField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: 'Enter value',
                  ),
                ),
                if (isTwoInputs)
                  TextFormField(
                    controller: controller2,
                    decoration: const InputDecoration(
                      labelText: 'Enter second value',
                    ),
                  ),
                const SizedBox(height: 20),
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if (isTwoInputs) {
                      buttonAction(controller1.text, controller2.text);
                    } else {
                      buttonAction(controller1.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // Set the desired background color here(0,158,219)
                    backgroundColor: const Color.fromARGB(255, 2, 172,
                        240), // Change this color to your desired color
                  ),
                  child: Text(buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            )));
  }

  Widget buildCard(String title, String description, VoidCallback buttonAction,
      String buttonText,
      {String content = ''}) {
    return Card(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Text(description,
                        style: const TextStyle(color: Colors.black54))),
                if (content.isNotEmpty)
                  SelectableText(
                    content,
                    style: const TextStyle(color: Colors.black),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: buttonAction,
                    style: ElevatedButton.styleFrom(
                      // Set the desired background color here(0,158,219)
                      backgroundColor: const Color.fromARGB(255, 2, 172,
                          240), // Change this color to your desired color
                    ),
                    child: Text(buttonText,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )));
  }
}

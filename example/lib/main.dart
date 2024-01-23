// main.dart
//
// Copyright (c) 2024 Salesforce, Inc
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the nor the names of
// its contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
  String _attributes = "Not aviailable";
  List<String> _tags = [];
  String _contactKey = 'Not available';
  bool _analyticsEnabled = false;
  bool _piAnalyticsEnabled = false;

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

    String attributes = "Not available";
    try {
      var response = await SFMCSdk.getAttributes();
      if (response != null) {
        attributes = jsonEncode(response);
      }
    } on PlatformException {
      attributes = "Error getting attributes.";
    }

    List<String> tags;
    try {
      tags = (await SFMCSdk.getTags())?.cast<String>() ?? [];
    } on PlatformException {
      tags = [];
    }

    String contactKey;
    try {
      contactKey = await SFMCSdk.getContactKey() ?? 'Not Available';
    } on PlatformException {
      contactKey = 'Failed to get contact key.';
    }

    try {
      _analyticsEnabled = await SFMCSdk.isAnalyticsEnabled() ?? false;
      _piAnalyticsEnabled = await SFMCSdk.isPiAnalyticsEnabled() ?? false;
    } on PlatformException {
      // Handle exceptions or set default values
      _analyticsEnabled = false;
      _piAnalyticsEnabled = false;
    }

    if (!mounted) return;

    setState(() {
      _systemToken = systemToken;
      _deviceId = deviceId;
      _pushStatus = pushStatus;
      _attributes = attributes;
      _tags = tags;
      _contactKey = contactKey;
    });
  }

  void _onSetAttributesClicked(String key, String value) async {
    try {
      await SFMCSdk.setAttribute(key, value);
      _showToast('Attribute set successfully!');
      initPlatformState();
    } catch (e) {
      _showToast('Error setting attribute.');
    }
  }

  void _onClarAttributesClicked(String key) async {
    try {
      await SFMCSdk.clearAttribute(key);
      _showToast('Attribute cleared successfully!');
      initPlatformState();
    } catch (e) {
      _showToast('Error removing attribute.');
    }
  }

  void _onSetTagsClicked(tag) async {
    try {
      await SFMCSdk.addTag(tag);
      _showToast('Tags set successfully!');
      initPlatformState();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error setting tags.');
    }
  }

  void _onRemoveTagsClicked(tag) async {
    try {
      await SFMCSdk.removeTag(tag);
      _showToast('Tag removed successfully!');
      initPlatformState();
    } catch (e) {
      _showToast('Error setting tags.');
    }
  }

  void _onSetContactKeyClicked(value) async {
    try {
      await SFMCSdk.setContactKey(value);
      _showToast('Contact key is set.');
      initPlatformState();
    } catch (e) {
      _showToast('Error setting contact key.');
    }
  }

  void _trackCustomEvent() async {
    try {
      var customEvent = CustomEvent('CustomEventName',
          attributes: {'key1': 'trackCustomEvent'});
      await SFMCSdk.trackEvent(customEvent);
      _showToast("Event tracked successfully");
    } catch (e) {
      _showToast('Error tracking event.');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(249, 0, 0, 0),
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
                () async {
                  await initPlatformState();
                  _showToast("System Token Updated");
                },
                'GET SYSTEM TOKEN',
                content: _systemToken,
              ),
              buildCard(
                "Device ID",
                "Get the device ID from the SFMC SDK using SFMCSdk.getDeviceId().",
                () async {
                  await initPlatformState();
                  _showToast("Device ID Updated");
                },
                'GET DEVICE ID',
                content: _deviceId,
              ),
              buildCard(
                "Check Push Status",
                "Check if push notifications are enabled or disabled using SFMCSdk.isPushEnabled().",
                () async {
                  await initPlatformState();
                  _showToast("Push Status Updated");
                },
                'UPDATE PUSH STATUS',
                content: _pushStatus,
              ),
              buildCard(
                "Enable Push",
                "Enable push notifications using SFMCSdk.enablePush().",
                () async {
                  await SFMCSdk.enablePush();
                  _showToast("Push Enabled");
                },
                'ENABLE PUSH',
              ),
              buildCard(
                "Disable Push",
                "Disable push notifications using SFMCSdk.disablePush().",
                () async {
                  await SFMCSdk.disablePush();
                  _showToast("Push Disabled");
                },
                'DISABLE PUSH',
              ),
              buildCard(
                "Get Contact Key",
                "Get the contact key from the SFMC SDK using SFMCSdk.getContactKey().",
                () async {
                  await initPlatformState();
                  _showToast("Contact Key Updated");
                },
                'GET CONTACT KEY',
                content: _contactKey,
              ),
              buildCardWithInput(
                "Set Contact Key",
                "Set the contact key for the SFMC SDK using SFMCSdk.setContactKey(key).",
                _onSetContactKeyClicked,
                'SET CONTACT KEY',
              ),
              buildCard(
                "Get Tags",
                "Get tags from the SFMC SDK using SFMCSdk.getTags().",
                () async {
                  await initPlatformState();
                  _showToast("Tags Updated");
                },
                'GET TAGS',
                content: _tags.isNotEmpty ? _tags.join(', ') : 'No tags found.',
              ),
              buildCardWithInput(
                "Add Tag",
                "Add a tag to the SFMC SDK using SFMCSdk.addTag(tag).",
                _onSetTagsClicked,
                'ADD TAG',
              ),
              buildCardWithInput(
                "Remove Tag",
                "Remove a tag from the SFMC SDK using SFMCSdk.removeTag(tag).",
                _onRemoveTagsClicked,
                'REMOVE TAG',
              ),
              buildCard(
                "Get Attributes",
                "Get attributes from the SFMC SDK using SFMCSdk.getAttributes().",
                () async {
                  await initPlatformState();
                  _showToast("Attributes Updated");
                },
                'GET ATTRIBUTES',
                content: _attributes.isNotEmpty
                    ? _attributes
                    : 'No attributes found.',
              ),
              buildCardWithInput(
                "Set Attribute",
                "Set an attribute for the SFMC SDK using SFMCSdk.setAttribute(key, value).",
                _onSetAttributesClicked,
                'SET ATTRIBUTE',
                isTwoInputs: true,
              ),
              buildCardWithInput(
                "Clear Attribute",
                "Clear an attribute from the SFMC SDK using SFMCSdk.clearAttribute(key).",
                _onClarAttributesClicked,
                'CLEAR ATTRIBUTE',
              ),
              buildCard(
                "Enable Logging",
                "Enable logging for the SFMC SDK using SFMCSdk.enableLogging().",
                () async {
                  await SFMCSdk.enableLogging();
                  _showToast("Logging Enabled");
                },
                'ENABLE LOGGING',
              ),
              buildCard(
                "Disable Logging",
                "Disable logging for the SFMC SDK using SFMCSdk.disableLogging().",
                () async {
                  await SFMCSdk.disableLogging();
                  _showToast("Logging Disabled");
                },
                'DISABLE LOGGING',
              ),
              buildCard(
                "Log SDK State",
                "Log the state of the SFMC SDK using SFMCSdk.logSdkState().",
                () async {
                  await SFMCSdk.logSdkState();
                  _showToast("SDK state logged.");
                },
                'LOG SDK STATE',
              ),
              buildCard(
                "Track Custom Event",
                "Track custom event using SFMCSdk.trackEvent(event).",
                _trackCustomEvent,
                'TRACK EVENT',
              ),
              buildToggleCard(
                "Analytics Enabled",
                "Enable/Disable analytics using SFMCSdk.setAnalyticsEnabled().",
                _analyticsEnabled,
                (bool value) async {
                  await SFMCSdk.setAnalyticsEnabled(value);
                  setState(() {
                    _analyticsEnabled = value;
                  });
                },
              ),
              buildToggleCard(
                "PI Analytics Enabled",
                "Enable/Disable PI analytics using SFMCSdk.setPiAnalyticsEnabled().",
                _piAnalyticsEnabled,
                (bool value) async {
                  await SFMCSdk.setPiAnalyticsEnabled(value);
                  setState(() {
                    _piAnalyticsEnabled = value;
                  });
                },
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
                    labelText: 'Enter key',
                  ),
                ),
                if (isTwoInputs)
                  TextFormField(
                    controller: controller2,
                    decoration: const InputDecoration(
                      labelText: 'Enter value',
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

  Widget buildToggleCard(String title, String description, bool currentValue,
      ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                description,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black),
                ),
                Switch(
                  value: currentValue,
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

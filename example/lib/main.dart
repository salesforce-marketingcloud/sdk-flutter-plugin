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
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'messages_page.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
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
  List<InboxMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _updateAnalyticsToggle();
    if (kDebugMode) {
      SFMCSdk.enableLogging();
    }
  }

  Future<void> _fetchSystemToken() async {
    try {
      final String systemToken =
          await SFMCSdk.getSystemToken() ?? 'Not Available';
      setState(() {
        _systemToken = systemToken;
      });
      _showToast("System Token Fetched");
    } catch (e) {
      _logException(e);
      _showToast('Failed to get system token.');
    }
  }

  Future<void> _fetchDeviceId() async {
    try {
      final String deviceId = await SFMCSdk.getDeviceId() ?? 'Not Available';
      setState(() {
        _deviceId = deviceId;
      });
      _showToast("Device ID Fetched");
    } catch (e) {
      _logException(e);
      _showToast('Failed to get Device Id.');
    }
  }

  Future<void> _updatePushStatus() async {
    try {
      final String pushStatus = await SFMCSdk.isPushEnabled() == true
          ? "Push is Enabled"
          : "Push is Disabled";
      setState(() {
        _pushStatus = pushStatus;
      });
      _showToast("Push Status Updated");
    } catch (e) {
      _logException(e);
      _showToast('Failed to get Push Status.');
    }
  }

  Future<void> _fetchAttributes() async {
    try {
      var response = await SFMCSdk.getAttributes();
      final String attributes = jsonEncode(response);
      setState(() {
        _attributes = attributes;
      });
      _showToast("Attributes Fetched");
    } catch (e) {
      _logException(e);
      _showToast("Error getting attributes.");
    }
  }

  List<InboxMessage> parseMessages(List<String> messages) {
    return messages.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return InboxMessage.fromJson(jsonMap);
    }).toList();
  }

  Future<void> _fetchMessages() async {
    try {
      final List<String> messages = await SFMCSdk.getMessages();
      final List<InboxMessage> messagesList = parseMessages(messages);
      setState(() {
        _messages = messagesList;
      });
      _showToast("Messages Fetched");
    } catch (e) {
      _logException(e);
      _showToast("Error fetching messages.");
    }
  }

  Future<void> _fetchTags() async {
    try {
      final List<String> tags = await SFMCSdk.getTags();
      setState(() {
        _tags = tags;
      });
      _showToast("Tags Fetched");
    } catch (e) {
      _logException(e);
      _showToast("Error fetching tags.");
    }
  }

  Future<void> _fetchContactKey() async {
    try {
      final String contactKey =
          await SFMCSdk.getContactKey() ?? 'Not Available';
      setState(() {
        _contactKey = contactKey;
      });
      _showToast("Contact Key Fetched");
    } catch (e) {
      _logException(e);
      _showToast('Failed to get contact key.');
    }
  }

  void _onSetAttributesClicked(String key, String value) {
    try {
      SFMCSdk.setAttribute(key, value);
      _showToast('Attribute set successfully!');
    } catch (e) {
      _logException(e);
      _showToast('Error setting attribute.');
    }
  }

  void _onClearAttributesClicked(String key) {
    try {
      SFMCSdk.clearAttribute(key);
      _showToast('Attribute cleared successfully!');
    } catch (e) {
      _logException(e);
      _showToast('Error removing attribute.');
    }
  }

  void _onSetTagsClicked(tag) {
    try {
      SFMCSdk.addTag(tag);
      _showToast('Tags set successfully!');
    } catch (e) {
      _logException(e);
      _showToast('Error setting tags.');
    }
  }

  void _onRemoveTagsClicked(tag) {
    try {
      SFMCSdk.removeTag(tag);
      _showToast('Tag removed successfully!');
    } catch (e) {
      _logException(e);
      _showToast('Error setting tags.');
    }
  }

  void _onSetContactKeyClicked(value) {
    try {
      SFMCSdk.setContactKey(value);
      _showToast('Contact key is set.');
    } catch (e) {
      _logException(e);
      _showToast('Error setting contact key.');
    }
  }

  void _trackCustomEvent() {
    try {
      var customEvent = CustomEvent('CustomEventName',
          attributes: {'key1': 'trackCustomEvent'});
      SFMCSdk.trackEvent(customEvent);
      _showToast("Event tracked successfully");
    } catch (e) {
      _logException(e);
      _showToast('Error tracking event.');
    }
  }

  void _updateAnalyticsToggle() async {
    try {
      bool analyticsEnabled = await SFMCSdk.isAnalyticsEnabled();
      bool piAnalyticsEnabled = await SFMCSdk.isPiAnalyticsEnabled();
      setState(() {
        _analyticsEnabled = analyticsEnabled;
        _piAnalyticsEnabled = piAnalyticsEnabled;
      });
    } catch (e) {
      _logException(e);
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(249, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _logException(dynamic exception) {
    if (kDebugMode) {
      debugPrint(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SFMC Flutter SDK Example',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 11, 95, 200),
        ),
        body: Container(
          color: const Color.fromARGB(255, 210, 229, 248),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: <Widget>[
              buildCard(
                "System Token",
                "Get the system token from the SFMC SDK using SFMCSdk.getSystemToken().",
                _fetchSystemToken,
                'GET SYSTEM TOKEN',
                content: _systemToken,
              ),
              buildCard(
                "Device ID",
                "Get the device ID from the SFMC SDK using SFMCSdk.getDeviceId().",
                _fetchDeviceId,
                'GET DEVICE ID',
                content: _deviceId,
              ),
              buildCard(
                "Check Push Status",
                "Check if push notifications are enabled or disabled using SFMCSdk.isPushEnabled().",
                _updatePushStatus,
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
                "Get Contact Key",
                "Get the contact key from the SFMC SDK using SFMCSdk.getContactKey().",
                _fetchContactKey,
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
                _fetchTags,
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
                _fetchAttributes,
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
                _onClearAttributesClicked,
                'CLEAR ATTRIBUTE',
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
                  _showToast("Check platform logs for SDK state.");
                },
                'LOG SDK STATE',
              ),
              buildCard(
                "Track Custom Event",
                "Track custom event using SFMCSdk.trackEvent(event).",
                _trackCustomEvent,
                'TRACK EVENT',
              ),
              buildCard(
                "Get Messages",
                "Get Messages from the SFMC SDK using SFMCSdk.getMessages().",
                _fetchMessages,
                'GET MESSAGES',
                content:
                    _messages.isNotEmpty ? _messages.toString() : 'No Messages',
              ),
              buildToggleCard(
                "Analytics Enabled",
                "Enable/Disable analytics using SFMCSdk.setAnalyticsEnabled().",
                _analyticsEnabled,
                (bool value) {
                  SFMCSdk.setAnalyticsEnabled(value);
                  setState(() {
                    _analyticsEnabled = value;
                  });
                },
              ),
              buildToggleCard(
                "PI Analytics Enabled",
                "Enable/Disable PI analytics using SFMCSdk.setPiAnalyticsEnabled().",
                _piAnalyticsEnabled,
                (bool value) {
                  SFMCSdk.setPiAnalyticsEnabled(value);
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
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 18, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Text(description,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 120, 119, 119),
                            fontWeight: FontWeight.bold,
                            fontSize: 12))),
                TextFormField(
                  controller: controller1,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 18, 52),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Enter key',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 120, 119, 119),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                if (isTwoInputs)
                  TextFormField(
                    controller: controller2,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 18, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Enter value',
                      labelStyle: TextStyle(
                          color: Color.fromARGB(255, 120, 119, 119),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
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
                    backgroundColor: const Color.fromARGB(255, 11, 95, 200),
                  ),
                  child: Text(buttonText,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                )),
              ],
            )));
  }

  Widget buildCard(String title, String description, VoidCallback buttonAction,
      String buttonText,
      {String content = ''}) {
    return Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 18, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Text(description,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 120, 119, 119),
                            fontWeight: FontWeight.bold,
                            fontSize: 12))),
                if (buttonText != 'GET MESSAGES' && content.isNotEmpty)
                  SelectableText(
                    content,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 18, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (buttonText == 'GET MESSAGES') {
                        buttonAction();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessagesPage(messages: _messages),
                          ),
                        );
                      } else {
                        buttonAction();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 11, 95, 200),
                    ),
                    child: Text(buttonText,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            )));
  }

  Widget buildToggleCard(String title, String description, bool currentValue,
      ValueChanged<bool> onChanged) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 18, 52),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                description,
                style: const TextStyle(
                    color: Color.fromARGB(255, 120, 119, 119),
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 18, 52),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Switch(
                  activeTrackColor: const Color.fromARGB(255, 11, 95, 200),
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: const Color.fromARGB(255, 11, 95, 200),
                  activeColor: Colors.white,
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

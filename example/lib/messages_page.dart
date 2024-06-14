import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:sfmc/sfmc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class MessagesPage extends StatefulWidget {
  final List<InboxMessage> messages;

  const MessagesPage({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String _selectedMessageType = 'all';

  @override
  Widget build(BuildContext context) {
    List<InboxMessage> filteredMessages = [];

    if (_selectedMessageType == 'all') {
      filteredMessages = widget.messages;
    } else if (_selectedMessageType == 'read') {
      filteredMessages =
          widget.messages.where((message) => message.read).toList();
    } else if (_selectedMessageType == 'unread') {
      filteredMessages =
          widget.messages.where((message) => !message.read).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 11, 95, 200),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilterRow(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                final Uri url = Uri.parse(message.url);

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      leading: Icon(
                        message.read
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread,
                        color: message.read ? Colors.blue : Colors.red,
                        size: 28,
                      ),
                      title: Text(
                        message.subject ?? 'No subject',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.alert ?? 'No alert',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                message.sendDateUtc != null
                                    ? _formatDateTime(message
                                        .sendDateUtc!) // Show formatted date and time
                                    : 'Not available',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                message.read
                                    ? Icons.mark_email_read
                                    : Icons.mark_email_unread,
                                color: message.read ? Colors.blue : Colors.grey,
                                size: 24,
                              ),
                              onPressed: () {
                                // Call function to mark message as read
                                if (message.read) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Already read')),
                                  );
                                } else {
                                  _onSetMessagesRead(message.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Message marked as read')),
                                  );
                                  setState(() {
                                    message.read = true;
                                  });
                                }
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.grey, size: 24),
                            onPressed: () {
                              // Handle deleting the message
                              _onDeleteMessage(message.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Message deleted')),
                              );
                              setState(() {
                                message.deleted = true;
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        // Handle tapping on the message tile
                        _onSetMessagesRead(message.id);
                        setState(() {
                          message.read = true;
                        });
                        if (!await launchUrl(url)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Message'),
                              content: SingleChildScrollView(
                                child: Text(
                                  jsonEncode(message.toJson()),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterTab('All (${widget.messages.length})', 'all'),
          _buildFilterTab('Read (${_getReadMessagesCount()})', 'read'),
          _buildFilterTab('Unread (${_getUnreadMessagesCount()})', 'unread'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, String type) {
    final bool selected = type == _selectedMessageType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMessageType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _onSetMessagesRead(String id) async {
    SFMCSdk.setMessageRead(id);
  }

  Future<void> _onDeleteMessage(String id) async {
    SFMCSdk.deleteMessage(id);
    setState(() {
      widget.messages.removeWhere((message) => message.id == id);
    });
  }

  int _getReadMessagesCount() {
    return widget.messages.where((message) => message.read).length;
  }

  int _getUnreadMessagesCount() {
    return widget.messages.where((message) => !message.read).length;
  }

  // Define a function to format date and time
  String _formatDateTime(DateTime sendDateUtc) {
    String date = sendDateUtc.toString().substring(0, 10); // Extract date
    String time = _formatTime(sendDateUtc); // Format time
    return '$date $time';
  }

// Define a function to format time
  String _formatTime(DateTime sendDateUtc) {
    String period = sendDateUtc.hour >= 12 ? 'PM' : 'AM';
    int hour = sendDateUtc.hour > 12 ? sendDateUtc.hour - 12 : sendDateUtc.hour;
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = sendDateUtc.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr $period';
  }
}

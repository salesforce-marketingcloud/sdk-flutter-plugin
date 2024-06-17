import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart'; // Assuming you have this class defined
import 'package:url_launcher/url_launcher.dart';
import 'message_utils.dart'; // Import the utility functions

class MessagesPage extends StatefulWidget {
  final List<InboxMessage> messages;

  const MessagesPage({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String _selectedMessageType = 'all';
  List<InboxMessage> _readMessages = [];
  List<InboxMessage> _unreadMessages = [];
  List<InboxMessage> _deletedMessages = [];
  int _totalMessageCount = 0;
  int _readMessageCount = 0;
  int _unreadMessageCount = 0;
  int _deletedMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  Future<void> _initializeMessages() async {
    setState(() {
      _totalMessageCount = 0;
      _readMessageCount = 0;
      _unreadMessageCount = 0;
      _deletedMessageCount = 0;
      _readMessages = [];
      _unreadMessages = [];
      _deletedMessages = [];
    });

    _totalMessageCount = await fetchMessageCount();
    _readMessageCount = await fetchReadMessageCount();
    _unreadMessageCount = await fetchUnreadMessageCount();
    _deletedMessageCount = await fetchDeletedMessageCount();

    _readMessages = await fetchReadMessages();
    _unreadMessages = await fetchUnreadMessages();
    _deletedMessages = await fetchDeletedMessages();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<InboxMessage> filteredMessages = [];

    if (_selectedMessageType == 'all') {
      filteredMessages = widget.messages;
    } else if (_selectedMessageType == 'read') {
      filteredMessages = _readMessages;
    } else if (_selectedMessageType == 'unread') {
      filteredMessages = _unreadMessages;
    } else if (_selectedMessageType == 'deleted') {
      filteredMessages = _deletedMessages;
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
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              setState(() {
                widget.messages.clear();
              });
              await deleteAllMessages();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All messages deleted')),
              );
              await _initializeMessages();
            },
          ),
          IconButton(
            icon: Icon(Icons.mark_email_read, color: Colors.white),
            onPressed: () async {
              setState(() {
                for (var message in widget.messages) {
                  message.read = true;
                }
              });
              await markAllMessagesAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All messages marked as read')),
              );

              await _initializeMessages();
            },
          ),
        ],
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
                                    ? formatDateTime(message
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
                      trailing: _selectedMessageType != 'deleted'
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                message.read
                                    ? Icons.mark_email_read
                                    : Icons.mark_email_unread,
                                color: message.read
                                    ? Colors.blue
                                    : Colors.grey,
                                size: 24,
                              ),
                              onPressed: () async {
                                // Call function to mark message as read
                                if (message.read) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text('Already read')),
                                  );
                                } else {
                                  await setMessagesRead(message.id);
                                  await _initializeMessages();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Message marked as read')),
                                  );
                                  setState(() {
                                    message.read = true;
                                  });
                                }
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.grey, size: 24),
                            onPressed: () async {
                              await deleteMessage(message.id);
                              widget.messages.removeWhere(
                                      (msg) => msg.id == message.id);
                              await _initializeMessages();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Message deleted')),
                              );
                            },
                          ),
                        ],
                      )
                          : null,
                      onTap: () async {
                        if (!await launchUrl(url)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                        setState(() {
                          message.read = true;
                        });
                        await _initializeMessages();
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
          _buildFilterTab('All ($_totalMessageCount)', 'all'),
          // Display the total count
          _buildFilterTab('Read ($_readMessageCount)', 'read'),
          _buildFilterTab('Unread ($_unreadMessageCount)', 'unread'),
          _buildFilterTab('Deleted ($_deletedMessageCount)', 'deleted'),
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
}

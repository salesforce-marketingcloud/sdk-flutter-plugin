import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart';
import 'package:sfmc/sfmc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  final List<InboxMessage> messages;

  const MessagesPage({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String _selectedMessageType = 'all';
  var responseListener;
  var refreshListener;
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
    if (responseListener == null) {
      responseListener = (List<InboxMessage> list) {
        setState(() async {
          await _fetchMessages();
        });
      };
      SFMCSdk.registerInboxResponseListener(responseListener);
    }
    _initializeMessages();
  }

  @override
  void dispose() {
    if (responseListener != null) {
      SFMCSdk.unregisterInboxResponseListener(responseListener);
      responseListener = null;
    }
    super.dispose();
  }

  void _logException(dynamic exception) {
    if (kDebugMode) {
      debugPrint(exception.toString());
    }
  }

  String formatTime(DateTime sendDateUtc) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    String date = dateFormatter.format(sendDateUtc);
    final DateFormat timeFormatter = DateFormat('hh:mm a');
    String time = timeFormatter.format(sendDateUtc);
    return '$date $time';
  }

  Future<void> _initializeMessages() async {
    _totalMessageCount = await SFMCSdk.getMessageCount();
    _readMessageCount = await SFMCSdk.getReadMessageCount();
    _unreadMessageCount = await SFMCSdk.getUnreadMessageCount();
    _deletedMessageCount = await SFMCSdk.getDeletedMessageCount();
    _readMessages = await SFMCSdk.getReadMessages();
    _unreadMessages = await SFMCSdk.getUnreadMessages();
    _deletedMessages = await SFMCSdk.getDeletedMessages();

    setState(() {});
  }

  Future<void> _handleRefresh() async {
    try {
      refreshListener ??= (success) {};
      var succ = await SFMCSdk.refreshInbox(refreshListener);
      if (succ) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inbox refreshed successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh inbox')),
        );
      }
    } catch (e) {
      _logException(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to refresh inbox')),
      );
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final List<InboxMessage> messagesList = await SFMCSdk.getMessages();
      setState(() {
        widget.messages.clear();
        widget.messages.addAll(messagesList);
        _initializeMessages();
      });
    } catch (e) {
      _logException(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch messages')),
      );
    }
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
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read, color: Colors.white),
            onPressed: () async {
              setState(() {
                for (var message in widget.messages) {
                  message.read = true;
                }
              });
              await SFMCSdk.markAllMessagesRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All messages marked as read')),
              );
              await _initializeMessages();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              setState(() {
                widget.messages.clear();
                for (var message in widget.messages) {
                  message.deleted = true;
                }
              });
              await SFMCSdk.markAllMessagesDeleted();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All messages deleted')),
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
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: filteredMessages.isEmpty
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Text(
                            'There are no messages to show',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];
                        final Uri url = Uri.parse(message.url);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
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
                                            ? formatTime(message.sendDateUtc!)
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
                                              if (message.read) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('Already read')),
                                                );
                                              } else {
                                                await SFMCSdk.setMessageRead(
                                                    message.id);
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
                                            await SFMCSdk.deleteMessage(
                                                message.id);
                                            widget.messages.removeWhere(
                                                (msg) => msg.id == message.id);
                                            await _initializeMessages();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Message deleted')),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                              onTap: () async {
                                if (await launchUrl(url)) {
                                  setState(() {
                                    SFMCSdk.setMessageRead(message.id);
                                    message.read = true;
                                  });
                                  await _initializeMessages();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Could not launch $url')),
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
          _buildFilterTab('Read ($_readMessageCount)', 'read'),
          _buildFilterTab('Unread ($_unreadMessageCount)', 'unread'),
          _buildFilterTab('Deleted ($_deletedMessageCount)', 'deleted'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, String type) {
    final bool selected = type == _selectedMessageType;
    double paddingVertical = 11.0;
    double paddingHorizontal = 11.0;
    double fontSize = 13.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMessageType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: paddingVertical),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

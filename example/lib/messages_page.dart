// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:sfmc/inbox_message.dart'; // Assuming you have this class defined
// import 'package:sfmc/sfmc.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'message_utils.dart'; // Import the utility functions
//
// class MessagesPage extends StatefulWidget {
//   final ValueNotifier<List<InboxMessage>> messages;
//
//   const MessagesPage({Key? key, required this.messages}) : super(key: key);
//
//   @override
//   _MessagesPageState createState() => _MessagesPageState();
// }
//
// class _MessagesPageState extends State<MessagesPage> {
//   String _selectedMessageType = 'all';
//   List<InboxMessage> _readMessages = [];
//   List<InboxMessage> _unreadMessages = [];
//   List<InboxMessage> _deletedMessages = [];
//   int _totalMessageCount = 0;
//   int _readMessageCount = 0;
//   int _unreadMessageCount = 0;
//   int _deletedMessageCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMessages();
//   }
//
//   Future<void> _initializeMessages() async {
//     // Perform asynchronous operations to fetch data
//     int totalMessageCount = await fetchMessageCount();
//     int readMessageCount = await fetchReadMessageCount();
//     int unreadMessageCount = await fetchUnreadMessageCount();
//     int deletedMessageCount = await fetchDeletedMessageCount();
//
//     List<InboxMessage> readMessages = await fetchReadMessages();
//     List<InboxMessage> unreadMessages = await fetchUnreadMessages();
//     List<InboxMessage> deletedMessages = await fetchDeletedMessages();
//
//     // Update the state with the fetched data
//     setState(() {
//       _totalMessageCount = totalMessageCount;
//       _readMessageCount = readMessageCount;
//       _unreadMessageCount = unreadMessageCount;
//       _deletedMessageCount = deletedMessageCount;
//       _readMessages = readMessages;
//       _unreadMessages = unreadMessages;
//       _deletedMessages = deletedMessages;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<InboxMessage> filteredMessages =
//         getFilteredMessages(_selectedMessageType);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Messages',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 11, 95, 200),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete, color: Colors.white),
//             onPressed: () async {
//               setState(() {
//                 widget.messages.value.clear();
//               });
//               await deleteAllMessages();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('All messages deleted')),
//               );
//               await _initializeMessages();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.mark_email_read, color: Colors.white),
//             onPressed: () async {
//               setState(() {
//                 for (var message in widget.messages.value) {
//                   message.read = true;
//                 }
//               });
//               await markAllMessagesAsRead();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('All messages marked as read')),
//               );
//
//               await _initializeMessages();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _buildFilterRow(),
//           Expanded(
//             child: ValueListenableBuilder<List<InboxMessage>>(
//               valueListenable: widget.messages,
//               builder: (context, messages, _) {
//                 _initializeMessages();
//
//                 return ListView.builder(
//                   itemCount: filteredMessages.length,
//                   itemBuilder: (context, index) {
//                     final message = filteredMessages[index];
//                     final Uri url = Uri.parse(message.url);
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       child: Card(
//                         elevation: 3,
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 16),
//                           leading: Icon(
//                             message.read
//                                 ? Icons.mark_email_read
//                                 : Icons.mark_email_unread,
//                             color: message.read ? Colors.blue : Colors.red,
//                             size: 28,
//                           ),
//                           title: Text(
//                             message.subject ?? 'No subject',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 message.alert ?? 'No alert',
//                                 style: TextStyle(
//                                   color: Colors.grey[700],
//                                   fontSize: 16,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.access_time,
//                                       size: 16, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     message.sendDateUtc != null
//                                         ? formatDateTime(message
//                                             .sendDateUtc!) // Show formatted date and time
//                                         : 'Not available',
//                                     style: TextStyle(
//                                       color: Colors.grey[700],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           trailing: _selectedMessageType != 'deleted'
//                               ? Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                         icon: Icon(
//                                           message.read
//                                               ? Icons.mark_email_read
//                                               : Icons.mark_email_unread,
//                                           color: message.read
//                                               ? Colors.blue
//                                               : Colors.grey,
//                                           size: 24,
//                                         ),
//                                         onPressed: () async {
//                                           // Call function to mark message as read
//                                           if (message.read) {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               const SnackBar(
//                                                   content:
//                                                       Text('Already read')),
//                                             );
//                                           } else {
//                                             await setMessagesRead(message.id);
//                                             await _initializeMessages();
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               const SnackBar(
//                                                   content: Text(
//                                                       'Message marked as read')),
//                                             );
//                                             setState(() {
//                                               message.read = true;
//                                             });
//                                           }
//                                         }),
//                                     IconButton(
//                                       icon: const Icon(Icons.delete,
//                                           color: Colors.grey, size: 24),
//                                       onPressed: () async {
//                                         await deleteMessage(message.id);
//                                         widget.messages.value.removeWhere(
//                                             (msg) => msg.id == message.id);
//                                         await _initializeMessages();
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                               content: Text('Message deleted')),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 )
//                               : null,
//                           onTap: () async {
//                             if (!await launchUrl(url)) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text('Could not launch $url')),
//                               );
//                             }
//                             await setMessagesRead(message.id);
//                             setState(() {
//                               message.read = true;
//                             });
//                             await _initializeMessages();
//                           },
//                           onLongPress: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: const Text('Message'),
//                                   content: SingleChildScrollView(
//                                     child: Text(
//                                       jsonEncode(message.toJson()),
//                                       style: const TextStyle(fontSize: 12),
//                                     ),
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: const Text('Close'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<InboxMessage> getFilteredMessages(String messageType) {
//     List<InboxMessage> filteredMessages = [];
//     if (messageType == 'all') {
//       Set<InboxMessage> uniqueMessages = {};
//       for (var message in _readMessages) {
//         if (!_deletedMessages.contains(message)) {
//           uniqueMessages.add(message);
//         }
//       }
//       for (var message in _unreadMessages) {
//         if (!_deletedMessages.contains(message)) {
//           uniqueMessages.add(message);
//         }
//       }
//       filteredMessages = uniqueMessages.toList();
//     } else if (messageType == 'read') {
//       // Show only read messages
//       filteredMessages = _readMessages;
//     } else if (messageType == 'unread') {
//       // Show only unread messages
//       filteredMessages = _unreadMessages;
//     } else if (messageType == 'deleted') {
//       // Show only deleted messages
//       filteredMessages = _deletedMessages;
//     }
//
//     return filteredMessages;
//   }
//
//   Widget _buildFilterRow() {
//     return Container(
//       color: Colors.blue,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildFilterTab('All ($_totalMessageCount)', 'all'),
//           _buildFilterTab('Read ($_readMessageCount)', 'read'),
//           _buildFilterTab('Unread ($_unreadMessageCount)', 'unread'),
//           _buildFilterTab('Deleted ($_deletedMessageCount)', 'deleted'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterTab(String text, String type) {
//     final bool selected = type == _selectedMessageType;
//     double paddingVertical = 11.0; // Default vertical padding
//     double paddingHorizontal = 11.0; // Default horizontal padding
//     double fontSize = 13.0; // Default font size
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedMessageType = type;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             horizontal: paddingHorizontal, vertical: paddingVertical),
//         decoration: BoxDecoration(
//           color: selected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: selected ? Colors.blue : Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: fontSize,
//           ),
//         ),
//       ),
//     );
//   }
// }
// // import 'dart:convert';
// //
// // import 'package:flutter/material.dart';
// // import 'package:sfmc/inbox_message.dart'; // Assuming you have this class defined
// // import 'package:sfmc/sfmc.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'message_utils.dart'; // Import the utility functions
// //
// // class MessagesPage extends StatefulWidget {
// //   final List<InboxMessage> messages;
// //
// //   const MessagesPage({Key? key, required this.messages}) : super(key: key);
// //
// //   @override
// //   _MessagesPageState createState() => _MessagesPageState();
// // }
// //
// // class _MessagesPageState extends State<MessagesPage> {
// //   String _selectedMessageType = 'all';
// //   List<InboxMessage> _readMessages = [];
// //   List<InboxMessage> _unreadMessages = [];
// //   List<InboxMessage> _deletedMessages = [];
// //   int _totalMessageCount = 0;
// //   int _readMessageCount = 0;
// //   int _unreadMessageCount = 0;
// //   int _deletedMessageCount = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeMessages();
// //   }
// //
// //   Future<void> _initializeMessages() async {
// //     setState(() {
// //       _totalMessageCount = 0;
// //       _readMessageCount = 0;
// //       _unreadMessageCount = 0;
// //       _deletedMessageCount = 0;
// //       _readMessages = [];
// //       _unreadMessages = [];
// //       _deletedMessages = [];
// //     });
// //
// //     _totalMessageCount = await fetchMessageCount();
// //     _readMessageCount = await fetchReadMessageCount();
// //     _unreadMessageCount = await fetchUnreadMessageCount();
// //     _deletedMessageCount = await fetchDeletedMessageCount();
// //
// //     _readMessages = await fetchReadMessages();
// //     _unreadMessages = await fetchUnreadMessages();
// //     _deletedMessages = await fetchDeletedMessages();
// //
// //     setState(() {});
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<InboxMessage> filteredMessages = [];
// //
// //     if (_selectedMessageType == 'all') {
// //       filteredMessages = widget.messages;
// //     } else if (_selectedMessageType == 'read') {
// //       filteredMessages = _readMessages;
// //     } else if (_selectedMessageType == 'unread') {
// //       filteredMessages = _unreadMessages;
// //     } else if (_selectedMessageType == 'deleted') {
// //       filteredMessages = _deletedMessages;
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Messages',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //             fontSize: 18,
// //           ),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: const Color.fromARGB(255, 11, 95, 200),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.delete, color: Colors.white),
// //             onPressed: () async {
// //               setState(() {
// //                 widget.messages.clear();
// //               });
// //               await deleteAllMessages();
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(content: Text('All messages deleted')),
// //               );
// //               await _initializeMessages();
// //             },
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.mark_email_read, color: Colors.white),
// //             onPressed: () async {
// //               setState(() {
// //                 for (var message in widget.messages) {
// //                   message.read = true;
// //                 }
// //               });
// //               await markAllMessagesAsRead();
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(content: Text('All messages marked as read')),
// //               );
// //
// //               await _initializeMessages();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           _buildFilterRow(),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: filteredMessages.length,
// //               itemBuilder: (context, index) {
// //                 final message = filteredMessages[index];
// //                 final Uri url = Uri.parse(message.url);
// //
// //                 return Padding(
// //                   padding:
// //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                   child: Card(
// //                     elevation: 3,
// //                     child: ListTile(
// //                       contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 16),
// //                       leading: Icon(
// //                         message.read
// //                             ? Icons.mark_email_read
// //                             : Icons.mark_email_unread,
// //                         color: message.read ? Colors.blue : Colors.red,
// //                         size: 28,
// //                       ),
// //                       title: Text(
// //                         message.subject ?? 'No subject',
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 18,
// //                         ),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       subtitle: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             message.alert ?? 'No alert',
// //                             style: TextStyle(
// //                               color: Colors.grey[700],
// //                               fontSize: 16,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Row(
// //                             children: [
// //                               const Icon(Icons.access_time,
// //                                   size: 16, color: Colors.grey),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 message.sendDateUtc != null
// //                                     ? formatDateTime(message
// //                                     .sendDateUtc!) // Show formatted date and time
// //                                     : 'Not available',
// //                                 style: TextStyle(
// //                                   color: Colors.grey[700],
// //                                   fontSize: 12,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                       trailing: _selectedMessageType != 'deleted'
// //                           ? Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           IconButton(
// //                               icon: Icon(
// //                                 message.read
// //                                     ? Icons.mark_email_read
// //                                     : Icons.mark_email_unread,
// //                                 color: message.read
// //                                     ? Colors.blue
// //                                     : Colors.grey,
// //                                 size: 24,
// //                               ),
// //                               onPressed: () async {
// //                                 // Call function to mark message as read
// //                                 if (message.read) {
// //                                   ScaffoldMessenger.of(context)
// //                                       .showSnackBar(
// //                                     const SnackBar(
// //                                         content: Text('Already read')),
// //                                   );
// //                                 } else {
// //                                   await setMessagesRead(message.id);
// //                                   await _initializeMessages();
// //                                   ScaffoldMessenger.of(context)
// //                                       .showSnackBar(
// //                                     const SnackBar(
// //                                         content: Text(
// //                                             'Message marked as read')),
// //                                   );
// //                                   setState(() {
// //                                     message.read = true;
// //                                   });
// //                                 }
// //                               }),
// //                           IconButton(
// //                             icon: const Icon(Icons.delete,
// //                                 color: Colors.grey, size: 24),
// //                             onPressed: () async {
// //                               await deleteMessage(message.id);
// //                               widget.messages.removeWhere(
// //                                       (msg) => msg.id == message.id);
// //                               await _initializeMessages();
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                     content: Text('Message deleted')),
// //                               );
// //                             },
// //                           ),
// //                         ],
// //                       )
// //                           : null,
// //                       onTap: () async {
// //                         if (!await launchUrl(url)) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(content: Text('Could not launch $url')),
// //                           );
// //                         }
// //                         setState(() {
// //                           message.read = true;
// //                         });
// //                         await _initializeMessages();
// //                       },
// //                       onLongPress: () {
// //                         showDialog(
// //                           context: context,
// //                           builder: (context) {
// //                             return AlertDialog(
// //                               title: const Text('Message'),
// //                               content: SingleChildScrollView(
// //                                 child: Text(
// //                                   jsonEncode(message.toJson()),
// //                                   style: const TextStyle(fontSize: 14),
// //                                 ),
// //                               ),
// //                               actions: [
// //                                 TextButton(
// //                                   onPressed: () {
// //                                     Navigator.of(context).pop();
// //                                   },
// //                                   child: const Text('Close'),
// //                                 ),
// //                               ],
// //                             );
// //                           },
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFilterRow() {
// //     return Container(
// //       color: Colors.blue,
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //         children: [
// //           _buildFilterTab('All ($_totalMessageCount)', 'all'),
// //           // Display the total count
// //           _buildFilterTab('Read ($_readMessageCount)', 'read'),
// //           _buildFilterTab('Unread ($_unreadMessageCount)', 'unread'),
// //           _buildFilterTab('Deleted ($_deletedMessageCount)', 'deleted'),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFilterTab(String text, String type) {
// //     final bool selected = type == _selectedMessageType;
// //     double paddingVertical = 11.0; // Default vertical padding
// //     double paddingHorizontal = 11.0; // Default horizontal padding
// //     double fontSize = 13.0; // Default font size
// //
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _selectedMessageType = type;
// //         });
// //       },
// //       child: Container(
// //         padding: EdgeInsets.symmetric(
// //             horizontal: paddingHorizontal, vertical: paddingVertical),
// //         decoration: BoxDecoration(
// //           color: selected ? Colors.white : Colors.transparent,
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Text(
// //           text,
// //           style: TextStyle(
// //             color: selected ? Colors.blue : Colors.white,
// //             fontWeight: FontWeight.bold,
// //             fontSize: fontSize,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:sfmc/inbox_message.dart'; // Assuming you have this class defined
import 'package:sfmc/sfmc.dart';
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

  Future<void> _handleRefresh() async {
    try {
      refreshListener ??= (success) {};
      var succ = await SFMCSdk.refreshInbox(refreshListener);
      print("1111SUCCESS");
      print(succ);
      if (succ) {
       if (responseListener == null) {
print("%%%");
          responseListener = (List<InboxMessage> list) {
            setState(() async {
              print("pg1");
              await _fetchMessages();
            });
          };
          print("later");
          SFMCSdk.registerInboxResponseListener(responseListener);

      }


        print("1111");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inbox refreshed successfully')),
        );
        //After refreshing, reinitialize messages if needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh inbox')),
        );
      }
    } catch (e) {
      print('Error refreshing inbox: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to refresh inbox')),
      );
    }
  }

  List<InboxMessage> parseMessages(String jsonString) {
    final List<dynamic> jsonArray = jsonDecode(jsonString);
    return jsonArray.map((json) => InboxMessage.fromJson(json)).toList();
  }

  Future<void> _fetchMessages() async {
    try {
      final String messages =
          await SFMCSdk.getMessages(); // Adjust to your SDK method
      print("pg100");
      final List<InboxMessage> messagesList = parseMessages(messages);
      setState(() {
        widget.messages.clear();
        widget.messages.addAll(messagesList);
        _initializeMessages();
      });
    } catch (e) {
      print('Error fetching messages: $e');
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
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
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
                                      ? formatDateTime(message.sendDateUtc!)
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                            setMessagesRead(message.id);
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
    double paddingVertical = 11.0; // Default vertical padding
    double paddingHorizontal = 11.0; // Default horizontal padding
    double fontSize = 13.0; // Default font size

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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/main.dart';
import 'package:recipes/home.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  ChatPage({required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUser = '';
  String chatWithUser = '';

  String myUser = '';
  String mychatWithUser = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    await getmyInfo();
    await getuserInfo();
    setState(() {});
  }

  Future<void> getmyInfo() async {
    var myDoc = await _firestore.collection('users').doc(MyApp.uid).get();
    myUser = myDoc.data()?['username'] ?? 'No username';
    mychatWithUser = myDoc.data()?['uid'] ?? 'No username';
  }

  Future<void> getuserInfo() async {
    var userDoc = await _firestore.collection('users').doc(widget.userId).get();
    currentUser = userDoc.data()?['username'] ?? 'No username';
    chatWithUser = userDoc.data()?['uid'] ?? 'No username';
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      String timestamp = DateTime.now().toString();
      String times = DateTime.now().toString().replaceAll(".", ":");
      DocumentReference docRef = _firestore.collection('users').doc(widget.userId);
      DocumentReference mydocRef = _firestore.collection('users').doc(MyApp.uid);

      await mydocRef.update({
        'chats.$chatWithUser.$times': {
          'username': myUser,
          'message': message,
          'timestamp': timestamp,
          'type': 'message',
        }
      });

      await docRef.update({
        'chats.$mychatWithUser.$times': {
          'username': myUser,
          'message': message,
          'timestamp': timestamp,
          'type': 'cmessage',
        }
      });

      _controller.clear();
    }
  }

  void _sendCardList() async {
    String timestamp = DateTime.now().toString();
    String times = DateTime.now().toString().replaceAll(".", ":");
    DocumentReference docRef = _firestore.collection('users').doc(widget.userId);
    DocumentReference mydocRef = _firestore.collection('users').doc(MyApp.uid);

    await mydocRef.update({
      'chats.$chatWithUser.$times': {
        'username': myUser,
        'message': MyApp.componentikss,
        'timestamp': timestamp,
        'type': 'card',
      }
    });

    await docRef.update({
      'chats.$mychatWithUser.$times': {
        'username': myUser,
        'message': MyApp.componentikss,
        'timestamp': timestamp,
        'type': 'card',
      }
    });
  }

  // void _copyToComponentikss(String message) {
  //   setState(() {
  //     MyApp.componentikss = message;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Message copied to componentikss')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (myUser.isEmpty || chatWithUser.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Chat Page'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(' $currentUser'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(widget.userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var chatData = snapshot.data!.data() as Map<String, dynamic>;
                var chatWithUsernameData = chatData['chats']?['$mychatWithUser'] ?? {};

                var messages = chatWithUsernameData.entries.map((entry) {
                  var messageData = entry.value as Map<String, dynamic>;
                  return {
                    'username': messageData['username'],
                    'message': messageData['message'],
                    'timestamp': messageData['timestamp'],
                    'type': messageData['type'],
                  };
                }).toList();

                messages.sort((a, b) {
                  DateTime aTime = DateTime.parse(a['timestamp']);
                  DateTime bTime = DateTime.parse(b['timestamp']);
                  return aTime.compareTo(bTime);
                });

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var username = message['username'];
                    var messageText = message['message'];
                    var messageType = message['type'];
                    var isCurrentUser = username == myUser;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blueAccent : Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                '$username: $messageText',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            if (messageType == 'card')
                              IconButton(
                                icon: Icon(Icons.copy, color: Colors.white),
                                onPressed: () {

                                  MyApp.componentikss = messageText;

                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: 'sjjdsfdsyfsdjjddj',
                  onPressed: () => _sendMessage(_controller.text),
                  child: Icon(Icons.send),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: 'sjjdsfdsyfsdjjjaxczxc',
                  onPressed: _sendCardList,
                  child: Icon(Icons.card_membership),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

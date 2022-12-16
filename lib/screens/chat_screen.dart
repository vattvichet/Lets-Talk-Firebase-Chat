// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const activeSentButtonColor = Colors.lightBlueAccent;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User loggedInUser;

  TextEditingController _messageText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    print(loggedInUser.email);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          TextButton(
              child: Text(
                "LogOut",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageText,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    splashColor: Color.fromARGB(255, 81, 255, 6),
                    onPressed: () {
                      if (_messageText.text.isNotEmpty ||
                          _messageText.text != ' ') {
                        _fireStore.collection('messages').add({
                          'sender': loggedInUser.email,
                          'text': _messageText.text,
                        });
                      }
                      setState(() {
                        _messageText.text = '';
                      });
                    },
                    icon: Icon(Icons.send_outlined),
                    color: Colors.lightBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

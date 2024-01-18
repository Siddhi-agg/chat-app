import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newMessage extends StatefulWidget {
  const newMessage({super.key});

  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userFirestore = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      // print('hi');
      return;
    }
    _messageController.clear();
    FocusScope.of(context).unfocus();
    await FirebaseFirestore.instance.collection('chats').add({
      'message': enteredMessage,
      'createdAt': Timestamp.now(),
      'sentByUid': currentUser.uid,
      'userImage': userFirestore.data()!['image_url'],
      'username': userFirestore.data()!['username']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 12, right: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send Message'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMessage,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}

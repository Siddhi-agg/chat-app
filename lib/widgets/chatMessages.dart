import 'package:chat_app/widgets/messageBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//the stream starts at the latest message, hence it is built from down to top so next user is checked instead of prev user to see whether the message is first or not
class chatMessages extends StatelessWidget {
  const chatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No Messages Found.'),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(bottom: 30, left: 15, right: 15),
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserid = chatMessage['sentByUid'];
            final nextMessageUserid = index + 1 < loadedMessages.length
                ? nextMessage!['sentByUid']
                : null;
            final nextUserIsSame = currentMessageUserid == nextMessageUserid;
            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage['message'],
                  isMe: currUser!.uid == currentMessageUserid);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['message'],
                  isMe: currUser!.uid == currentMessageUserid);
            }
          },
        );
      },
    );
  }
}

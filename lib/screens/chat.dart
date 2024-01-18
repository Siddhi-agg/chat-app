import 'package:chat_app/widgets/chatMessages.dart';
import 'package:chat_app/widgets/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  void setupPushNotifs()async{
     final firebaseMessaging= FirebaseMessaging.instance;
     await firebaseMessaging.requestPermission();
    // final token=await firebaseMessaging.getToken();
    // print(token);
    firebaseMessaging.subscribeToTopic('chats');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotifs();
   
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Column(
          children: [Expanded(child: chatMessages()), newMessage()],
        ));
  }
}

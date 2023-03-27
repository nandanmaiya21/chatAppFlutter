import 'package:chat/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Future<User?> currentUserDetail() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentUserDetail(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDoc = chatSnapshot.data;

              return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => MessageBubble(
                        chatDoc.docs[index]['username'],
                        chatDoc.docs[index]['text'],
                        futureSnapshot.data!.uid ==
                            chatDoc.docs[index]['userId'],
                        chatDoc.docs[index]['createdAt'].toDate(),
                        chatDoc.docs[index]['userImage'],
                        key: ValueKey(chatDoc.docs[index].id),
                      ),
                  itemCount: chatDoc!.docs.length);
            },
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots());
      },
    );
  }
}

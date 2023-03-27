import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      this.username, this.message, this.isMe, this.dateTime, this.image_url,
      {required this.key});
  final String username;
  final String message;
  final bool isMe;
  final DateTime dateTime;
  final Key key;
  final String image_url;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(image_url),
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isMe ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                //Text
                constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                child: Text(
                  message,
                  // textAlign: isMe ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.headlineLarge!.color),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    weight: 5,
                    color: !isMe ? Colors.white : Colors.black,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    DateFormat.jm().format(dateTime),
                    style: TextStyle(
                        fontSize: 10,
                        color: !isMe ? Colors.white : Colors.black),
                  )
                ],
              ),
            ],
          ),
        ),
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(image_url),
          ),
      ],
    );
  }
}

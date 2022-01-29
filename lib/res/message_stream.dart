import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_the_chat/res/message_box.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatefulWidget {
  const MessageStream(this.email, {Key? key}) : super(key: key);

  final String email;

  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('dateTime').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs.reversed;

        List<MessageBox> messageBoxes = [];
        for (var message in messages) {
          final msg = message.data() as Map<String, dynamic>;
          final sender = msg['sender'];
          final text = msg['text'];

          final messageBox = MessageBox(
            sender: sender,
            text: text,
            isMe: widget.email == sender,
          );
          messageBoxes.add(messageBox);
        }
        return ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
          children: messageBoxes,
        );
      },
    );
  }
}

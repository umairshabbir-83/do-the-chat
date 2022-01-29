import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_the_chat/res/log_out.dart';
import 'package:do_the_chat/res/message_stream.dart';
import 'package:do_the_chat/res/text_field.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String email;

  const ChatPage(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: const [LogOutButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: MessageStream(email)),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      hint: 'Type...',
                      controller: _messageController,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () => _onTapSend(_messageController, email),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSend(TextEditingController controller, String sender) {
    FirebaseFirestore.instance.collection('messages').add({
      'sender': sender,
      'text': controller.text.trim(),
      'dateTime': DateTime.now(),
    });
    controller.clear();
  }
}

import 'dart:convert';

import 'package:chatbot_flutter2/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController promptController = TextEditingController();

  static const akey = '';

  final List<ModelMessage> prompt = [];

  // Future<void> sendMessage() async {
  //   final message = promptController.text;

  //   //user prompt
  //   setState(() {
  //     prompt.add(
  //       ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
  //     );
  //   });

  //   //bot response
  //   final content = [Content.text(message)];
  //   final response = await model.generateContent(content);

  //   setState(() {
  //     prompt.add(
  //       ModelMessage(
  //         isPrompt: false,
  //         message: response.text ?? '',
  //         time: DateTime.now(),
  //       ),
  //     );
  //   });
  // }

  Future<void> sendMessage() async {
    final message = promptController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      prompt.add(
        ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
      );
    });

    promptController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $akey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {"role": "user", "content": message},
          ],
        }),
      );

      final data = jsonDecode(response.body);

      final reply = data['choices'][0]['message']['content'];

      setState(() {
        prompt.add(
          ModelMessage(isPrompt: false, message: reply, time: DateTime.now()),
        );
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        elevation: 10,
        title: Text('Flutter chatbot'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prompt.length,
              itemBuilder: (context, index) {
                final message = prompt[index];
                return UserPrompt(
                  isPrompt: message.isPrompt,
                  message: message.message,
                  date: DateFormat('hh:mm a').format(message.time),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 12,
                  child: TextField(
                    controller: promptController,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter a prompt',
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    await sendMessage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 30,
                    child: Icon(Icons.send, color: Colors.black, size: 35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container UserPrompt({
    required final bool isPrompt,
    required String message,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrompt ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isPrompt ? Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : Radius.circular(20),
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ).copyWith(right: isPrompt ? 15 : 80, left: isPrompt ? 80 : 15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //for prompt and response
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              color: isPrompt ? Colors.white : Colors.black,
              fontSize: 20,
            ),
          ),
          //for prompt and response time
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

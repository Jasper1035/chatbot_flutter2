import 'package:chatbot_flutter2/model.dart';
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController promptController = TextEditingController();
  final bool isPrompt = true;
  final List<ModelMessage> prompt = [];

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
              itemBuilder: (context, index) {
                final message = prompt[index];
                return Container(
                  decoration: BoxDecoration(
                    color: isPrompt == true ? Colors.green : Colors.grey,
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          fontWeight: isPrompt == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isPrompt == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
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
                  onTap: () {},
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
}

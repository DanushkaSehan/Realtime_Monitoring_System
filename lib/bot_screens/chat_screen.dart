// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// import 'response_model.dart';

// class chatScreen extends StatefulWidget {
//   const chatScreen({Key? key}) : super(key: key);

//   @override
//   _chatScreenState createState() => _chatScreenState();
// }

// class _chatScreenState extends State<chatScreen> {
//   late final TextEditingController promtController;
//   String responseTxt = "";
//   late ResponseModel _responseModel;

//   @override
//   void initState() {
//     super.initState();
//     promtController = TextEditingController();
//     super.initState();
//   }

//   void dispose() {
//     promtController.dispose();
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat Screen"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           PromptBldr(responseTxt: responseTxt),
//           TextFormBldr(
//             promtController: promtController,
//             btnFun: completionFun,
//           ),
//         ],
//       ),
//     );
//   }

//   completionFun() async {
//     setState(() => responseTxt = 'Loading...');
//     final response =
//         await http.post(Uri.parse('https://api.openai.com/v1/completions'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${dotenv.env['token']}',
//             },
//             body: jsonEncode({
//               "model": "text-davinci-003",
//               "prompt": promtController.text,
//               "max_tokens": 250,
//               "temperature": 0,
//               "top_p": 1,
//             }));
//     print("--------------------------------");
//     setState(() {
//       _responseModel = ResponseModel.fromJson(response.body);
//       responseTxt = _responseModel.choices[0].text;
//       debugPrint(responseTxt);
//     });
//   }
// }

// class PromptBldr extends StatelessWidget {
//   const PromptBldr({
//     Key? key,
//     required this.responseTxt,
//   }) : super(key: key);

//   final String responseTxt;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: MediaQuery.of(context).size.height / 1.35,
//         color: Color.fromARGB(234, 73, 21, 97),
//         child: Align(
//             alignment: Alignment.bottomLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: SingleChildScrollView(
//                 child: Text(
//                   responseTxt,
//                   textAlign: TextAlign.start,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )));
//   }
// }

// class TextFormBldr extends StatelessWidget {
//   const TextFormBldr({
//     Key? key,
//     required this.promtController,
//     required this.btnFun,
//   }) : super(key: key);

//   final TextEditingController promtController;
//   final Function btnFun;

import 'dart:convert';

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: promtController,
//                 decoration: const InputDecoration(
//                   hintText: "Enter your message",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 btnFun();
//               },
//               child: const Text("Send"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class ChatScreen extends StatefulWidget {
//   @override
//   State createState() => ChatScreenState();
// }

// class ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final List<Message> _messages = [];

//   final Map<String, String> predefinedResponses = {
//     "How do I fix a leaking pipe in the machine?":
//         "To fix a leaking pipe, follow these steps:...",
//     "What's the recommended oil change interval?":
//         "The recommended oil change interval is every 3 months or 1000 hours of operation...",
//     "How do I change the oil?": "To change the oil, follow these steps:...",
//     "How do I change the air filter?":
//         "To change the air filter, follow these steps:...",
//     "Motor won't start": "To fix this issue, follow these steps:...",
//     "Motor won't stop": "To fix this issue, follow these steps:...",
//     "Machine won't start": "To fix this issue, follow these steps:...",
//     "Machine won't stop": "To fix this issue, follow these steps:...",
//     "Machine is vibrating":
//         "Vibration can be extremely damaging to electric motors, frequently causing premature failure. It is often caused by the motor being positioned on an uneven or unstable surface. However, vibration can also be a result of an underlying issue with the motor, such as misalignment or corrosion. Electric motors should be regularly inspected for vibration using a motor analysing tool.Ensure that electric motors are positioned on a flat and stable surface. If vibration still occurs, check for signs of wear, as well as misalignment or loose bearings. ",
//     "Low resistance in the motor":
//         "Low resistance is the most common cause of failure in electric motors. It is also often the most difficult to overcome. Under conditions such as overheating, corrosion or physical damage, degradation of the insulation of the internal windings of the motor may occur. This then causes insufficient isolation between the motor windings or conductors, leading to short circuits, leakages and eventually motor failure.",
//     "Motor is overheating":
//         "Overheating is generally caused by either a high temperature in the operating environment or poor power quality. It is responsible for around 55% of insulating failures in electric motors. For every 10 degrees Celsius that the temperature of a motor rises, the insulation life is reduced by half.To avoid overheating, ensure that electric motors are kept as cool as possible. This can be done by maintaining as cool an operating environment as possible and regularly checking the temperature of the motor.",

//     // Add more predefined questions and answers here
//   };

//   // Future<String> sendMessageToChatGPT(String message) async {
//   //   final apiKey =
//   //       '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'; // Replace with your ChatGPT API key
//   //   final apiUrl =
//   //       'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions'; // GPT-3.5-turbo endpoint

//   //   final response = await http.post(
//   //     Uri.parse(apiUrl),
//   //     headers: {
//   //       'Authorization': 'Bearer $apiKey',
//   //       'Content-Type': 'application/json',
//   //     },
//   //     body: json.encode({
//   //       'prompt': message,
//   //       'max_tokens': 100,
//   //     }),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final data = json.decode(response.body);
//   //     return data['choices'][0]['text'];
//   //   } else {
//   //     print('Error: ${response.statusCode}');
//   //     print('Response Body: ${response.body}');
//   //     throw Exception('Failed to send message to ChatGPT');
//   //   }
//   // }

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  Future<String> sendMessageToChatGPT(String message) async {
    final apiKey = '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';
    final apiUrl =
        'https://api.openai.com/v1/engines/davinci/completions'; // GPT-3.5-turbo endpoint

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful chatbot for machine maintenance.'
          },
          {'role': 'user', 'content': message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to send message to ChatGPT');
    }
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text, true)); // User's message
      _textController.clear();
    });

    try {
      final response = await sendMessageToChatGPT(text);
      setState(() {
        _messages.add(Message(response, false)); // ChatGPT's response
      });
    } catch (e) {
      // Handle API request errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance ChatBot'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return ListTile(
      title: Text(
        message.text,
        textAlign: message.isUser ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

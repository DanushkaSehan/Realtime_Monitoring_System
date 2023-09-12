import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'background_widget.dart';
import 'constants.dart';
import 'home_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REQ Maintenance',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ReqMaintenance(),
    );
  }
}

Future<String> _tokenfun() async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('tokens')
      .doc('device1')
      .get();
  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  String tokenkey = data['key1'];
  return tokenkey;
}

String getCurrentDateTime() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final formattedDate = formatter.format(now);
  return formattedDate;
}

Future<void> addDataToCollection(
    String collectionName, Map<String, dynamic> data) async {
  try {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('notifications');

    await collectionReference.add(data);
  } catch (e) {
    print('Error adding data to Firestore: $e');
  }
}

class ReqMaintenance extends StatefulWidget {
  @override
  _ReqMaintenanceState createState() => _ReqMaintenanceState();
}

class _ReqMaintenanceState extends State<ReqMaintenance> {
  late TextEditingController _textToken;
  late TextEditingController _textSetToken;
  late TextEditingController _textTitle;
  late TextEditingController _textBody;

  @override
  void dispose() {
    _textToken.dispose();
    _textTitle.dispose();
    _textBody.dispose();
    _textSetToken.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _textToken = TextEditingController();
    _textSetToken = TextEditingController();
    _textTitle = TextEditingController();
    _textBody = TextEditingController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/launcher_icon'),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        shadowColor: Color.fromARGB(255, 59, 33, 102),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 60),
            Flexible(
              child: Container(
                child: Text(
                  'Request Maintenance'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Machine Number :'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          93, 229, 212, 238), // Set the background color
                      borderRadius: BorderRadius.circular(
                          25.0), // Optional: Add rounded corners
                    ),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _textTitle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        //labelText: 'Enter Machine Number',
                        hoverColor: Color.fromARGB(66, 183, 102, 102),
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 112, 85, 156),
                              width: 2),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 64, 35, 113)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Issue :'.tr,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          93, 229, 212, 238), // Set the background color
                      borderRadius: BorderRadius.circular(
                          25.0), // Optional: Add rounded corners
                    ),
                    child: TextField(
                      controller: _textBody,
                      decoration: InputDecoration(
                        fillColor: Colors.deepPurple,
                        hoverColor: Color.fromARGB(66, 183, 102, 102),
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 64, 35, 113)),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 60,
                          child: TextButton(
                            onPressed: () async {
                              if (check()) {
                                String tockeyval = await token();
                                print("DEVICE TOKEN-----$tockeyval");
                                String tokenkey = await _tokenfun();

                                pushNotificationsSpecificDevice(
                                  title: _textTitle.text,
                                  body: _textBody.text,
                                  token: tokenkey,
                                );
                                String formattedDateTime = getCurrentDateTime();
                                Map<String, dynamic> userData = {
                                  'timestamp': formattedDateTime,
                                  'machine': _textBody.text,
                                  'issue': _textTitle.text,
                                };

                                await addDataToCollection(
                                    'notifications', userData);
                                showDialog(
                                  context:
                                      context, // Use the BuildContext from your widget
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Request Submitted Successfully'.tr),
                                      //content: Text('Please Fill All Fields'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'.tr),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()),
                                            ); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context:
                                      context, // Use the BuildContext from your widget
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Request Not Submitted'.tr),
                                      content: Text(
                                          'Please fill machine number and issue'
                                              .tr),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'.tr),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            // style: TextButton.styleFrom(
                            //     backgroundColor: Colors.deepPurple,
                            //     foregroundColor: Colors.white),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 85, 54, 139)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),

                            child: Text(
                              'Submit'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  bool check() {
    if (_textTitle.text.isNotEmpty && _textBody.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}

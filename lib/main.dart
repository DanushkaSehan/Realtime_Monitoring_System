import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:iotrealtimedatameasure/LocaleString.dart';

import 'signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        darkTheme: ThemeData.light(),
        translations: LocaleString(),
        locale: Locale('en', 'US'),
        title: 'FabriTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const SizedBox(width: double.infinity, child: SignInScreen()));
  }
}







































// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "RealTime Data ",
//       home: RealTimeData(),
//     );
//   }
// }

// class RealTimeData extends StatelessWidget {
//   RealTimeData({super.key});
//   final ref = FirebaseDatabase.instance.ref('Device');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromARGB(255, 45, 45, 53),
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 32, 29, 85),
//           title: const Text("Real Time Data"),
//         ),
//         // body: Center(
//         //   child: Column(children: [
//         //     Expanded(
//         //         child: FirebaseAnimatedList(
//         //             query: ref,
//         //             itemBuilder: (context, snapshot, animation, index) {
//         //               return Container(
//         //                 //decoration: BoxDecoration(),
//         //                 //foregroundDecoration: Colors.purpleAccent,
//         //                 color: Color.fromARGB(255, 149, 72, 72),
//         //                 child: ListTile(

//         //                     //title: const Text('Fusing Machine 01'),
//         //                     title: Text(
//         //                         snapshot.child('Locatio').value.toString())),
//         //               );
//         //             }))
//         //   ]),
//         // )

//         body: Center(
//           child: Column(children: [
//             SizedBox(
//               height: 10,
//             ),
//             Expanded(
//                 child: FirebaseAnimatedList(
//                     query: ref,
//                     itemBuilder: (context, snapshot, animation, index) {
//                       return Container(
//                         //decoration: BoxDecoration(),
//                         //foregroundDecoration: Colors.purpleAccent,
//                         //color: Color.fromARGB(255, 149, 72, 72),

//                         child: ListTile(
//                             textColor: Color.fromARGB(251, 250, 250, 253),

//                             //title: const Text('Fusing Machine 01'),
//                             title: Column(
//                               children: [
//                                 Container(
//                                     width: 200,
//                                     height: 150,
//                                     child: Image.asset(
//                                         'assets/images/FabriTrack logo.png')),
//                                 SizedBox(height: 100),
//                                 Text('Machine Id - '),
//                                 Text(snapshot
//                                     .child('Machine ID')
//                                     .value
//                                     .toString()),
//                                 SizedBox(height: 15),
//                                 Text('Input Length - '),
//                                 Text(snapshot
//                                     .child('Input Length')
//                                     .value
//                                     .toString()),
//                                 SizedBox(height: 15),
//                                 Text('Output Length - '),
//                                 Text(snapshot
//                                     .child('Output Length')
//                                     .value
//                                     .toString()),
//                                 SizedBox(height: 15),
//                                 Text('Location - '),
//                                 Text(snapshot
//                                     .child('Location')
//                                     .value
//                                     .toString()),
//                                 SizedBox(height: 15),
//                                 Text('Time - '),
//                                 Text(snapshot.child('Time').value.toString()),
//                               ],
//                             )

//                             //title:
//                             ),
//                       );
//                     }))
//           ]),
//         ));
//   }
// }

// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:iotrealtimedatameasure/fetch_data.dart';
// // //import 'package:flutter_firebase_series/screens/insert_data.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   Firebase.initializeApp();
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: const MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({Key? key}) : super(key: key);

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Flutter Firebase'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: <Widget>[
// //             const Image(
// //               width: 300,
// //               height: 300,
// //               image: NetworkImage(
// //                   'https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png'),
// //             ),
// //             const SizedBox(
// //               height: 30,
// //             ),
// //             const Text(
// //               'Firebase Realtime Database Series in Flutter 2022',
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(
// //               height: 30,
// //             ),
// //             MaterialButton(
// //               onPressed: () {
// //                 // Navigator.push(
// //                 //     context,
// //                 //     MaterialPageRoute(
// //                 //         builder: (context) => const InsertData()));
// //               },
// //               child: const Text('Insert Data'),
// //               color: Colors.blue,
// //               textColor: Colors.white,
// //               minWidth: 300,
// //               height: 40,
// //             ),
// //             const SizedBox(
// //               height: 30,
// //             ),
// //             MaterialButton(
// //               onPressed: () {
// //                 Navigator.push(context,
// //                     MaterialPageRoute(builder: (context) => const FetchData()));
// //               },
// //               child: const Text('Fetch Data'),
// //               color: Colors.blue,
// //               textColor: Colors.white,
// //               minWidth: 300,
// //               height: 40,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

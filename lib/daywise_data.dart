import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DayWiseDataScreen extends StatefulWidget {
  const DayWiseDataScreen({super.key});

  @override
  _DayWiseDataScreenState createState() => _DayWiseDataScreenState();
}

class _DayWiseDataScreenState extends State<DayWiseDataScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('Device 01').child('Day');
  String searchYear = '';
  String searchMonth = '';
  String searchDay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dates",
          textScaleFactor: 0.8,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No data available.'));
          }

          final dayData =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final dates = dayData.keys.toList();

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              return Card(
                elevation: 0, // Adjust the elevation as needed
                color: const Color.fromARGB(198, 235, 234, 239),
                //shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                ),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: ListTile(
                  title: Text(date),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubNodesListScreen(date: date),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Year'),
                onChanged: (value) {
                  setState(() {
                    searchYear = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Month'),
                onChanged: (value) {
                  setState(() {
                    searchMonth = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Day'),
                onChanged: (value) {
                  setState(() {
                    searchDay = value;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch() async {
    List<String> filteredDates = [];

    final dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child('Device 01')
        .child('Day')
        .once();

    final dayData = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

    dayData.forEach((date, _) {
      final dateParts = date.split(' ');
      final year = dateParts[0];
      final month = dateParts[1];
      final day = dateParts[2];

      bool matchesYear = searchYear.isEmpty || year == searchYear;
      bool matchesMonth = searchMonth.isEmpty || month == searchMonth;
      bool matchesDay = searchDay.isEmpty || day == searchDay;

      if (matchesYear && matchesMonth && matchesDay) {
        filteredDates.add(date);
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilteredDayWiseDataScreen(filteredDates: filteredDates),
      ),
    );
  }
}

// class SubNodesListScreen extends StatelessWidget {
//   final String date;
//   final DatabaseReference databaseReference;

//   SubNodesListScreen({required this.date})
//       : databaseReference = FirebaseDatabase.instance
//             .reference()
//             .child('Device 01')
//             .child('Day')
//             .child(date);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$date'),
//       ),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final dayData =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//           return FutureBuilder(
//             future: FirebaseFirestore.instance
//                 .collection(date) // Use your Firestore collection path
//                 .orderBy('order')
//                 .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text('No data available.'));
//               }

//               final firestoreDocs = snapshot.data!.docs;
//               final firestoreData = Map.fromIterable(
//                 firestoreDocs,
//                 key: (doc) => doc['order'],
//                 value: (doc) => doc,
//               );

//               return ListView.builder(
//                 itemCount: dayData.length,
//                 itemBuilder: (context, index) {
//                   final subNodeKey = dayData.keys.toList()[index];
//                   final subNode = dayData[subNodeKey] as Map<dynamic, dynamic>;
//                   final groupKey = subNode['groupkey'];

//                   return FutureBuilder(
//                     future: FirebaseFirestore.instance
//                         .collection(date) // Use your Firestore collection path
//                         .where('order', isEqualTo: groupKey)
//                         .limit(1)
//                         .get(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return SizedBox.shrink(); // Hide the ListTile
//                       }

//                       final firestoreDoc = snapshot.data!.docs.first;
//                       String name = firestoreDoc['name'];

//                       return ListTile(
//                         title: Text(name),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SubNodeDetailsScreen(
//                                 date: date,
//                                 subNodeKey: subNodeKey,
//                                 subNode: subNode,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class SubNodesListScreen extends StatelessWidget {
  final String date;
  final DatabaseReference databaseReference;

  SubNodesListScreen({super.key, required this.date})
      : databaseReference = FirebaseDatabase.instance
            .ref()
            .child('Device 01')
            .child('Day')
            .child(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 80),
            Text(
              date,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        //title: Text('$date'),
      ),
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No data available.'));
          }

          final dayData =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView.builder(
            itemCount: dayData.length,
            itemBuilder: (context, index) {
              final subNodeKey = dayData.keys.toList()[index];
              final subNode = dayData[subNodeKey] as Map<dynamic, dynamic>;

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(date) // Use your Firestore collection path
                    .where('order', isEqualTo: subNode['groupkey'])
                    .limit(1)
                    .get(),
                builder: (context, firestoreSnapshot) {
                  if (firestoreSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!firestoreSnapshot.hasData ||
                      firestoreSnapshot.data!.docs.isEmpty) {
                    return Card(
                      elevation: 0, // Adjust the elevation as needed
                      color: const Color.fromARGB(198, 235, 234, 239),
                      //shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      child: ListTile(
                        title: Text(subNodeKey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubNodeDetailsScreen(
                                date: date,
                                subNodeKey: subNodeKey,
                                subNode: subNode,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  final firestoreDoc = firestoreSnapshot.data!.docs.first;
                  String name = firestoreDoc['name'];

                  return Card(
                    elevation: 0, // Adjust the elevation as needed
                    color: const Color.fromARGB(198, 235, 234, 239),
                    //shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the radius as needed
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: ListTile(
                      title: Text(name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubNodeDetailsScreen(
                              date: date,
                              subNodeKey: name,
                              subNode: subNode,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SubNodeDetailsScreen extends StatelessWidget {
  final String date;
  final String subNodeKey;
  final Map<dynamic, dynamic> subNode;

  const SubNodeDetailsScreen(
      {super.key, required this.date, required this.subNodeKey, required this.subNode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 140),
            Text(
              subNodeKey,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // title: Text('$subNodeKey'),
      ),
      body: ListView.builder(
        itemCount: subNode.length,
        itemBuilder: (context, index) {
          final key = subNode.keys.toList()[index];
          final value = subNode[key];
          return ListTile(
              titleTextStyle: const TextStyle(
                fontSize: 20,

                //backgroundColor: const Color.fromARGB(255, 218, 126, 126)
              ),
              title:
                  //SizedBox(width: 100),
                  //Color: Colors.white,
                  Text('$key:  $value',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 6, 6, 6),
                      )));
        },
      ),
    );
  }
}

class FilteredDayWiseDataScreen extends StatelessWidget {
  final List<String> filteredDates;

  const FilteredDayWiseDataScreen({super.key, required this.filteredDates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 80),
            const Text(
              'Filtered Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        //title: Text('Filtered Day Wise Data'),
      ),
      body: ListView.builder(
        itemCount: filteredDates.length,
        itemBuilder: (context, index) {
          final date = filteredDates[index];
          return Card(
            elevation: 0, // Adjust the elevation as needed
            color: const Color.fromARGB(198, 235, 234, 239),
            //shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Adjust the radius as needed
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: ListTile(
              title: Text(date),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubNodesListScreen(date: date),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//------------------------------------------UPDATED ERROR FIX NOT REPLACING NAME-------------------------------------------------

// class DayWiseDataScreen extends StatefulWidget {
//   @override
//   _DayWiseDataScreenState createState() => _DayWiseDataScreenState();
// }

// class _DayWiseDataScreenState extends State<DayWiseDataScreen> {
//   final DatabaseReference databaseReference =
//       FirebaseDatabase.instance.reference().child('Device 01').child('Day');
//   String searchYear = '';
//   String searchMonth = '';
//   String searchDay = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         foregroundColor: Color.fromARGB(255, 0, 0, 0),
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () => _showSearchDialog(context),
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final dayData =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           final dates = dayData.keys.toList();
//           dates.sort(); // Sort the dates in ascending order

//           return ListView.builder(
//             itemCount: dates.length,
//             itemBuilder: (context, index) {
//               final date = dates[index];
//               return ListTile(
//                 title: Text(date),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SubNodesListScreen(date: date),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showSearchDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Search Date'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Year'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchYear = value;
//                   });
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Month'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchMonth = value;
//                   });
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Day'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchDay = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _performSearch();
//               },
//               child: Text('Search'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performSearch() async {
//     List<String> filteredDates = [];

//     final dataSnapshot = await FirebaseDatabase.instance
//         .ref()
//         .child('Device 01')
//         .child('Day')
//         .once();

//     final dayData = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

//     dayData.forEach((date, _) {
//       final dateParts = date.split(' ');
//       final year = dateParts[0];
//       final month = dateParts[1];
//       final day = dateParts[2];

//       bool matchesYear = searchYear.isEmpty || year == searchYear;
//       bool matchesMonth = searchMonth.isEmpty || month == searchMonth;
//       bool matchesDay = searchDay.isEmpty || day == searchDay;

//       if (matchesYear && matchesMonth && matchesDay) {
//         filteredDates.add(date);
//       }
//     });

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             FilteredDayWiseDataScreen(filteredDates: filteredDates),
//       ),
//     );
//   }
// }

// class SubNodesListScreen extends StatelessWidget {
//   final String date;
//   final DatabaseReference databaseReference;

//   SubNodesListScreen({required this.date})
//       : databaseReference = FirebaseDatabase.instance
//             .ref()
//             .child('Device 01')
//             .child('Day')
//             .child(date);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$date'),
//       ),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final dayData =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           final subNodeKeys = dayData.keys.toList();
//           subNodeKeys.sort(); // Sort the sub-node keys in ascending order

//           return ListView.builder(
//             itemCount: subNodeKeys.length,
//             itemBuilder: (context, index) {
//               final subNodeKey = subNodeKeys[index];
//               final subNode = dayData[subNodeKey] as Map<dynamic, dynamic>;
//               return ListTile(
//                 title: Text(subNodeKey),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     for (final entry in subNode.entries)
//                       Text('${entry.key}: ${entry.value}'),
//                     SizedBox(height: 8),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

// }

// class FilteredDayWiseDataScreen extends StatelessWidget {
//   final List<String> filteredDates;

//   FilteredDayWiseDataScreen({required this.filteredDates});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filtered Day Wise Data'),
//       ),
//       body: ListView.builder(
//         itemCount: filteredDates.length,
//         itemBuilder: (context, index) {
//           final date = filteredDates[index];
//           return ListTile(
//             title: Text(date),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubNodesListScreen(date: date),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

//-------------------------------------------------END-----------------------------------------------






// class DayWiseDataScreen extends StatefulWidget {
//   @override
//   _DayWiseDataScreenState createState() => _DayWiseDataScreenState();
// }

// class _DayWiseDataScreenState extends State<DayWiseDataScreen> {
//   final DatabaseReference databaseReference =
//       FirebaseDatabase.instance.reference().child('Device 01').child('Day');
//   String searchYear = '';
//   String searchMonth = '';
//   String searchDay = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         foregroundColor: Color.fromARGB(255, 0, 0, 0),
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () => _showSearchDialog(context),
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final dayData =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           final dates = dayData.keys.toList();

//           return ListView.builder(
//             itemCount: dates.length,
//             itemBuilder: (context, index) {
//               final date = dates[index];
//               return ListTile(
//                 title: Text(date),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SubNodesListScreen(date: date),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showSearchDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Search Date'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Year'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchYear = value;
//                   });
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Month'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchMonth = value;
//                   });
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Day'),
//                 onChanged: (value) {
//                   setState(() {
//                     searchDay = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _performSearch();
//               },
//               child: Text('Search'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performSearch() async {
//     List<String> filteredDates = [];

//     final dataSnapshot = await FirebaseDatabase.instance
//         .ref()
//         .child('Device 01')
//         .child('Day')
//         .once();

//     final dayData = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

//     dayData.forEach((date, _) {
//       final dateParts = date.split(' ');
//       final year = dateParts[0];
//       final month = dateParts[1];
//       final day = dateParts[2];

//       bool matchesYear = searchYear.isEmpty || year == searchYear;
//       bool matchesMonth = searchMonth.isEmpty || month == searchMonth;
//       bool matchesDay = searchDay.isEmpty || day == searchDay;

//       if (matchesYear && matchesMonth && matchesDay) {
//         filteredDates.add(date);
//       }
//     });

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             FilteredDayWiseDataScreen(filteredDates: filteredDates),
//       ),
//     );
//   }
// }

// class SubNodesListScreen extends StatelessWidget {
//   final String date;
//   final DatabaseReference databaseReference;

//   SubNodesListScreen({required this.date})
//       : databaseReference = FirebaseDatabase.instance
//             .reference()
//             .child('Device 01')
//             .child('Day')
//             .child(date);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$date'),
//       ),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final dayData =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//           return ListView.builder(
//             itemCount: dayData.length,
//             itemBuilder: (context, index) {
//               final subNodeKey = dayData.keys.toList()[index];
//               final subNode = dayData[subNodeKey] as Map<dynamic, dynamic>;
//               return ListTile(
//                 title: Text(subNodeKey),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SubNodeDetailsScreen(
//                           date: date, subNodeKey: subNodeKey, subNode: subNode),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class SubNodeDetailsScreen extends StatelessWidget {
//   final String date;
//   final String subNodeKey;
//   final Map<dynamic, dynamic> subNode;

//   SubNodeDetailsScreen(
//       {required this.date, required this.subNodeKey, required this.subNode});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: subNode.length,
//         itemBuilder: (context, index) {
//           final key = subNode.keys.toList()[index];
//           final value = subNode[key];
//           return ListTile(
//             title: Text('$key: $value'),
//             onTap: () async {
//               if (key == 'groupkey') {
//                 String updatedName = await showDialog(
//                   context: context,
//                   builder: (context) {
//                     TextEditingController controller = TextEditingController();
//                     controller.text = value;
//                     return AlertDialog(
//                       title: Text('Update Fabric Name'),
//                       content: TextField(
//                         controller: controller,
//                         decoration: InputDecoration(labelText: 'Name'),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(controller.text);
//                           },
//                           child: Text('Update'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//                 if (updatedName != null && updatedName.isNotEmpty) {
//                   _updateFabricName(subNodeKey, date, updatedName);
//                 }
//               }
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _updateFabricName(
//       String subNodeKey, String subNodeDate, String newName) async {
//     final firestoreDocRef =
//         FirebaseFirestore.instance.collection(subNodeDate).doc(subNodeKey);

//     firestoreDocRef.update({'name': newName});
//   }
// }

// class FilteredDayWiseDataScreen extends StatelessWidget {
//   final List<String> filteredDates;

//   FilteredDayWiseDataScreen({required this.filteredDates});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filtered Day Wise Data'),
//       ),
//       body: ListView.builder(
//         itemCount: filteredDates.length,
//         itemBuilder: (context, index) {
//           final date = filteredDates[index];
//           return ListTile(
//             title: Text(date),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubNodesListScreen(date: date),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        title: Text(
          "Dates".tr,
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
            return Center(child: Text('No items to display'.tr));
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
          title: Text('Search Date'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Year'.tr),
                onChanged: (value) {
                  setState(() {
                    searchYear = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Month'.tr),
                onChanged: (value) {
                  setState(() {
                    searchMonth = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Day'.tr),
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
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch();
              },
              child: Text('Search'.tr),
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
            const SizedBox(width: 80),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
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
            return Center(child: Text('No items to display'.tr));
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
      {super.key,
      required this.date,
      required this.subNodeKey,
      required this.subNode});

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
                  'Filtered Data'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

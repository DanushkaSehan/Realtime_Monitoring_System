import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FabricScreen extends StatefulWidget {
  const FabricScreen({super.key});

  @override
  _FabricScreenState createState() => _FabricScreenState();
}

class _FabricScreenState extends State<FabricScreen> {
  final TextEditingController _fabricNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _addFabric(String fabricName, DateTime date) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_getCurrentDateFormatted())
        .orderBy('order')
        .get();

    int order = snapshot.docs.length + 1;

    await _firestore.collection(_getCurrentDateFormatted()).add({
      'name': fabricName,
      'date': date,
      'order': order,
    });

    _fabricNameController.clear();
    _refreshData();
  }

  Future<void> _clearListAndReset() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear List and Reset'),
          content: const Text(
              'Are you sure you want to clear the list and start a new one?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      QuerySnapshot snapshot =
          await _firestore.collection(_getCurrentDateFormatted()).get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      // Update the order for the filtered fabrics
      for (int i = 0; i < docs.length; i++) {
        await docs[i].reference.update({'order': i + 1});
      }

      _refreshData();
    }
  }

  Future<void> _editFabric(DocumentReference reference, String newName) async {
    await reference.update({'name': newName});
    _refreshData();
  }

  Future<void> _deleteFabric(DocumentReference reference) async {
    await reference.delete();
    _refreshData();
  }

  void _refreshData() {
    setState(() {});
  }

  String _getCurrentDateFormatted() {
    DateTime now = DateTime.now();
    return '${now.year} ${now.month} ${now.day}';
  }

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
              'Fabric Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          50), // Adjust the radius as needed
                      color: const Color.fromARGB(
                          93, 20, 20, 20), // Background color of the container
                    ),
                    child: TextField(
                      controller: _fabricNameController,
                      decoration: const InputDecoration(
                        hoverColor: Colors.black26,
                        hintText: 'Fabric Name',
                        border: InputBorder.none, // Hide the default border
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    DateTime date = DateTime.now();
                    _addFabric(_fabricNameController.text, date);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection(_getCurrentDateFormatted())
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items to display.'));
                }

                final fabrics = snapshot.data!.docs;
                return ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    setState(() {
                      final fabric = fabrics.removeAt(oldIndex);
                      fabrics.insert(newIndex, fabric);
                      _updateFabricOrder(fabrics);
                    });
                  },
                  children: fabrics.map((fabric) {
                    final docId = fabric.id;
                    final fabricName = fabric['name'];
                    final order = fabric['order'];
                    final date = (fabric['date'] as Timestamp).toDate();
                    final fabricReference = fabric.reference;
                    return ReorderableDelayedDragStartListener(
                        key: Key(docId), // Use the ListTile's Key
                        index: fabrics.indexOf(fabric),
                        child: Card(
                            child: Card(
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
                            key: Key(docId),
                            title: Text('$order. $fabricName '),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    String editedName = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController controller =
                                            TextEditingController();
                                        controller.text = fabricName;
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Adjust the radius as needed
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          title: const Text('Edit Fabric Name'),
                                          content: TextField(
                                            controller: controller,
                                            decoration: const InputDecoration(
                                                labelText: 'Name'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(controller.text);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (editedName.isNotEmpty) {
                                      _editFabric(fabricReference, editedName);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    bool confirmed = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Adjust the radius as needed
                                          ),
                                          title:
                                              const Text('Delete Confirmation'),
                                          content: const Text(
                                              'Do you want to delete this fabric ?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed == true) {
                                      _deleteFabric(fabricReference);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )));
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateFabricOrder(List<DocumentSnapshot> fabrics) async {
    for (int i = 0; i < fabrics.length; i++) {
      await fabrics[i].reference.update({'order': i + 1});
    }
  }
}

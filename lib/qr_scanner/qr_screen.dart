import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  TextEditingController _textEditingController = TextEditingController();
  bool _isScanning = true;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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

    _textEditingController.clear();
  }

  String _getCurrentDateFormatted() {
    DateTime now = DateTime.now();
    return '${now.year} ${now.month} ${now.day}';
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
            const SizedBox(width: 80),
            Flexible(
              child: Container(
                child: Text(
                  'Qr Scanner',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildQrView(context),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Scanned QR Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isScanning ? _startScanning : _scanAgain,
                    child: Text(_isScanning ? 'Start Scanning' : 'Scan Again'),
                  ),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _addFabric(
                        _textEditingController.text,
                        DateTime.now(),
                      );
                    },
                    child: Text('Add Fabric'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller.scannedDataStream.listen((scanData) {
      setState(() {
        _textEditingController.text = scanData.code!;
        _isScanning = false;
      });
    });
  }

  void _startScanning() {
    _controller?.resumeCamera();
    setState(() {
      _isScanning = true;
      _textEditingController.clear();
    });
  }

  void _scanAgain() {
    _controller?.resumeCamera();
    setState(() {
      _isScanning = true;
      _textEditingController.clear();
    });
  }
}

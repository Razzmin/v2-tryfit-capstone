// edit_body_measurement.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart'; // keep your import

class EditBodyMeasurement extends StatefulWidget {
  const EditBodyMeasurement({super.key});

  @override
  State<EditBodyMeasurement> createState() => _EditBodyMeasurementState();
}

class _EditBodyMeasurementState extends State<EditBodyMeasurement> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();

  bool _showSuccessPopup = false;
  bool _loading = true;
  String? _docId; // reference to Firestore document if it already exists

  final _auth = FirebaseAuth.instance;
  final _fire = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() => _loading = false);
        return;
      }

      final query = await _fire
          .collection('measurements')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        _docId = doc.id;
        final data = doc.data();
        _heightController.text = (data['height'] ?? '').toString();
        _weightController.text = (data['weight'] ?? '').toString();
        _waistController.text = (data['waist'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Error loading measurements: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveMeasurements() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();
    final waist = _waistController.text.trim();

    final data = {
      'height': height,
      'weight': weight,
      'waist': waist,
      'userId': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      if (_docId != null) {
        // Update existing document
        await _fire
            .collection('measurements')
            .doc(_docId)
            .set(data, SetOptions(merge: true));
      } else {
        // Create a new document
        final newDoc = await _fire.collection('measurements').add(data);
        _docId = newDoc.id;
      }

      setState(() {
        _showSuccessPopup = true;
      });
    } catch (e) {
      debugPrint('Error saving measurements: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save measurements.')),
      );
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _waistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              // MAIN CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Body Measurement',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 24), // for spacing symmetry
                      ],
                    ),

                    const SizedBox(height: 30),

                    // FORM FIELDS
                    const Text(
                      'Height (cm)',
                      style: TextStyle(fontSize: 15, color: Color(0xFF696969)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEDEDED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Weight (kg)',
                      style: TextStyle(fontSize: 15, color: Color(0xFF696969)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEDEDED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Waist (cm)',
                      style: TextStyle(fontSize: 15, color: Color(0xFF696969)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _waistController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEDEDED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // SAVE BUTTON
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _saveMeasurements,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9747FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // SUCCESS POPUP
            if (_showSuccessPopup)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Measurements successfully saved!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _showSuccessPopup = false;
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9747FF),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

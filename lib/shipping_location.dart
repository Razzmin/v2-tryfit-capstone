import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingLocation extends StatefulWidget {
  const ShippingLocation({Key? key}) : super(key: key);

  @override
  State<ShippingLocation> createState() => _ShippingLocationState();
}

class _ShippingLocationState extends State<ShippingLocation> {
  // -----------------------
  // Data (converted from your RN object)
  // -----------------------
  static const Map<String, List<String>> MUNICIPALITIES = {
    'Bamban': [
      'Anupul',
      'Banaba',
      'Bangcu',
      'Culubasa',
      'La Paz',
      'Lourdes',
      'San Nicolas',
      'San Pedro',
      'San Rafael',
      'San Vicente',
      'Santo Niño',
    ],
    'Capas': [
      'Aranguren',
      'Cub-cub',
      'Dolores',
      'Estrada',
      'Lawy',
      'Manga',
      'Maruglu',
      'O’Donnell',
      'Santa Juliana',
      'Santa Lucia',
      'Santa Rita',
      'Santo Domingo',
      'Santo Rosario',
      'Talaga',
    ],
    'Tarlac City': [
      'Aguso',
      'Alvindia Segundo',
      'Amucao',
      'Armenia',
      'Asturias',
      'Atioc',
      'Balanti',
      'Balete',
      'Balibago I',
      'Balibago II',
      'Balingcanaway',
      'Banaba',
      'Bantog',
      'Baras-baras',
      'Batang-batang',
      'Binauganan',
      'Bora',
      'Buenavista',
      'Buhilit',
      'Burot',
      'Calingcuan',
      'Capehan',
      'Carangian',
      'Care',
      'Central',
      'Culipat',
      'Cut-cut I',
      'Cut-cut II',
      'Dalayap',
      'Dela Paz',
      'Dolores',
      'Laoang',
      'Ligtasan',
      'Lourdes',
      'Mabini',
      'Maligaya',
      'Maliwalo',
      'Mapalacsiao',
      'Mapalad',
      'Matatalaib',
      'Paraiso',
      'Poblacion',
      'Salapungan',
      'San Carlos',
      'San Francisco',
      'San Isidro',
      'San Jose',
      'San Jose de Urquico',
      'San Juan Bautista',
      'San Juan de Mata',
      'San Luis',
      'San Manuel',
      'San Miguel',
      'San Nicolas',
      'San Pablo',
      'San Pascual',
      'San Rafael',
      'San Roque',
      'San Sebastian',
      'San Vicente',
      'Santa Cruz',
      'Santa Maria',
      'Santo Cristo',
      'Santo Domingo',
      'Santo Niño',
      'Sapang Maragul',
      'Sapang Tagalog',
      'Sepung Calzada',
      'Sinait',
      'Suizo',
      'Tariji',
      'Tibag',
      'Tibagan',
      'Trinidad',
      'Ungot',
      'Villa Bacolor',
    ],
  };

  // -----------------------
  // UI state
  // -----------------------
  String _stage = 'municipality'; // 'municipality' | 'barangay' | 'final'
  String _municipality = '';
  String _barangay = '';
  String _finalAddress = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  // -----------------------
  // Picker/item helpers
  // -----------------------
  List<DropdownMenuItem<String>> _getPickerItems() {
    if (_stage == 'municipality') {
      final items = <DropdownMenuItem<String>>[
        const DropdownMenuItem(value: '', child: Text('Select Municipality')),
      ];
      items.addAll(
        MUNICIPALITIES.keys.map(
          (m) => DropdownMenuItem(value: m, child: Text(m)),
        ),
      );
      return items;
    } else if (_stage == 'barangay') {
      final barangays = MUNICIPALITIES[_municipality] ?? [];
      final items = <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: '',
          child: Text('Select Barangay in $_municipality'),
        ),
      ];
      items.addAll(
        barangays.map((b) => DropdownMenuItem(value: b, child: Text(b))),
      );
      return items;
    } else {
      return [
        DropdownMenuItem(value: _finalAddress, child: Text(_finalAddress)),
      ];
    }
  }

  void _onPickerChanged(String? value) {
    if (value == null) return;
    setState(() {
      if (_stage == 'municipality') {
        _municipality = value;
        _stage = 'barangay';
      } else if (_stage == 'barangay') {
        _barangay = value;
        _finalAddress = '$_barangay, $_municipality, Tarlac';
        _stage = 'final';
      } else {
        // if already final, reset to start
        _municipality = '';
        _barangay = '';
        _finalAddress = '';
        _stage = 'municipality';
      }
    });
  }

  // -----------------------
  // Save with validation (local only)
  // -----------------------
  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final house = _houseController.text.trim();
    final postal = _postalController.text.trim();

    if (name.isEmpty) {
      _showAlert('Validation Error', 'Please enter the receiver name.');
      return;
    }
    if (phone.isEmpty) {
      _showAlert('Validation Error', 'Please enter the phone number.');
      return;
    }
    if (house.isEmpty) {
      _showAlert(
        'Validation Error',
        'Please enter house/street/building info.',
      );
      return;
    }
    if (_municipality.isEmpty) {
      _showAlert('Validation Error', 'Please select a municipality.');
      return;
    }
    if (_barangay.isEmpty) {
      _showAlert('Validation Error', 'Please select a barangay.');
      return;
    }
    if (postal.isEmpty) {
      _showAlert('Validation Error', 'Please enter postal code.');
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // simulate save delay
    setState(() => _saving = false);

    // Compose saved address (local only)
    final savedAddress = {
      'name': name,
      'phone': phone,
      'house': house,
      'municipality': _municipality,
      'barangay': _barangay,
      'postalCode': postal,
      'fullAddress': '$_barangay, $_municipality, Tarlac',
      'createdAt': DateTime.now().toIso8601String(),
    };

    // show success then pop
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Shipping location saved successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF9747FF))),
          ),
        ],
      ),
    );

    // You can pass savedAddress back if needed:
    Navigator.of(context).pop(savedAddress);
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF9747FF))),
          ),
        ],
      ),
    );
  }

  // -----------------------
  // Build
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Shipping Location',
                        style: GoogleFonts.kronaOne(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    'Name (Receiver)',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Enter name',
                  ),

                  const SizedBox(height: 10),

                  // Phone
                  Text(
                    'Phone Number',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _phoneController,
                    hint: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 10),

                  // House
                  Text(
                    'House No., Street / Building',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _houseController,
                    hint: 'e.g., 225, Purok Alpha',
                  ),

                  const SizedBox(height: 10),

                  // Address Picker
                  Text(
                    'Address',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _stage == 'municipality'
                            ? (_municipality.isEmpty ? '' : _municipality)
                            : _stage == 'barangay'
                            ? (_barangay.isEmpty ? '' : _barangay)
                            : _finalAddress,
                        items: _getPickerItems(),
                        onChanged: (v) => _onPickerChanged(v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Postal Code
                  Text(
                    'Postal Code',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _postalController,
                    hint: 'Enter postal code',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Save button fixed at bottom
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9747FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _saving
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
      ),
    );
  }
}

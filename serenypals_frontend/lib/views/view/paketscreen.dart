import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';

class PackageSelectionScreen extends StatefulWidget {
  const PackageSelectionScreen({super.key});

  @override
  State<PackageSelectionScreen> createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  int _selectedPackageIndex = -1; // 0 for 1 bulan, 1 for 3 bulan, 2 for 1 tahun

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        backgroundColor: color4,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('Back button pressed');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Image (Bear with Boba)
            Image.asset(
              'assets/img/bear_boba.png',
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),

            // "SerenyPremium" Text
            Text(
              'SerenyPremium',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // Features List (Konseling & ChatBot)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildFeatureRow(
                      Icons.check_circle, 'Konseling dengan Psikiater'),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:
                      _buildFeatureRow(Icons.check_circle, 'Unlimited ChatBot'),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Package Options (1 bulan, 3 bulan, 1 tahun)
            _buildPackageOption(context, '1 bulan', 'Rp 80.000', 0),
            const SizedBox(height: 20),
            _buildPackageOption(context, '3 bulan', 'Rp 220.000', 1),
            const SizedBox(height: 20),
            _buildPackageOption(context, '1 tahun', 'Rp 560.000', 2),
            const SizedBox(height: 40),

            // "Beli Paket" Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPackageIndex != -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    print(
                        'Beli Paket button pressed for package index: $_selectedPackageIndex');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih paket terlebih dahulu!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    print('No package selected.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Beli Paket',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget to build a feature row (checkmark icon + text)
  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper Widget to build a package option button/card - MODIFIED FOR NEW COLOR LOGIC
  Widget _buildPackageOption(
      BuildContext context, String duration, String price, int index) {
    // Determine background color based on selection
    final bool isSelected = _selectedPackageIndex == index;
    // --- KEY CHANGE HERE ---
    // Use _selectedPackageColor (new color6) if selected,
    // otherwise use _unselectedPackageColor (new color7).
    final Color cardBackgroundColor = isSelected ? color5 : color6;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackageIndex = index;
        });
        print('$duration package selected (index: $index)');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color:
              cardBackgroundColor, // This will now correctly apply the full background color
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              duration,
              style: const TextStyle(
                color: Colors.black, // Text color is white for both states
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.black, // Text color is white for both states
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

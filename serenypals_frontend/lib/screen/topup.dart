import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';

class DiamondTopUpPage extends StatefulWidget {
  const DiamondTopUpPage({super.key});

  @override
  State<DiamondTopUpPage> createState() => _DiamondTopUpPageState();
}

class _DiamondTopUpPageState extends State<DiamondTopUpPage> {
  int? selectedIndex;
  final List<DiamondPackage> packages = [
    DiamondPackage(10, 6000, 38000, discountPercent: 20, bonus: "10 koin"),
    DiamondPackage(88, 17600, 22000, discountPercent: 20, bonus: "10 koin"),
    DiamondPackage(158, 34500, 46000, discountPercent: 25, bonus: "10 koin"),
    DiamondPackage(389, 76000, 95000, discountPercent: 20, bonus: "10 koin"),
    DiamondPackage(699, 87000, 116000, discountPercent: 25, bonus: "10 koin"),
    DiamondPackage(1158, 276800, 346000, discountPercent: 20, bonus: "10 koin"),
  ];

  void _showConfirmationDialog(DiamondPackage package) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Pembelian"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${package.diamond} Diamond",
                  style: GoogleFonts.overlock(fontWeight: FontWeight.bold),
                ),
                Text("Rp${_formatNumber(package.discountedPrice)}"),
                if (package.bonus != null) Text("Bonus: ${package.bonus}"),
                const SizedBox(height: 10),
                const Text("Apakah Anda yakin ingin membeli ini?"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Berhasil membeli ${package.diamond} Diamond!",
                      ),
                    ),
                  );
                },
                child: Text(
                  "Beli",
                  style: GoogleFonts.overlock(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        backgroundColor: color4,
        centerTitle: true, // Ini membuat title di tengah
        title: Text(
          'SerenyPals',
          style: GoogleFonts.overlock(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),

      body: Stack(
        children: [
          // Konten scrollable
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 150,
            ), // Beri jarak bawah agar tidak ketiban
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Manjakan Petmu Agar Makin Imut!',
                      style: GoogleFonts.overlock(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/img/capybara1.png',
                        width: 80,
                        height: 80,
                      ),
                      Image.asset(
                        'assets/img/capybara2.png',
                        width: 80,
                        height: 80,
                      ),
                      Image.asset(
                        'assets/img/capybara3.png',
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1, // lebih proporsional
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: packages.length,
                    itemBuilder:
                        (context, index) => DiamondCard(
                          package: packages[index],
                          isSelected: selectedIndex == index,
                          onTap: () => setState(() => selectedIndex = index),
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol beli di bawah, selalu tampil
          if (selectedIndex != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5E3EA),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${packages[selectedIndex!].diamond} Diamond',
                          style: GoogleFonts.overlock(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Rp ${_formatNumber(packages[selectedIndex!].discountedPrice)}',
                          style: GoogleFonts.overlock(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        _showConfirmationDialog(packages[selectedIndex!]);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9FB3DF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'Beli Diamond',
                            style: GoogleFonts.overlock(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
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
}

class DiamondCard extends StatelessWidget {
  final DiamondPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const DiamondCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBFACE2) : const Color(0xFFEBC7E6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset('assets/img/diamond.png', width: 60, height: 60),
                  const SizedBox(height: 10),
                  Text(
                    '${package.diamond} Diamond',
                    style: GoogleFonts.overlock(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  if (package.originalPrice != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Rp${_formatNumber(package.originalPrice!)}',
                          style: GoogleFonts.overlock(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${package.discountPercent}%',
                            style: GoogleFonts.overlock(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Text(
                    'Rp${_formatNumber(package.discountedPrice)}',
                    style: GoogleFonts.overlock(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (package.bonus != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        package.bonus!,
                        style: GoogleFonts.overlock(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class DiamondPackage {
  final int diamond;
  final int discountedPrice;
  final int? originalPrice;
  final String? bonus;
  final int discountPercent;

  DiamondPackage(
    this.diamond,
    this.discountedPrice,
    this.originalPrice, {
    required this.discountPercent,
    this.bonus,
  });
}

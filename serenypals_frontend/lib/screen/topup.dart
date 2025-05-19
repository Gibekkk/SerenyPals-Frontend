import 'package:flutter/material.dart';

void main() => runApp(const Mytino());

class Mytino extends StatelessWidget {
  const Mytino({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const DiamondTopUpPage(),
    );
  }
}

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
    DiamondPackage(389, 76000, 95000, discountPercent: 20, bonus: "10 koin"),
  ];

  void _showConfirmationDialog(DiamondPackage package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Pembelian"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${package.diamond} Diamond",
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  content: Text("Berhasil membeli ${package.diamond} Diamond!"),
                ),
              );
            },
            child: const Text("Beli", style: TextStyle(color: Colors.red)),
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
      backgroundColor: const Color(0xFFFFF1D5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'SerenyShop',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Manjakan Petmu Agar Makin Imut!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/img/capybara1.png', width: 80, height: 80),
                Image.asset('assets/img/capybara2.png', width: 80, height: 80),
                Image.asset('assets/img/capybara3.png', width: 80, height: 80),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: packages.length,
                itemBuilder: (context, index) => DiamondCard(
                  package: packages[index],
                  isSelected: selectedIndex == index,
                  onTap: () => setState(() => selectedIndex = index),
                ),
              ),
            ),

            // HANYA 1 tombol Beli di sini
            if (selectedIndex != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5E3EA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${packages[selectedIndex!].diamond} Diamond',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Rp ${_formatNumber(packages[selectedIndex!].discountedPrice)}',
                          style: const TextStyle(
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
                        child: const Center(
                          child: Text(
                            'Beli Diamond',
                            style: TextStyle(
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
          ],
        ),
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
          color: isSelected
              ? const Color(0xFFBFACE2)
              : const Color(0xFFEBC7E6),
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
                  Image.asset(
                    'assets/img/diamond.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${package.diamond} Diamond',
                    style: const TextStyle(
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
                          style: TextStyle(
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
                            style: const TextStyle(
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (package.bonus != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        package.bonus!,
                        style: const TextStyle(
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

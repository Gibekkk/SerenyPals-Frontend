import 'package:flutter/material.dart';
import 'package:serenypals_frontend/utils/color.dart';

class FastSupportSection extends StatefulWidget {
  const FastSupportSection({super.key});

  @override
  State<FastSupportSection> createState() => _FastSupportSectionState();
}

class _FastSupportSectionState extends State<FastSupportSection> {
  late final PageController _pageController;
  bool _didAnimate = false;

  final List<SupportItem> supports = [
    SupportItem(
      title: 'Serenychat',
      description: 'Ceritakan keluh kesahmu ke AI Konselor',
      icon: Icons.auto_awesome,
      backgroundColor: color3,
      buttonText: 'Chat Sekarang',
    ),
    SupportItem(
      title: 'Psikiater',
      description: 'Konsultasi langsung dengan psikiater',
      imageAssetPath: 'assets/img/konsultasi.png',
      backgroundColor: color7,
      buttonText: 'Chat Sekarang',
    ),
  ];
  @override
  void initState() {
    super.initState();

    // Tambahkan viewportFraction di sini
    _pageController = PageController(viewportFraction: 1);

    // Opsional: swipe hint animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didAnimate && supports.length > 1) {
        _animateSwipeHint();
        _didAnimate = true;
      }
    });
  }

  Future<void> _animateSwipeHint() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      await _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      // Controller mungkin sudah di-dispose
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Fast Support',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Icon(Icons.swipe, size: 18, color: Colors.grey),
              SizedBox(width: 4),
              Text('geser', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: PageView.builder(
              padEnds: false,
              controller: _pageController,
              itemCount: supports.length,
              itemBuilder: (context, index) {
                return _SupportCard(
                  item: supports[index],
                  onPressed: () {
                    if (supports[index].title == 'Serenychat') {
                      // Navigasi ke fitur AI Konselor
                    } else if (supports[index].title == 'Psikiater') {
                      // Navigasi ke halaman Psikiater
                    }
                  },
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SupportItem {
  final String title;
  final String description;
  final IconData? icon; // Boleh null
  final String? imageAssetPath; // Boleh null
  final Color backgroundColor;
  final String buttonText;

  SupportItem({
    required this.title,
    required this.description,
    this.icon,
    this.imageAssetPath,
    required this.backgroundColor,
    required this.buttonText,
  }) : assert(
         icon != null || imageAssetPath != null,
         'Either icon or imageAssetPath must be provided',
       );
}

class _SupportCard extends StatelessWidget {
  final SupportItem item;
  final VoidCallback onPressed;
  final int index;

  const _SupportCard({
    required this.item,
    required this.onPressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child:
                item.icon != null
                    ? Icon(item.icon, color: Colors.black, size: 40)
                    : Image.asset(
                      item.imageAssetPath!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    item.buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

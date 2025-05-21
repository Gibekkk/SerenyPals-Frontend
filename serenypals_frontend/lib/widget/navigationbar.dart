import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/utils/fabaction.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentTab;
  final ValueChanged<int> onTabChanged;
  final bool isFabExpanded;
  final ValueChanged<bool> onFabToggle;
  final FabAction fabAction;
  final ValueChanged<FabAction> onFabActionChange;
  final List<Widget> children;
  final Color fabColor;
  final Color fabAIColor;
  final Color fabPsikiaterColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    required this.isFabExpanded,
    required this.onFabToggle,
    required this.fabAction,
    required this.onFabActionChange,
    required this.children,
    required this.fabColor,
    required this.fabAIColor,
    required this.fabPsikiaterColor,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.children.first,
      floatingActionButton: SizedBox.expand(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // FAB AI Assistant
            Positioned(
              bottom: 100,
              left: 0,
              right: 110,
              child: IgnorePointer(
                ignoring: !widget.isFabExpanded,
                child: AnimatedOpacity(
                  opacity: widget.isFabExpanded ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: widget.fabAIColor,
                        onPressed: () => widget.onFabActionChange(FabAction.ai),
                        child: Image.asset(
                          'assets/img/ai.png', // pastikan ekstensinya PNG
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI Assistant',
                        style: GoogleFonts.overlock(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // FAB Psikiater
            Positioned(
              bottom: 100,
              right: 0,
              left: 110,
              child: IgnorePointer(
                ignoring: !widget.isFabExpanded,
                child: AnimatedOpacity(
                  opacity: widget.isFabExpanded ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: widget.fabPsikiaterColor,
                        onPressed:
                            () => widget.onFabActionChange(FabAction.psikiater),
                        child: Image.asset(
                          'assets/img/konsultasi.png', // pastikan ekstensinya PNG
                          width: 50,
                          height: 50,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        'Psikiater',
                        style: GoogleFonts.overlock(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main FAB
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        backgroundColor: widget.fabColor,
                        onPressed:
                            () => widget.onFabToggle(!widget.isFabExpanded),
                        child: Center(
                          child:
                              widget.isFabExpanded
                                  ? SvgPicture.asset(
                                    'assets/img/close.svg',
                                    width: 24,
                                    height: 24,
                                  )
                                  : Image.asset(
                                    'assets/img/konsultasifab.png',
                                    width: 70,
                                    height: 70,
                                  ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      widget.isFabExpanded ? 'Tutup' : 'Konsultasi',
                      style: GoogleFonts.overlock(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: color1,
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navButton(
                  icon: 'assets/img/Dashboard.svg',
                  label: 'Dashboard',
                  index: 0,
                ),
                navButton(
                  icon: 'assets/img/sharingforum.svg',
                  label: 'Forum',
                  index: 1,
                ),
                const SizedBox(width: 20),
                navButton(
                  icon: 'assets/img/Diary.svg',
                  label: 'My Diary',
                  index: 2,
                ),
                navButton(
                  icon: 'assets/img/Profile.svg',
                  label: 'Profil',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navButton({
    required String icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => widget.onTabChanged(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 30,
            height: 30,
            color: widget.currentTab == index ? color5 : color4,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.overlock(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

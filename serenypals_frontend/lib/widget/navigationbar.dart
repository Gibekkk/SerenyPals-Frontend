import 'package:flutter/material.dart';
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
      body: IndexedStack(index: widget.currentTab, children: widget.children),
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
                        child: const Icon(Icons.smart_toy),
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
                        child: const Icon(Icons.person),
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
                        child: Icon(
                          widget.isFabExpanded ? Icons.close : Icons.add,
                        ),
                        onPressed:
                            () => widget.onFabToggle(!widget.isFabExpanded),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Konsultasi',
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
                navButton(icon: Icons.dashboard, label: 'Dashboard', index: 0),
                navButton(icon: Icons.forum, label: 'Forum', index: 1),
                const SizedBox(width: 48),
                navButton(icon: Icons.book, label: 'My Diary', index: 2),
                navButton(icon: Icons.person, label: 'Profil', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navButton({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => widget.onTabChanged(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: widget.currentTab == index ? color5 : color4,
            size: 24,
          ),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/utils/fabaction.dart';
import 'package:serenypals_frontend/widget/navigationbar.dart';

class MainTabScaffold extends StatefulWidget {
  final Widget child;
  const MainTabScaffold({super.key, required this.child});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _currentTab = 0;
  bool _fabExpanded = false;
  Color _fabColor = color3;
  FabAction _fabAction = FabAction.none;
  Color _fabAIColor = color3;
  Color _fabPsikiaterColor = color3;
  bool _fabOpened = false;

  final List<String> tabPaths = [
    '/dashboard',
    '/forum',
    '/diary',
    '/profile',
    '/ai',
    '/psikiater',
  ];

  void _onTabChanged(int index) {
    if (_currentTab == index) {
      // Klik dua kali di tab yang sama → toggle FAB kalau tab AI atau Psikiater
      if (index == 4 || index == 5) {
        setState(() {
          if (_fabOpened) {
            _fabAction = FabAction.none;
            _resetFabChildColors();
          } else {
            _onFabActionChanged(
              index == 4 ? FabAction.ai : FabAction.psikiater,
            );
          }
        });
      }
      return;
    }

    setState(() {
      _currentTab = index;
      _fabExpanded = false;

      // Reset FAB kalau bukan tab FAB
      if (index != 4 && index != 5) {
        _fabAction = FabAction.none;
        _resetFabChildColors();
      }
    });

    context.go(tabPaths[index]);
  }

  void _onFabActionChanged(FabAction action) async {
    // Jika sudah terbuka dan diklik lagi → reset (tutup FAB)
    if (_fabOpened && _fabAction == action) {
      setState(() {
        _fabAction = FabAction.none;
      });
      _resetFabChildColors();
      return;
    }

    // Kalau beda action atau belum terbuka → lanjut buka seperti biasa
    setState(() {
      _fabAction = action;
      _fabExpanded = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    switch (action) {
      case FabAction.ai:
        setState(() {
          _currentTab = 4;
          _fabAIColor = color5;
          _fabPsikiaterColor = color3;
          _fabColor = color3;
          _fabOpened = true;
        });
        context.go(tabPaths[4]);
        break;
      case FabAction.psikiater:
        setState(() {
          _currentTab = 5;
          _fabPsikiaterColor = color5;
          _fabAIColor = color3;
          _fabColor = color3;
          _fabOpened = true;
        });
        context.go(tabPaths[5]);
        break;
      case FabAction.none:
        _resetFabChildColors();
        break;
    }
  }

  void _resetFabChildColors() {
    setState(() {
      _fabColor = color3;
      _fabAIColor = color3;
      _fabPsikiaterColor = color3;
      _fabOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      currentTab: _currentTab,
      onTabChanged: _onTabChanged,
      isFabExpanded: _fabExpanded,
      onFabToggle: (val) {
        setState(() {
          _fabExpanded = val;
          if (!_fabExpanded && _fabOpened) {
            _resetFabChildColors();
          }
        });
      },
      fabAction: _fabAction,
      onFabActionChange: _onFabActionChanged,
      fabColor: _fabColor,
      fabAIColor: _fabAIColor,
      fabPsikiaterColor: _fabPsikiaterColor,
      children: [widget.child],
    );
  }
}

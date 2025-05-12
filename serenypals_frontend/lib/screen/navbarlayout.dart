import 'package:flutter/material.dart';
import 'package:serenypals_frontend/screen/dashboardpage.dart';
import 'package:serenypals_frontend/screen/psikiaterscreen.dart';
import 'package:serenypals_frontend/utils/color.dart';
import 'package:serenypals_frontend/utils/fabaction.dart';
import 'package:serenypals_frontend/widget/navigationbar.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

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

  void _onTabChanged(int index) {
    setState(() {
      _currentTab = index;

      // Tutup FAB saat ganti tab secara manual
      _fabExpanded = true;

      // Reset warna jika bukan dari FAB
      if (index != 4 && index != 5) {
        _fabAction = FabAction.none;
        _resetFabChildColors();
      }
    });
  }

  void _onFabActionChanged(FabAction action) async {
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
        break;
      case FabAction.psikiater:
        setState(() {
          _currentTab = 5;
          _fabPsikiaterColor = color5;
          _fabAIColor = color3;
          _fabColor = color3;
          _fabOpened = true;
        });
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

  final List<Widget> pages = [
    DashboardContent(),
    ForumPage(),
    MyDiaryPage(),
    ProfilePage(),
    AIPage(),
    PsikiaterPage(),
  ];

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
      children: pages,
    );
  }
}

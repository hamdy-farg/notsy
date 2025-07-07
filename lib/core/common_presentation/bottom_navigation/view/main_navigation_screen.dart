import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/features/payment_management/presentation/home/view/home_filter_view.dart';
import 'package:provider/provider.dart';

import '../../../../features/payment_management/presentation/home/payment_filter_view_model.dart';
import '../../../di/app_component/app_component.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex]
        .currentState!
        .maybePop();
    return isFirstRouteInCurrentTab;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildNavigator(
              0,
              ChangeNotifierProvider<HomePaymentFilterViewModel>(
                create: (BuildContext context) =>
                    locator<HomePaymentFilterViewModel>(),
                child: HomeFilterView(),
              ),
            ),
            _buildNavigator(1, SizedBox()),
            _buildNavigator(2, SizedBox()),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1), // top shadow (negative Y offset)
                blurRadius: 8,
                spreadRadius: .1,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart_outlined_outlined),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigator(int index, Widget screen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => screen);
      },
    );
  }
}

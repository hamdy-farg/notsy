import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notsy/features/payment_management/presentation/home/payment_filter_view_model.dart';
import 'package:notsy/features/payment_management/presentation/home/view/home_filter_view.dart';
import 'package:provider/provider.dart';

import '../../../../features/payment_management/presentation/payment_report/payment_report_viewModel.dart';
import '../../../../features/payment_management/presentation/payment_report/view/payment_report_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../di/app_component/app_component.dart';
import 'main_navigation_view_model.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  Future<bool> _onWillPop() async {
    // If we ever use navigation inside a tab, add logic here
    return true; // allow back press
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<MainNavigationViewModel>(
        builder: (context, MainNavigationViewModel provider, child) {
          log("provider.currentIndex = ${provider.currentIndex}");
          return Scaffold(
            body: _getCurrentScreen(provider),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -1),
                    blurRadius: 8,
                    spreadRadius: .1,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.green,
                currentIndex: provider.currentIndex,
                onTap: (index) {
                  provider.currentIndex = index;
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: '${t?.home}',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.insert_chart_outlined_outlined),
                    label: '${t?.reports}',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    label: '${t?.settings}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Creates a new widget every time tab is switched
  Widget _getCurrentScreen(MainNavigationViewModel provider) {
    switch (provider.currentIndex) {
      case 0:
        return ChangeNotifierProvider<HomePaymentFilterViewModel>(
          create: (_) => locator<HomePaymentFilterViewModel>(),
          lazy: true,
          child: HomeFilterView(),
        );
      case 1:
        return ChangeNotifierProvider<PaymentReportViewModel>(
          create: (_) => locator<PaymentReportViewModel>(),
          lazy: true,
          child: PaymentReportView(),
        );
      case 2:
        return const Center(child: Text("Settings Page")); // Or your own widget
      default:
        return const SizedBox();
    }
  }
}

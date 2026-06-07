import 'package:flutter/material.dart';

import '../../dashboard_service.dart';
import 'dashboard_tab.dart';

class DashboardOwner extends StatelessWidget {
  final DashboardService dashboardService;

  const DashboardOwner({super.key, required this.dashboardService});

  @override
  Widget build(BuildContext context) {
    return DashboardTab();
  }
}

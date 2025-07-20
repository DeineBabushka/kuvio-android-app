import 'package:flutter/material.dart';
import 'package:kuvio/features/admin/services/admin_service.dart';
import 'package:kuvio/shared/utils/constants.dart';
import 'package:kuvio/features/admin/widgets/admin_app_bar.dart';
import 'package:kuvio/features/admin/widgets/admin_list.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Admin Dashboard'),
      body: UserList(
        userStream: AdminService.getUserStream(),
        cardTextColor: AppColors.cardText,
      ),
    );
  }
}

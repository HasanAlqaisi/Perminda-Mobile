import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:perminda/presentation/features/home/controller/home_controller.dart';
import 'package:perminda/presentation/features/home/widgets/categories.dart';
import 'package:perminda/presentation/features/home/widgets/customized_appbar.dart';
import 'package:perminda/presentation/features/home/widgets/packages.dart';
import 'package:perminda/injection_container.dart' as di;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(),
      body: SafeArea(
        child: HomeScreenBody(),
      ),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: di.sl<HomeController>(),
      builder: (_) {
        return NotificationListener<ScrollNotification>(
          onNotification: _.handleCategoriesScrolling,
          child: ListView(
            controller: _.categoriesScroll,
            children: [
              Packages(),
              Categories(),
            ],
          ),
        );
      },
    );
  }
}

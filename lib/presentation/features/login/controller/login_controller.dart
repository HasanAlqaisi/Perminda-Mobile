import 'package:dartz/dartz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/mappers/failure_to_string_mapper.dart';
import 'package:perminda/domain/usecases/auth/login_user.dart';
import 'package:perminda/presentation/features/nav/pages/home.dart';

class LoginController extends GetxController {
  final LoginUserUseCase loginUserUseCase;
  String username = '', password = '';
  Failure failure;
  bool isLoading = false;

  LoginController(this.loginUserUseCase);

  void onLoginClicked() async {
    isLoading = true;
    failure = null;
    update();

    final result = await loginUserUseCase(username, password);
    isLoading = false;
    update();

    result.fold((failure) {
      Fluttertoast.showToast(msg: failureToString(failure));
    }, (isSuccess) {
      if (isSuccess) {
        Get.offAndToNamed(Home.route);
      }
    });
  }
}

import 'package:get/get.dart';
import 'package:ggomal/services/kid_dio.dart';

class CoinController extends GetxController {
  RxInt coinCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    coin();
  }

  void coin() {
    getCoin().then((result) {
      coinCount.value = result;
    });

  }

}
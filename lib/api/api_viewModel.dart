

import 'package:get/get.dart';
import 'package:invoice_generator/api/api_model/gst_number_verification_response_model.dart';

import 'api_repo.dart';
import 'api_response.dart';

class GstVeriFicationController extends GetxController {
  ApiResponse getNotificationListApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteNotificationApiResponse = ApiResponse.initial('Initial');

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> gstVeriFicationController() async {
    if (getNotificationListApiResponse.status == Status.INITIAL) {
      getNotificationListApiResponse = ApiResponse.loading('Loading');
    }

    update();
    try {
      GstVerificationModel  response =
      await GstVeriFicationRepo().gstVeriFicationRepo();
      getNotificationListApiResponse = ApiResponse.complete(response);
    } catch (e) {

      print("getNotificationListApiResponse.........>$e");
      getNotificationListApiResponse = ApiResponse.error('error');
    }
    update();
  }

}

import 'dart:convert';
import 'dart:developer';



import 'package:invoice_generator/api/api_handlers.dart';
import 'package:invoice_generator/api/api_model/gst_number_verification_response_model.dart';

import 'api_routs.dart';


class GstVeriFicationRepo extends BaseService {

  Future<dynamic> gstVeriFicationRepo() async {
    var headers = {
      'Content-Type': 'application/json; charset=utf-8'
    };
    var response =
    await ApiService().getResponse(apiType: APIType.aGet, url: BaseService.gstNumberVerification,header: headers);
    print('++++++++++++++++++++++++RESPONSE   $response');
    GstVerificationModel  gstVerificationModel =
        gstVerificationModelFromJson(response);

    log('-----------------------${gstVerificationModel}');
    return gstVerificationModel;

  }


}

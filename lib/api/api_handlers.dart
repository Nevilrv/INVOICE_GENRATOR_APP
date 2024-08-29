import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'api_exepction.dart';
import 'api_routs.dart';


enum APIType { aPost, aGet, aDelete }

class ApiService extends BaseService {
  var response;

  Future<dynamic> getResponse(
      {required APIType apiType,
        required String url,
        Map<String, dynamic>? body,
        bool fileUpload = false,
        var header,
        bool withoutTypeHeader = false}) async {
    try {


      if (apiType == APIType.aGet) {
        var result = await http.get(Uri.parse(url),headers: header);
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        log("response......${response}");
      }  else if (apiType == APIType.aPost) {
        var encodeBody = jsonEncode(body);
        log("REQUEST ENCODE BODY11111 $encodeBody");
        var result = await http.post(
          Uri.parse(url),

          body: withoutTypeHeader == true ? body : encodeBody,
        );
        response = returnResponse(result.statusCode, result.body);
      } else if (apiType == APIType.aDelete) {
        var result =
        await http.delete(Uri.parse( url),);
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        log("response......${response}");
      }

      return response;
    } catch (e) {
      log('Error=>.. $e');
    }
  }

  returnResponse(int status, var result) {
    print("status ---> $status");
    switch (status) {
      case 200:
        return jsonDecode(result);
    /*     case 256:
        return jsonDecode(result);*/

      case 400:
        throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
// https://www.unhbackend.com/AppServices/Patient/class/25/3
// https://www.unhbackend.com/AppServices/Patient/class/25/3

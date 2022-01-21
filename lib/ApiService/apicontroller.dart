
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:offlinestorage/ApiService/constants.dart';

var dio = Dio();

//GET METHOD DIO
Future getDioApi(url, List<String> type, store) async {
  var urlValue = BASE_URL+url;
  Response response;
  print("REQUEST URL: " + urlValue);
  print("REQUEST METHOD: GET");
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    store.dispatch(ResponseModal.responseResult(null, type[0]));
    try {
      response = await dio.get(
          urlValue,
          options: Options(
              headers: {
                headerAuth: headAuthtoken + token,
              },
              validateStatus: (status) { return status! < 500; }
          )
      );
      if (response.statusCode == 200) {
        store.dispatch(ResponseModal.responseResult(response, type[1]));
      }else {
        store.dispatch(ResponseModal.responseResult(response, type[1]));
      }
    } catch(e) {
      store.dispatch(ResponseModal.responseResult("pleasetryagain", type[2]));
    }
  } else {
    store.dispatch(ResponseModal.responseResult("nointernetconnection", type[2]));
  }
}


//POST METHOD
/*Future postDioApi(url, params, List<String> type, store) async {
  var urlValue = BASE_URL + url;
  Response response;
  print("REQUEST URL: " + urlValue);
  print("REQUEST PARAMS: " + params.toString());
  print("REQUEST METHOD: POST");
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    store.dispatch(ResponseModal.responseResult(null, type[0]));
    try {
      response = await dio.post(
          urlValue,
          data: params,
          options: Options(
              headers: {
                headerAuth: headAuthtoken + token,
              },
              validateStatus: (status) { return status! < 500; }
          )
      );
      if (response.statusCode == 200) {
        var newstring = response.data.toString();
        List str = newstring.split(':');
        var string1 = str[0];
        if (string1 == errorString) {
          store.dispatch(ResponseModal.responseResult(response, type[2]));
        } else {
          store.dispatch(ResponseModal.responseResult(response, type[1]));
        }
      }
      else {
        store.dispatch(ResponseModal.responseResult(response, type[2]));
      }
    } catch(e) {
      store.dispatch(ResponseModal.responseResult('pleasetryagain', type[2]));
    }
  } else {
    store.dispatch(ResponseModal.responseResult('nointernetconnection', type[2]));
  }
}

*/

class ResponseModal {
  final String? type;
  dynamic payload;
  dynamic statuscode;
  dynamic error;

  ResponseModal({
    this.type,
    this.payload,
    this.statuscode,
    this.error
  });

  ResponseModal.responseResult(result, this.type) {
    if (result != null) {
      if (result is String) {
        payload = result;
        statuscode = null;
        error = result;
      } else if (result is Response) {
        if (result.statusCode == 200) {
          payload = result.data;
          statuscode = result.statusCode;
          error = false;
        } else {
          payload = result.data['error_msg'].toString();
          statuscode = result.statusCode;
          error = result.statusMessage;
        }
      }
    } else {
      payload = null;
      statuscode = null;
      error = null;
    }
  }
}
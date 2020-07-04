import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/utilities/Constants.dart';
import '../../../utilities/LocalKeys.dart';

class NetworkUtilities {

  static Future<bool> isConnected() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true ;
      }
    } on SocketException catch (_) {
      return false ;
    }
    return false ;
  }
  static Future <ResponseViewModel<dynamic>> handleGetRequest({String methodURL, Map<String,String> requestHeaders , Function parserFunction})async{
    ResponseViewModel getResponse ;

    try{
      var serverResponse  = await http.get(methodURL , headers: requestHeaders);

      if(serverResponse.statusCode == 200){
        if(json.decode(serverResponse.body) is List && json.decode(serverResponse.body).length > 0){
          if (json.decode(serverResponse.body)[0][ApiParseKeys.ERROR_MESSAGE] != null) {
            return ResponseViewModel(
              isSuccess: false,
              errorViewModel: ErrorViewModel(
                errorMessage: json.decode(serverResponse.body)[0][ApiParseKeys.ERROR_MESSAGE],
                errorCode: 99,
              ),
              responseData: null,
            );
          }
        }
        else {
          if (json.decode(serverResponse.body)[ApiParseKeys.ERROR_MESSAGE] != null) {

            return ResponseViewModel(
              isSuccess: false,
              errorViewModel: ErrorViewModel(
                errorMessage: json.decode(serverResponse.body)[ApiParseKeys.ERROR_MESSAGE],
                errorCode: 99,
              ),
              responseData: null,
            );
          }
        }
        getResponse =  ResponseViewModel(
          isSuccess: true ,
          errorViewModel: null,
          responseData: parserFunction(json.decode(serverResponse.body)),
        );

      }
      else {
        String serverError = "";
        try{
          serverError = json.decode(serverResponse.body)['error'];
        } catch(exception){
          serverError = serverResponse.body;
        }
        getResponse =  ResponseViewModel(
          isSuccess: false ,
          errorViewModel: ErrorViewModel(
            errorMessage: serverError,
            errorCode: serverResponse.statusCode,
          ),
          responseData: null,
        );
        if(getResponse.errorViewModel.errorCode == 404){
          getResponse =  ResponseViewModel(
            isSuccess: false ,
            errorViewModel: ErrorViewModel(
              errorMessage: (LocalKeys.SERVER_UNREACHABLE).tr(),
              errorCode: serverResponse.statusCode,
            ),
            responseData: null,
          );
        }
      }
    }
    on SocketException{
      getResponse = ResponseViewModel(
        isSuccess: false ,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    }
    catch(exception){
      getResponse =  ResponseViewModel(
        isSuccess: false ,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    networkLogger(url: methodURL , body: '', headers: requestHeaders , response: getResponse);
    return getResponse;
  }
  static Future <ResponseViewModel> handlePostRequest({ bool acceptJson = false ,  String methodURL, Map<String,String> requestHeaders, Map<String,dynamic> requestBody , Function parserFunction})async{
    ResponseViewModel postResponse ;
    try{
      http.Response serverResponse  = await http.post(methodURL , headers: requestHeaders , body: acceptJson ? json.encode(requestBody) : requestBody);
      if(serverResponse.statusCode == 200){
        if(json.decode(serverResponse.body) is List && json.decode(serverResponse.body).length > 0){
          if (json.decode(serverResponse.body)[0][ApiParseKeys.ERROR_MESSAGE] != null) {
            return ResponseViewModel(
              isSuccess: false,
              errorViewModel: ErrorViewModel(
                errorMessage: json.decode(serverResponse.body)[0][ApiParseKeys.ERROR_MESSAGE],
                errorCode:  99,
              ),
              responseData: null,
            );
          }
        }
        else {
          if (json.decode(serverResponse.body)[ApiParseKeys.ERROR_MESSAGE] != null) {
            return ResponseViewModel(
              isSuccess: false,
              errorViewModel: ErrorViewModel(
                errorMessage: json.decode(serverResponse.body)[ApiParseKeys
                    .ERROR_MESSAGE],
                errorCode: 99,
              ),
              responseData: null,
            );
          }
        }
        postResponse =  ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(json.decode(serverResponse.body)),
        );
      }
      else {
        print(serverResponse.body);
        String serverError = "";
        try{
          serverError = json.decode(serverResponse.body)['error'];
        } catch(exception){
          serverError = serverResponse.body;
        }
        postResponse  = ResponseViewModel(
          isSuccess: false ,
          errorViewModel: ErrorViewModel(
            errorMessage: serverError,
            errorCode: serverResponse.statusCode,
          ),
          responseData: null,
        );

        if(postResponse.errorViewModel.errorCode == 404){
          postResponse =  ResponseViewModel(
            isSuccess: false ,
            errorViewModel: ErrorViewModel(
              errorMessage: (LocalKeys.SERVER_UNREACHABLE).tr(),
              errorCode: serverResponse.statusCode,
            ),
            responseData: null,
          );
        }
      }
    }
    on SocketException{
      postResponse =  ResponseViewModel(
        isSuccess: false ,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    }
    catch(exception){
      print("Exception in post => $exception");

      postResponse =  ResponseViewModel(
        isSuccess: false ,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }


    networkLogger(url: methodURL , body: requestBody, headers: requestHeaders , response: postResponse);
    return postResponse;
  }
  static Future <ResponseViewModel> handleFilesUploading({ bool acceptJson = false ,  String methodURL, Map<String,String> requestHeaders, FormData formData , Function parserFunction})async{
    ResponseViewModel postResponse ;
    try{
      var uploadResponse = await Dio().post(
        NetworkUtilities.getFullURL(method: URL.POST_UPLOAD_FILES),options: Options(
        sendTimeout: 5 * 60 * 1000 ,
        contentType: 'video/*'
      ) ,data: formData, onSendProgress: (int progress, int total){
          print('$progress of $total sent');
      });

      if(uploadResponse.statusCode == 200){
        postResponse =  ResponseViewModel(
          isSuccess: true,
          errorViewModel: null,
          responseData: parserFunction(uploadResponse.data),
        );
      }
      else {
        String serverError = "";
        try{
          serverError = json.decode(uploadResponse.data)['error'];
        } catch(exception){
          serverError = uploadResponse.data;
        }
        postResponse  = ResponseViewModel(
          isSuccess: false ,
          errorViewModel: ErrorViewModel(
            errorMessage: serverError,
            errorCode: uploadResponse.statusCode,
          ),
          responseData: null,
        );

        if(postResponse.errorViewModel.errorCode == 404){
          postResponse =  ResponseViewModel(
            isSuccess: false ,
            errorViewModel: ErrorViewModel(
              errorMessage: (LocalKeys.SERVER_UNREACHABLE).tr(),
              errorCode: uploadResponse.statusCode,
            ),
            responseData: null,
          );
        }
      }
    }
    on SocketException{
      postResponse =  ResponseViewModel(
        isSuccess: false ,
        errorViewModel: Constants.CONNECTION_TIMEOUT,
        responseData: null,
      );
    }
    catch(exception){
      print("Exception in post => $exception");
      postResponse =  ResponseViewModel(
        isSuccess: false ,
        errorViewModel: ErrorViewModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }


    networkLogger(url: methodURL , body: formData , headers: requestHeaders , response: postResponse);
    return postResponse;
  }
  static Map<String, String> getHeaders({Map<String,String> customHeaders}){

    Map<String,String> headers = {
      'Content-Type' : 'application/json',
      'X-Requested-With' :'XMLHttpRequest',
    };
    if(customHeaders != null){
      for(int i = 0 ; i < customHeaders.length ; i++){
        headers.putIfAbsent(customHeaders.keys.toList()[i], ()=> customHeaders[customHeaders.keys.toList()[i]]);
      }
    }
    return headers;
  }
  static void networkLogger({url , headers , body ,ResponseViewModel response}){
    debugPrint('---------------------------------------------------');
    debugPrint('URL => $url');
    debugPrint('headers => $headers');
    debugPrint('Body => $body');
    debugPrint('Response => ${response.toString()}');
    debugPrint('---------------------------------------------------');
  }
  static String getFullURL({String method}) {
    return URL.API_URL + method;
  }
}
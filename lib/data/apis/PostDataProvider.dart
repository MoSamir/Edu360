import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edu360/Repository.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';

import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class PostDataProvider{


  static Future<ResponseViewModel<List<String>>> uploadPostFiles(
      List<File> tobeUploadedFiles) async {
    List<MultipartFile> files = List();

    String userToken = (await Repository.getUser()).userToken;

    for (int i = 0; i < tobeUploadedFiles.length; i++) {
      String fileName = tobeUploadedFiles[i]
          .path
          .split("/")[tobeUploadedFiles[i].path.split("/").length - 1];
      files.add(MultipartFile.fromFileSync(tobeUploadedFiles[i].path,
          filename: fileName));
    }

    Map filesMap = Map<String,dynamic>();
    filesMap.putIfAbsent("files", () => files);
    FormData formData = FormData.fromMap(filesMap);

    ResponseViewModel uploadFiles = await NetworkUtilities.handleFilesUploading(
        formData: formData,
        requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}),
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_UPLOAD_POST_FILES),
        parserFunction: (responseJson) {
          try{
            List<String> urls = List<String>();
            for(int i = 0 ; i <responseJson.length ; i++)
              urls.add(responseJson[i].toString());
            return urls;
          }catch(exception){
            print("Exception => $exception");
            return List<String>();
          }
        });

    return ResponseViewModel<List<String>>(
      responseData: uploadFiles.responseData,
      isSuccess: uploadFiles.isSuccess,
      errorViewModel: uploadFiles.errorViewModel,
    );
  }



  static Future<ResponseViewModel<void> > createUserPost(PostViewModel userPost , {List<String> uploadedFiles})async {


    UserViewModel userVm = await Repository.getUser();

    List<dynamic> filesJson = List();
    for(int i = 0 ; i < uploadedFiles.length ; i++){
      filesJson.add({
        'PostID' : 0,
        'AttachmentType' : userPost.contentType == ContentType.FILE_POST ? 1 : 2,
        'Title' : '',
        'Description' : '',
        'FieldOfStudyID' : userVm.userFieldOfStudy.studyFieldId,
        'PostAttachmentPath': uploadedFiles[i],
      });
    }


    String userToken = (await Repository.getUser()).userToken;
    Map<String,dynamic> postData = {
      "PostText": userPost.postBody,
      "PostAttachments" : filesJson,
    };
    ResponseViewModel newPostResponse = await NetworkUtilities.handlePostRequest(methodURL: NetworkUtilities.getFullURL(method: URL.POST_CREATE_POST),acceptJson: true ,requestBody: postData ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}),  parserFunction: (responseJson){});
    return ResponseViewModel<void>(
      errorViewModel: newPostResponse.errorViewModel,
      isSuccess: newPostResponse.isSuccess,
      responseData: newPostResponse.responseData,
    );
  }
}
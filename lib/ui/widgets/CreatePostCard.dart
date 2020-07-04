import 'dart:io';

import 'package:edu360/blocs/bloc/CreateNewContentBloc.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/events/CreateNewContentEvents.dart';
import 'package:edu360/blocs/states/CreateNewContentStates.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' as ll;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'NetworkErrorView.dart';

class CreatePostCard extends StatefulWidget {
  @override
  _CreatePostCardState createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  TextEditingController _postBodyController ;
  CreateNewContentBloc newPostBloc ;
  List<File> postFiles = List<File>();
  GlobalKey<FormState> postFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    newPostBloc = CreateNewContentBloc();
    _postBodyController = TextEditingController();
  }

  @override
  void dispose() {
    newPostBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    UserViewModel loggedInUser = BlocProvider.of<UserDataBloc>(context).authenticationBloc.currentUser;
    return BlocConsumer(
      listener: (context, state){
        print(state);
        if (state is PostCreationFailed) {
          if (state.error.errorCode == HttpStatus.requestTimeout) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return NetworkErrorView();
                });
          }
          else if(state.error.errorCode == HttpStatus.serviceUnavailable){
            Fluttertoast.showToast(
                msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
          else {
            Fluttertoast.showToast(
                msg: state.error.errorMessage ?? '',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
        else if(state is PostCreationSuccess){}
      },
      builder: (context, state){
        return ModalProgressHUD(
          child: Card(
            child: Form(
              key: postFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.mainThemeColor,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(loggedInUser.profileImagePath),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(loggedInUser.userFullName , style: TextStyle(
                              color: AppColors.mainThemeColor,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){},
                        ),
                      ],
                    ),
                  ),
                  postBody(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: EduButton(
                            borderColor: AppColors.mainThemeColor,
                            onPressed: (){},
                            title: "Media",
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: EduButton(
                            borderColor: AppColors.mainThemeColor,
                            onPressed: postFiles.length >= 2 || newPostBloc.newPost.contentType == ContentType.VIDEO_POST ? null : (){
                              newPostBloc.newPost.contentType = ContentType.FILE_POST;
                              pickDocumentFile();
                              return;
                            },
                            title: "File",
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: EduButton(
                      onPressed: _createPost,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      bgColor: AppColors.mainThemeColor,
                      title: "Post",
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
          inAsyncCall: state is PostCreationLoading,
        );
      },
      bloc: newPostBloc,
    );
  }
  Widget postBody(){
    switch(newPostBloc.newPost.contentType){
      case ContentType.TEXT_POST :
        return Expanded(
          child: TextFormField(
            controller: _postBodyController ,
            obscureText:  false,
            textInputAction: TextInputAction.done,
            validator: Validator.requiredField,
            autovalidate:false,
            maxLines: 20,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              fillColor: AppColors.white,
              hintText: LocalKeys.ADD_POST_DESCRIPTION,
              hintStyle: Styles.baseTextStyle.copyWith(
                color: AppColors.registrationTextPlaceholderColor,
              ),
            ),
          ),
        ) ;
      case ContentType.FILE_POST:
        return Expanded(
          child: getFilesList(),
        );
      default:
        return Container();
    }
  }
  Widget getFilesList() {
    List<Widget> filesWidget = List();
    for(int i = 0 ; i < postFiles.length;i++){
      String ext = postFiles[i].path.substring(postFiles[i].path.lastIndexOf('.')+1);
      filesWidget.add(Material(
            type: MaterialType.card,
            elevation: 2,
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ext == 'pdf' ? getPdfView() : getDocView(),
                ),
                Positioned.directional(textDirection: TextDirection.ltr,
                  top: 0,
                  end: 0,
                  child:
                  GestureDetector(
                      onTap: (){postFiles.removeAt(i);setState(() {});},
                      child: Container(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Icon(Icons.close , color: AppColors.canaryColor, size: 20,),
                        ),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )),
                  ),
              ],
            ),
          ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _postBodyController ,
              obscureText:  false,
              textInputAction: TextInputAction.done,
              validator: Validator.requiredField,
              autovalidate:false,
              maxLines: 10,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                fillColor: AppColors.white,
                hintText: LocalKeys.ADD_POST_DESCRIPTION,
                hintStyle: Styles.baseTextStyle.copyWith(
                  color: AppColors.registrationTextPlaceholderColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Wrap(children: filesWidget,spacing: 10, direction: Axis.horizontal, alignment: WrapAlignment.start,),
        ],
      ),
    );
  }
  getPdfView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red,
      ),

      child: Center(child: Text('PDF' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
    );
  }
  getDocView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Center(child: Text('DOC',textScaleFactor: 1,style: Styles.baseTextStyle,),),
    );
  }
  pickDocumentFile() async{
      try{
        FilePicker.getMultiFile(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc'],).then((value){
          if(value!= null){
            postFiles.addAll(value);
            setState(() {});
          }
        });
      } catch(exception){
        print("Exception while picking file => $exception");
      }
  }
  void _createPost() {
    if(postFormKey.currentState.validate()) {
      newPostBloc.newPost.postBody = _postBodyController.text;
      newPostBloc.add(CreatePost(postViewModel: newPostBloc.newPost,postDocuments: postFiles));
    }
  }
}

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/PostBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/blocs/states/PostStates.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/widgets/CommentWidget.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SinglePostScreen extends StatefulWidget {
  final PostViewModel post;
  final Function onPostExecution ;
  SinglePostScreen(this.onPostExecution , {this.post});

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
   PostBloc _postBloc ;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _postBloc =  PostBloc(widget.onPostExecution);
    _postBloc.add(FetchPostComments(postModel: widget.post));
    super.initState();
  }

  GlobalKey<FormState> _commentForm = GlobalKey<FormState>();

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
        backgroundColor: AppColors.mainThemeColor,
        autoImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BlocBuilder(
                    bloc: _postBloc,
                    builder: (context, state){
                      PostViewModel _post = widget.post;
                      if(state is PostLoaded)
                        _post = state.postViewModel;
                      return UIHelper.getPostView( _post , context ,  elevation: 0 , postAction: (){
                        setState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 15,),
                  BlocConsumer(
                    bloc: _postBloc,
                    listener: (context , state){},
                    builder: (context, state){
                      if(state is PostLoaded){
                        _postBloc.add(FetchPostComments(postModel: state.postViewModel));
                        return state.postViewModel.postComments != null && state.postViewModel.postComments.length > 0 ?
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.postViewModel.postComments.length,
                            shrinkWrap: true,
                            itemBuilder: (context , index) => CommentWidget(
                              comment : state.postViewModel.postComments[index],
                            )) : PlaceHolderWidget(
                          placeHolder: Text(LocalKeys.NO_COMMENTS_YET , style: TextStyle(color: AppColors.mainThemeColor),).tr(),
                        );
                      }
                      if(state is CommentsFetched){
                        return state.postViewModel.postComments.length > 0 ?
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.postViewModel.postComments.length,
                            shrinkWrap: true,
                            itemBuilder: (context , index) => CommentWidget(
                              comment : state.postViewModel.postComments[index],
                            )) : PlaceHolderWidget(
                          placeHolder: Text(LocalKeys.NO_COMMENTS_YET , style: TextStyle(color: AppColors.mainThemeColor),).tr(),
                        );
                      }
                      else if(state is PostLoadingState){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          addCommentView(),
        ],
      ),
    );
  }
  Widget addCommentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 2),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.white,
        child: Container(
          color: AppColors.transparent,
          width: MediaQuery.of(context).size.width,
          //height: 80,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _commentForm,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Container(
                            decoration: BoxDecoration(
                                color: AppColors.transparent,
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
//                     width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _commentController,
                              decoration: InputDecoration(
//                                  contentPadding:
//                                  EdgeInsets.only(left: 10, bottom: 16),
                                  hintText: "Type your comment here..",
                                  hintStyle: TextStyle(color: AppColors.mainThemeColor.withOpacity(.5),fontSize: 14),
                                  border: InputBorder.none),
                            )),
                      ),
                    )),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: SvgPicture.asset(Resources.COMMENT_ERROR_SVG_IMAGE , width: 30, height: 30,),
                onPressed: (){
                  if(_commentForm.currentState.validate()){
                    _postBloc.add(AddObjection(postModel: widget.post , commentViewModel: UIHelper.createComment(_commentController.text, BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser)));
                  }
                },
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: SvgPicture.asset(Resources.POST_PAGE_COMMENT_SVG_IMAGE , width: 30, height: 30,),
                onPressed: (){
                  if(_commentForm.currentState.validate()){
                    _postBloc.add(AddComment(postModel: widget.post , commentViewModel: UIHelper.createComment(_commentController.text, BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



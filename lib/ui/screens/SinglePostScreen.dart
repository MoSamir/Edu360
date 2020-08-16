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
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
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
  PostViewModel postModel ;

  @override
  void initState() {
    super.initState();
    postModel = widget.post;
    _postBloc =  PostBloc(widget.onPostExecution);
    _postBloc.add(FetchPostComments(postModel: widget.post));

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
      body: Scaffold(
        body: BlocBuilder(
          bloc: _postBloc,
          builder: (context , state){

            if(state is CommentsFetched){
              postModel = state.postViewModel;

            }

            return ModalProgressHUD(
              inAsyncCall: state is PostLoadingState,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          UIHelper.getPostView( postModel , context ,  elevation: 0 , postAction: (){setState(() {});}),
                          SizedBox(height: 15,),
                         getCommentsView(state),
                        ],
                      ),
                    ),
                  ),
                  addCommentView(),
                ],
              ),
            );
          },

        ),
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
                              validator: (text){
                                return text == null || text.isEmpty ? '' : null;
                              },
                              controller: _commentController,
                              decoration: InputDecoration(
//                                  contentPadding:
//                                  EdgeInsets.only(left: 10, bottom: 16),
                                  hintText: (LocalKeys.TYPE_YOUR_COMMENT).tr(),
                                  hintStyle: TextStyle(color: AppColors.mainThemeColor.withOpacity(.5),fontSize: 14),
                                  border: InputBorder.none),
                            )),
                      ),
                    )),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Image.asset(Resources.OBJECTION_IMAGE , width: 30, height: 30,),
                onPressed: (){
                  if(_commentForm.currentState.validate()){
                    _postBloc.add(AddObjection(postModel: widget.post , commentViewModel: UIHelper.createComment(_commentController.text, BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser)));
                    _postBloc.add(FetchPostComments(postModel: widget.post , silentLoad: true));
                    _commentController.clear();
                  }
                },
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: SvgPicture.asset(Resources.POST_PAGE_COMMENT_SVG_IMAGE , width: 30, height: 30,),
                onPressed: (){
                  if(_commentForm.currentState.validate()){
                    _postBloc.add(AddComment(postModel: widget.post , commentViewModel: UIHelper.createComment(_commentController.text, BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser)));
                    _postBloc.add(FetchPostComments(postModel: widget.post , silentLoad: true));
                    _commentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCommentsView(PostStates state) {
    if(state is PostLoadingState) return Container();
      return postModel.postComments != null && postModel.postComments.length > 0 ?
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: postModel.postComments.length,
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              CommentWidget(
                comment: postModel.postComments[index],
              )) :
      Center(child: PlaceHolderWidget(
        placeHolder: Center(
          child: Text(LocalKeys.NO_COMMENTS_YET,
            style: TextStyle(color: AppColors.mainThemeColor),).tr(),
        ),
      ),
      );

  }
}



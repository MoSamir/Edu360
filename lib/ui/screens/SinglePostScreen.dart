import 'package:edu360/blocs/bloc/PostBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/widgets/CommentWidget.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SinglePostScreen extends StatefulWidget {

  final PostViewModel post;
  SinglePostScreen({this.post});

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  final PostBloc _postBloc = PostBloc();

  @override
  void initState() {
    _postBloc.add(FetchPostComments());
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                UIHelper.getPostView(widget.post, context ,  elevation: 0 , postAction: (){
                  setState(() {});
                }),
                SizedBox(height: 15,),
                BlocConsumer(
                  bloc: _postBloc,
                  listener: (context , state){},
                  builder: (context, state){
                    if(state is PostLoaded){
                      return state.postViewModel.postComments.length > 0 ? ListView.builder(
                        itemCount: state.postViewModel.postComments.length,
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context , index) => CommentWidget(
                            comment : state.postViewModel.postComments[index],
                          )) : PlaceHolderWidget(
                        placeHolder: Text(LocalKeys.NO_COMMENTS_YET).tr(),
                      ) ;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            Positioned(
                height: 50,
                right: 0,
                left: 0,
                bottom: 10,
                child: addCommentView()),
          ],
        ),
      ),
    );
  }

  Widget addCommentView() {
    return Row(
      children: <Widget>[
        Form(

            child: TextFormField()),
        IconButton(),
      ],

    );

  }
}



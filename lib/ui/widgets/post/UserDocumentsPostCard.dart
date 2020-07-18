import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class UserDocumentsPostCard extends StatefulWidget {

  final PostViewModel postModel ;
  final double elevation ;
  final onLike , onShare , onComment , onObjection ;

  UserDocumentsPostCard({this.postModel, this.elevation , this.onComment , this.onLike , this.onObjection , this.onShare});


  @override
  _UserDocumentsPostCardState createState() => _UserDocumentsPostCardState();
}

class _UserDocumentsPostCardState extends State<UserDocumentsPostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: widget.elevation ?? 5.0,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 5,),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child:Text(widget.postModel.ownerName ?? "" ,textScaleFactor: 1),
                    ),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.linear_scale , color: Colors.black,),),
                  ],
                ),
                SizedBox(height: 10,),
                Text( widget.postModel.postBody ?? "Post Description" , textScaleFactor: 1,maxLines: 2, textAlign: TextAlign.start,),
                SizedBox(height: 5,),
                widget.postModel.postFilesPath != null ? ListView.builder(
                  itemBuilder: (context, index){
                  return Card(
                    elevation: 5,
                    child: Container(
                      height: 50,
                      child: Padding(padding: EdgeInsets.all(8), child: Text(widget.postModel.postFilesPath[index],textScaleFactor: 1),),
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                } , physics: NeverScrollableScrollPhysics() ,itemCount: widget.postModel.postFilesPath.length, shrinkWrap: true,) : Container(),
                SizedBox(height: 10,),
                Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .25,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: IconButton(icon: Icon(Icons.comment ,color: Colors.blue , size: 20,) , padding: EdgeInsets.all(0), onPressed: (){
                                widget.onComment("Comment");
                                return ;
                              } ?? (){},),
                            ),
                            Visibility(
                              replacement: Container(width: 0, height: 0,),
                              visible: widget.postModel.numberOfComments !=null ? widget.postModel.numberOfComments > 0 : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Text(widget.postModel.numberOfComments.toString() , style: Styles.baseTextStyle,))),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: IconButton(icon: Icon(Icons.comment ,color: Colors.red, size: 20,) , padding: EdgeInsets.all(0), onPressed: (){
                                widget.onObjection("objection");
                                return ;
                              } ??(){},),
                            ),
                            Visibility(
                              replacement: Container(width: 0, height: 0,),
                              visible: widget.postModel.numberOfObjections != null ? widget.postModel.numberOfObjections> 0 : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Text(widget.postModel.numberOfObjections.toString() , style: Styles.baseTextStyle,))),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: 25,
                                width: 25,
                                child: IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue, size: 20,) , padding: EdgeInsets.all(0), onPressed: widget.onLike ??(){},)),
                            Visibility(
                              replacement: Container(width: 0, height: 0,),
                              visible: widget.postModel.numberOfLikes!= null ? widget.postModel.numberOfLikes> 0 : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Text(widget.postModel.numberOfLikes.toString() , style: Styles.baseTextStyle,))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.share,),
                              onPressed: (){
                                widget.onShare("share");
                                return ;
                              } ?? (){}
                          ),
                        ),
                        Visibility(
                          replacement: Container(width: 0, height: 0,),
                          visible: widget.postModel.numberOfShares!= null ? widget.postModel.numberOfShares>  0 : false,
                          child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.mainThemeColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Text(widget.postModel.numberOfShares.toString() , style: Styles.baseTextStyle,))),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

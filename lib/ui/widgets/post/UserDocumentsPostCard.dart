import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/ParserHelpers.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class UserDocumentsPostCard extends StatefulWidget {

  final PostViewModel postModel ;
  final double elevation ;
  final onLike , onShare , onComment , onObjection , onPostClick;

  UserDocumentsPostCard({this.postModel, this.elevation , this.onComment, this.onPostClick , this.onLike , this.onObjection , this.onShare});


  @override
  _UserDocumentsPostCardState createState() => _UserDocumentsPostCardState();
}

class _UserDocumentsPostCardState extends State<UserDocumentsPostCard> {
  @override
  Widget build(BuildContext context) {

    print("Building Post with Documents");

    return GestureDetector(
      onTap: widget.onPostClick ?? (){},
      child: Padding(
        padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 4),
        child: Material(
          type: MaterialType.card,
          color: Colors.white,
          elevation: widget.elevation ?? 5.0,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(15) , bottomLeft: Radius.circular(8) , topRight: Radius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 0),
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
                          color: AppColors.mainThemeColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: widget.postModel.ownerImagePath, fit: BoxFit.cover,),
                        ),

                        //child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          widget.postModel.ownerName ?? 'Name',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //IconButton(icon: Icon(Icons.more_vert , color: AppColors.mainThemeColor,),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Text( widget.postModel.postBody ?? "Post Description" , style: TextStyle(
                        color: AppColors.mainThemeColor
                    ), textScaleFactor: 1,maxLines: 2, textAlign: TextAlign.start,),
                  ),
                  SizedBox(height: 5,),
                  ...getFiles(),
                  SizedBox(height: 10,),
                  Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .65,),
                  SizedBox(height: 10,),
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
                                  child: InkWell(
                                      onTap: widget.onLike ?? () {},
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: InkWell(
                                                  onTap: (){
                                                    if(widget.onLike != null)
                                                      widget.onLike();
                                                    return;
                                                  },
                                                  child: Icon(widget.postModel.isLiked ?? false ? Icons.favorite  : Icons.favorite_border ,color: AppColors.mainThemeColor,))),
                                          widget.postModel.numberOfLikes < 1 ? Container() : Text('${widget.postModel.numberOfLikes}',style: TextStyle(color: AppColors.mainThemeColor),),
                                        ],
                                      )
                                  )),

                            ],
                          ),
                          SizedBox(width: 6,),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  height: 25,
                                  child: InkWell(
                                    onTap: () {
                                      //widget.onComment("Comment");
                                      return;
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(Resources.COMMENT_IMAGE , width: 25, height: 25,),
                                        widget.postModel.numberOfComments < 1 ? Container() :
                                        Text('${ widget.postModel.numberOfComments}',style: TextStyle(color: AppColors.mainThemeColor),),
                                      ],
                                    )??
                                            () {},
                                  )),
                            ],
                          ),
                          SizedBox(width: 6,),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  height: 25,
                                  child: InkWell(
                                    onTap: () {
                                      //widget.onObjection("objection");
                                      return;
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(Resources.OBJECTION_IMAGE , width: 25, height: 25,),
                                        widget.postModel.numberOfObjections < 1 ? Container() :
                                        Text('${ widget.postModel.numberOfObjections}',style: TextStyle(color: AppColors.redBackgroundColor),),
                                      ],
                                    ) ??
                                            () {},
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
//                            width: 55,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    widget.onShare("share");
                                    return;
                                  },
                                  child: Image(image: AssetImage(Resources.SHARE_IMAGE)),
                                ),
                                Visibility(
                                  replacement: Container(
                                    width: 0,
                                    height: 0,
                                  ),
                                  visible: widget.postModel.numberOfShares != null
                                      ? widget.postModel.numberOfShares > 0
                                      : false,
                                  child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainThemeColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Text(
                                            widget.postModel.numberOfShares.toString(),
                                            style: Styles.baseTextStyle,
                                          ))),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  getFiles() {
    List<Widget> widgetList = List<Widget>();
    for(int i = 0 ; i < widget.postModel.postFilesPath.length ; i ++){
      String document = ParserHelper.parseURL(widget.postModel.postFilesPath[i]);
      widgetList.add(GestureDetector(
        onTap: (){
          PdftronFlutter.openDocument(document);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: document.endsWith(".pdf") ? AppColors.redBackgroundColor : AppColors.wordBackgroundColor,
          ),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              document.split("/")[document.split("/").length -1],
              softWrap: true,
              textAlign: TextAlign.start,
              textScaleFactor: 1,
//              maxLines: 1,
//              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.white
              ),
            ),
          ),
        ),
      ));
    }

    print(widgetList.length);
    return widgetList;
  }

}

import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/screens/CreatePostScreen.dart';
import 'package:edu360/ui/screens/FullScreenImage.dart';
import 'package:edu360/ui/screens/SinglePostScreen.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class ProfileDocumentCard extends StatelessWidget {


  final GlobalKey _cardKey = GlobalKey();
  final PostViewModel postModel ;
  final double elevation ;
  final onLike , onShare , onComment , onObjection , onPostClick , onDelete;
  ProfileDocumentCard({this.postModel, this.elevation , this.onComment, this.onDelete ,this.onPostClick , this.onLike , this.onObjection , this.onShare});
  @override
  Widget build(BuildContext context) {

    for(int i = 0 ; i < postModel.postFilesPath.length ; i++)
      print("Gesture Detector => ${postModel.postFilesPath[i]}");


    Color bgColor  = postModel.postFilesPath[0].endsWith(".pdf") ? AppColors.redBackgroundColor : AppColors.wordBackgroundColor;
    return GestureDetector(

      key: _cardKey,
      onTap: onPostClick ?? (){},
      onLongPress: (){
       RenderBox box = _cardKey.currentContext.findRenderObject();
       Offset position = box.localToGlobal(Offset.zero);
        showMenu(context: context, position: RelativeRect.fromLTRB(position.dx , position.dy , position.dx + 40 , position.dy + 60),
            items: List.generate(1, (index) => PopupMenuItem<int>(
              child:  GestureDetector(
                child: Text((LocalKeys.DELETE_LABEL).tr()),
                onTap: (){
                  onDelete();
                  Navigator.of(context).pop();
                  return;
                },
              ),
              value: 0,

            )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20)
        ),
        child:  Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  type: MaterialType.card,
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.mainThemeColor,

                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: postModel.ownerImagePath, fit: BoxFit.cover , ),
                                ),
                                //child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  postModel.ownerName ?? '',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5,left: 5),
                            child: Wrap(
                              direction: Axis.vertical,
                              spacing: 5,
                              children: [
                                Text(
                                  postModel.postBody ?? '',
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.mainThemeColor
                                  ),
                                ),
                                SizedBox(height: 5,),
                                ...postModel.postFilesPath.map((document) => GestureDetector(
                                  onTap: (){
                                    if(document.endsWith('.png') || document.endsWith('.jpg')){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FullScreenImage(imagePath: document , source: ImageSource.NETWORK)));
                                      return ;
                                    }
                                    PdftronFlutter.openDocument(document);
                                  },
                                  child: Text(
                                    document.split("/")[document.split("/").length -1],
                                    textAlign: TextAlign.start,
                                    textScaleFactor: 1,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: AppColors.white
                                    ),
                                  ),
                                )).toList(),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width,
                  height: .65,
                ),
                SizedBox(
                  height: 10,
                ),
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
                                child: InkWell(
                                    onTap: (){
                                      if(onLike != null)
                                        onLike();
                                      return;
                                    },
                                    child: Icon(postModel.isLiked ?? false ? Icons.favorite  : Icons.favorite_border ,color: AppColors.mainThemeColor,))),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfLikes != null
                                  ? postModel.numberOfLikes > 0
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
                                        postModel.numberOfLikes.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: 25,
                                width: 25,
                                child: InkWell(
                                  onTap: () {
                                    onComment("Comment");
                                      return;
                                  },
                                  child: Image(
                                      image: AssetImage(
                                          Resources.COMMENT_IMAGE)) ??
                                          () {},
                                ),
                            ),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfComments != null
                                  ? postModel.numberOfComments > 0
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
                                        postModel.numberOfComments.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: InkWell(
                                  onTap: () {
                                      onObjection("Objection");
                                      return;
                                  },
                                  child: Image.asset(Resources.OBJECTION_IMAGE , width: 25, height: 25,)) ?? () {},
                            ),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfObjections != null
                                  ? postModel.numberOfObjections > 0
                                  : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.redBackgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        postModel.numberOfObjections.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if(onShare != null)
                                        onShare("Share");
                                      return;
                                    },
                                    child: Image(
                                        image: AssetImage(
                                            Resources.SHARE_IMAGE)) ??
                                            () {},
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfShares != null
                                  ? postModel.numberOfShares > 0
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
                                        postModel.numberOfShares.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

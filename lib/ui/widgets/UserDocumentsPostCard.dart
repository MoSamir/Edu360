import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class UserDocumentsPostCard extends StatefulWidget {


  final PostViewModel postModel ;
  UserDocumentsPostCard({this.postModel});


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
        elevation: 5,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.comment ,color: Colors.blue , size: 25,) , padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.comment ,color: Colors.red, size: 25,) , padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue, size: 25,) , padding: EdgeInsets.all(0), onPressed: (){},),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.share,),
                      onPressed: (){},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

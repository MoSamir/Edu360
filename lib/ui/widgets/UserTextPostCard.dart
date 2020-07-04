import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class UserTextPostCard extends StatefulWidget {
  @override
  _UserTextPostCardState createState() => _UserTextPostCardState();
}

class _UserTextPostCardState extends State<UserTextPostCard> {
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
                      child:Text('Username' , textScaleFactor: 1,),
                    ),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.linear_scale , color: Colors.black,),),
                  ],
                ),
                SizedBox(height: 10,),
                Text('ContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContent' , textScaleFactor: 1,maxLines: 10, overflow: TextOverflow.ellipsis,),
                SizedBox(height: 10,),
                Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .25,),
                Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.comment ,color: Colors.blue , size: 20,) , padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.comment ,color: Colors.red, size: 20,) , padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue, size: 20,) , padding: EdgeInsets.all(0), onPressed: (){},),

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

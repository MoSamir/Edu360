import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class UserDocumentsPostCard extends StatefulWidget {
  @override
  _UserDocumentsPostCardState createState() => _UserDocumentsPostCardState();
}

class _UserDocumentsPostCardState extends State<UserDocumentsPostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
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
                      child: Center(child:Text('S' , style: Styles.baseTextStyle,),),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child:Text('Username' ,),
                    ),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.linear_scale , color: Colors.black,),),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Post Description" , maxLines: 2, textAlign: TextAlign.start,),
                SizedBox(height: 5,),
                ListView.builder(itemBuilder: (context, index){
                  return Card(
                    elevation: 5,
                    child: Container(
                      height: 50,
                      child: Padding(padding: EdgeInsets.all(8), child: Text('PDF File Name'),),
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                } , physics: NeverScrollableScrollPhysics() ,itemCount: 2, shrinkWrap: true,),
                SizedBox(height: 10,),
                Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.comment ,color: Colors.blue), onPressed: (){},),
                        IconButton(icon: Icon(Icons.comment ,color: Colors.red), onPressed: (){},),
                        IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue), onPressed: (){},),
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

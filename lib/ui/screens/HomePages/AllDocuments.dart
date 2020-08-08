import 'package:edu360/data/models/PostViewModel.dart';
import 'package:flutter/material.dart';

import '../../UIHelper.dart';
class AllDocuments extends StatefulWidget {

  List<PostViewModel> posts ;
  AllDocuments(this.posts);

  @override
  _AllDocumentsState createState() => _AllDocumentsState();
}

class _AllDocumentsState extends State<AllDocuments> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ListView(
        children: <Widget>[

          Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text('Top Research',
//                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.mainThemeColor),),
//                  ),
                  GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 17.0,
                      childAspectRatio: 0.545,
                      crossAxisCount: 2,
                      primary: false,
                      children: List.generate(
                        widget.posts != null ? widget.posts.length: 0,
                            (index) {
                          return UIHelper.getProfilePostView(widget.posts[index], context , postAction: (){});
                        },
                      ))
                ],
              )
          ),
        ],
      ),
    );
  }

}

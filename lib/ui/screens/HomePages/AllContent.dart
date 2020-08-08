//import 'package:edu360/ui/widgets/DocsContainer.dart';
//import 'package:edu360/utilities/AppStyles.dart';
//import 'package:edu360/utilities/Resources.dart';
//import 'package:flutter/material.dart';
//
//class AllContent extends StatefulWidget {
//  @override
//  _AllContentState createState() => _AllContentState();
//}
//
//class _AllContentState extends State<AllContent> {
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
//      child: ListView(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 0),
//            child: SizedBox(
//              height: 120,
//              child: ListView.builder(
//                  shrinkWrap: true,
//                  itemCount: 10,
//                  scrollDirection: Axis.horizontal,
//                  itemBuilder: (context, index) {
//                    return story(index);
//                  }),
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.all(5),
//            width: MediaQuery.of(context).size.width,
//            color: Colors.white,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                    child: Text(
//                      'See more',
//                      style: TextStyle(
//                          fontSize: 14,
//                          color: AppColors.mainThemeColor,
//                          fontWeight: FontWeight.bold),
//                      textAlign: TextAlign.end,
//                    )),
//
//                Icon(
//                  Icons.arrow_forward_ios,
//                  size: 15,
//                )
//              ],
//            ),
//          ),
//         SizedBox(height: 20,),
//         Container(
//           color: Colors.white,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Content',
//                     style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.mainThemeColor),),
//                 ),
//                 GridView.count(
//                     shrinkWrap: true,
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 10.0, vertical: 20.0),
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 17.0,
//                     childAspectRatio: 0.545,
//                     crossAxisCount: 2,
//                     primary: false,
//                     children: List.generate(
//                       4,
//                           (index) {
//                         return DocsContainer();
//                       },
//                     ))
//               ],
//             )
//         ),
//        ],
//      ),
//    );
//  }
//
//  Widget story(int index) {
//    return Container(
//      padding: EdgeInsets.all(5),
//      color: Colors.white,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Stack(
//            children: <Widget>[
//              SizedBox(
//                height: 20,
//              ),
//              CircleAvatar(
//                backgroundColor: AppColors.mainThemeColor,
//                radius: 30,
//              ),
//              Container(
////                margin: EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
//                height: 20,
//                width: 20,
//                decoration: BoxDecoration(
//                  color: Colors.black,
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(10),
//                      topRight: Radius.circular(10),
//                      bottomLeft: Radius.circular(10),
//                      bottomRight: Radius.circular(10)),
//                ),
//                child: Center(
//                  child: Text(
//                    "$index",
//                    style: TextStyle(color: Colors.white),
//                  ),
//                ),
//              )
//            ],
//          ),
//          SizedBox(
//            height: 5,
//          ),
//          Text('Name ...'),
//          SizedBox(
//            height: 5,
//          ),
//          Text('Category'),
//        ],
//      ),
//    );
//  }
//
//}

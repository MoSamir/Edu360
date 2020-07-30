import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
class DocsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          color: AppColors.redBackgroundColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child:  Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                type: MaterialType.card,
                color: AppColors.redBackgroundColor,
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
                                color: AppColors.white,
                              ),
                              //child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                'Name',
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
                            children: <Widget>[
                              Text(
                                'Pdf Name Category',
                                textAlign: TextAlign.start,
                                textScaleFactor: 1,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.white
                                ),
                              ),
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
                                  onTap:() {},
                                  child: Icon(Icons.favorite,color: AppColors.mainThemeColor,))),
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

                                },
                                child: Image(
                                    image: AssetImage(
                                        Resources.COMMENT_CON_IMAGE)) ??
                                        () {},
                              )),
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

                                },
                                child: Image(
                                    image: AssetImage(
                                        Resources.COMMENT_ERROR_IMAGE)) ??
                                        () {},
                              )),

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

                                  },
                                  child: Image(
                                      image: AssetImage(
                                          Resources.SHARE_IMAGE)) ??
                                          () {},
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
              SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}

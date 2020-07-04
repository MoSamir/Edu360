import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/UserVideoPostCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.backgroundColor,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 14 , left: 12, right: 12),
          itemBuilder: (context , index) {
          return index == 1 ? UserDocumentsPostCard() : index == 2 ? UserVideoPostCard() : UserTextPostCard();
        } , itemCount: 3, shrinkWrap: true,),

    );
  }
}

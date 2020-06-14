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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        child: EduAppBar(icon: Icons.search,),
preferredSize: Size.fromHeight(kToolbarHeight + 50),
      ),
      body: Container(
//        margin: const EdgeInsets.only(top: 50),
        child: ListView.builder(itemBuilder: (context , index) {
          return index == 1 ? UserDocumentsPostCard() : index == 2 ? UserVideoPostCard() : UserTextPostCard();
        } , itemCount: 3, shrinkWrap: true,),
      ),
    );
  }
}

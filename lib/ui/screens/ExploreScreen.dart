import 'package:edu360/blocs/bloc/ExploreBloc.dart';
import 'package:edu360/blocs/events/ExploreEevnts.dart';
import 'package:edu360/blocs/states/ExploreStates.dart';
import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/CategoryPostsCardWidget.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduCircleAvatar.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'SingleCourseScreen.dart';
class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  ExploreBloc _exploreBloc = ExploreBloc();

  @override
  void initState() {
    super.initState();
    _exploreBloc.add(LoadExploreInformation());
  }

  @override
  void dispose() {
    _exploreBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
        autoImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(LocalKeys.TUTORS_FOR_YOU , style: Styles.baseTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainThemeColor,
                      ),).tr(),
                      SizedBox(height: 10,),
                      Container(
                        height: 150,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                                return EduCircleAvatar(
                                  showUserInformation: true,
                                  userModel: UserViewModel(
                                    profileImagePath: "https://www.pinclipart.com/picdir/middle/142-1421318_abdu-sentamu-person-image-placeholder-clipart.png",
                                  ),
                                  userRate: index+1,
                                );
                          }),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(LocalKeys.SHOW_MORE , style: Styles.baseTextStyle.copyWith(
                              color: AppColors.mainThemeColor,
                            ),).tr(),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios , color: AppColors.mainThemeColor, size: 15,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .5,
                child: BlocConsumer(
                  builder: (context, state){
                    return ModalProgressHUD(
                      inAsyncCall: state is ExploreScreenLoading,
                      child: (_exploreBloc.courses != null && _exploreBloc.courses.length > 0) ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(crossAxisCount: 3 ,crossAxisSpacing: 5 , mainAxisSpacing: 5 ,childAspectRatio: .45 ,shrinkWrap: true,
                          children: _exploreBloc.courses.map((CourseViewModel course) => CourseCard(course: course, onCourseCardPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SingleCourseScreen(courseModel :course)));
                          },)).toList(),),
                      ) :
                      Center(
                        child: PlaceHolderWidget(
                          placeHolder: Text(LocalKeys.SERVER_UNREACHABLE).tr(),
                          placeHolderIcon: IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: (){
                              _exploreBloc.add(LoadExploreInformation());
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  bloc: _exploreBloc,
                  listener: (context , state){},
                ),
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}

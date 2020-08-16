import 'package:edu360/blocs/bloc/CategoriesBloc.dart';
import 'package:edu360/blocs/events/CategoriesEvents.dart';
import 'package:edu360/blocs/states/CategoriesStates.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  final Function moveToScreen;
  CategoriesScreen(this.moveToScreen);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  CategoriesBloc categoriesBloc;

  @override
  void initState() {
    super.initState();
    categoriesBloc = CategoriesBloc();
    categoriesBloc.add(LoadAppCategories());
  }

  @override
  void dispose() {
    categoriesBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        bloc: categoriesBloc,
        listener: (context, state){},
        builder: (context, state){
          if(state is CategoriesLoaded){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(crossAxisCount: 3 ,crossAxisSpacing: 5 , mainAxisSpacing: 5 ,childAspectRatio: .45 ,shrinkWrap: true, children: categoriesBloc.systemCategories.map((e) => Container(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      child: (e.studyField.imagePath != null) ? Image.network(e.studyField.imagePath , fit: BoxFit.contain,) : Image.asset( Resources.SPLASH_BG_IMAGE , fit: BoxFit.contain,),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    SizedBox(height: 5,),
                    Text(e.studyField.getStudyFieldName(context), style: Styles.baseTextStyle.copyWith(
                      color: AppColors.mainThemeColor,
                    ),),
                  ],
                ),
              )).toList(),),
            );
          } else if(state is CategoriesLoadingFailed){
            return Container();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

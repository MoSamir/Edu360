
import 'package:edu360/ui/screens/explore_pages/HomePage.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EduAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title ;
  final bool centerTitle , autoImplyLeading ;
  final List<Widget> actions;
  final Color backgroundColor ;
  final Function onIconPressed ;
  final Widget icon;
  final double logoWidth;
  final double logoHeight;

  EduAppBar({this.title, this.centerTitle, this.autoImplyLeading,
    this.actions, this.backgroundColor, this.onIconPressed, this.icon,this.logoWidth,this.logoHeight});

  @override
  Widget build(BuildContext context) {

    double appBarHeight = kToolbarHeight  , appBarContent = kToolbarHeight;
    if(icon != null) {
      appBarHeight = kToolbarHeight + 50;
      appBarContent = kToolbarHeight + 30 ;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark
    ));
    return PreferredSize(
      child: SafeArea(
        child: Container(
          height: appBarHeight,
          child: Stack(
            children: <Widget>[
              SizedBox(height: appBarContent , child: AppBar(
                title: Text(title ?? '' , textScaleFactor: 1,),
                centerTitle: centerTitle ?? false,
                elevation: 2,
                actions: actions ?? [],
                automaticallyImplyLeading: autoImplyLeading ?? false,
                backgroundColor: backgroundColor ?? Colors.white,
              ),),
              icon != null ? Positioned(
                height: 50,
                width: 50,
                top: kToolbarHeight,
                left: (MediaQuery.of(context).size.width * .5) - 25,
                child: GestureDetector(
                  onTap: onIconPressed ?? (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  },
                  child: Material(
                    elevation: 3,
                    shadowColor: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      child: icon,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ), ),
                  ),
                ),
              ) : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: autoImplyLeading?? false ? 50: 15, vertical: 20),
                child: Align(alignment: AlignmentDirectional.topStart, child: Image.asset(Resources.REF360_IMAGE , width: logoWidth ?? MediaQuery.of(context).size.width * .25, height: logoHeight ?? 40, alignment: AlignmentDirectional.centerStart, fit: BoxFit.contain,),),
              )
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(appBarHeight),
    );
  }


  @override
  Size get preferredSize => icon != null ? Size.fromHeight(kToolbarHeight + 50) : Size.fromHeight(kToolbarHeight);
}

import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EduAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title ;
  final bool centerTitle , autoImplyLeading;
  final List<Widget> actions;
  final Color backgroundColor ;
  final Function onIconPressed ;
  final IconData icon;
  final double logoWidth;
  final double logoHeight;

  EduAppBar({this.title, this.centerTitle, this.autoImplyLeading,
    this.actions, this.backgroundColor, this.onIconPressed, this.icon,this.logoWidth,this.logoHeight});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark
    ));
    return PreferredSize(
      child: Container(
        height: kToolbarHeight + 50,
        child: Stack(
          children: <Widget>[
            SizedBox(height: kToolbarHeight + 30, child: AppBar(
              title: Text(title ?? '' , textScaleFactor: 1,),
              centerTitle: centerTitle ?? false,
              elevation: 2,
              actions: actions ?? [],
              automaticallyImplyLeading: autoImplyLeading ?? true,
              backgroundColor: backgroundColor ?? Colors.white,

            ),),
            icon != null ? Positioned(
              height: 50,
              width: 50,
              top: kToolbarHeight,
              left: (MediaQuery.of(context).size.width * .5) - 25,
              child: GestureDetector(
                onTap: onIconPressed ?? (){},
                child: Material(
                  shadowColor: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(child: Icon(icon , color: Colors.white, size: 25,), decoration: BoxDecoration(
                    color: AppColors.mainThemeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.backgroundColor,
                      width: 5,
                    )
                  ), ),
                ),
              ),
            ) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,),
              child: Align(alignment: AlignmentDirectional.centerStart, child: Image.asset(Resources.REF360_IMAGE , width: logoWidth ?? MediaQuery.of(context).size.width / 2, height: logoHeight ?? 40, alignment: AlignmentDirectional.centerStart, fit: BoxFit.contain,),),
            )
          ],
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight + 50),
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 50);
}

import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class EduButton extends StatefulWidget {

  final String title ;
  final Function onPressed;

  final TextStyle style ;
  final double cornerRadius ;
  final Color bgColor , borderColor;

  EduButton({this.title , this.onPressed , this.style , this.bgColor , this.borderColor , this.cornerRadius});


  @override
  _EduButtonState createState() => _EduButtonState();
}

class _EduButtonState extends State<EduButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.cornerRadius ??  8),
          side: BorderSide(color: widget.borderColor ?? Colors.transparent),
        ),
        elevation: 2,
        color: widget.bgColor ?? Colors.white,
        onPressed: widget.onPressed,
        child: Text(widget.title ?? ''  , style: widget.style ?? Styles.baseTextStyle.copyWith(
          color: widget.bgColor != null ? widget.bgColor == AppColors.mainThemeColor ? AppColors.white : AppColors.mainThemeColor :AppColors.mainThemeColor,
          fontSize: 16,
        ), textScaleFactor: 1,).tr(),
      ),
    );
  }

}

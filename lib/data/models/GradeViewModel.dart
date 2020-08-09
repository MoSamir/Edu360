import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

class GradeViewModel {
  int gradeId ;
  String gradeNameAr , gradeNameEn ;


  @override
  String toString() {
    return 'GradeViewModel{gradeId: $gradeId, gradeNameAr: $gradeNameAr, gradeNameEn: $gradeNameEn}';
  }

  GradeViewModel({this.gradeId, this.gradeNameAr, this.gradeNameEn});

  static fromJson(Map<String,dynamic> gradeJson){

    print("*****************GRADE JSON*****************************");
    print(gradeJson);
    print("**********************************************");



    return GradeViewModel(
      gradeId: gradeJson[ApiParseKeys.ID],
      gradeNameAr: gradeJson[ApiParseKeys.GRADE_NAME_AR],
      gradeNameEn: gradeJson[ApiParseKeys.GRADE_NAME_EN],
    );
  }


  static fromListJson(List<dynamic> gradeListJson){
    List<GradeViewModel> gradesList = List();
    if(gradeListJson is List){
      for(int i = 0 ; i < gradeListJson.length ; i++)
        gradesList.add(GradeViewModel.fromJson(gradeListJson[i]));
    }


    return gradesList;
  }


}
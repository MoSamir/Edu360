import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter/cupertino.dart';

class StudyFieldViewModel {
  String studyFieldNameAr, studyFieldNameEn , studyFieldDescAr , studyFieldDescEn ,  imagePath;
  int studyFieldId ;




  getStudyFieldName(BuildContext context){
   return EasyLocalization.of(context).locale.languageCode == "en" ? studyFieldNameEn : studyFieldNameAr ;
  }
  getStudyFieldDescription(BuildContext context){
    return EasyLocalization.of(context).locale.languageCode == "en" ? studyFieldDescEn : studyFieldDescAr ;
  }




  @override
  String toString() {
    return 'StudyFieldViewModel{studyFieldNameAr: $studyFieldNameAr, studyFieldNameEn: $studyFieldNameEn, studyFieldDescAr: $studyFieldDescAr, studyFieldDescEn: $studyFieldDescEn, studyFieldId: $studyFieldId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyFieldViewModel &&
          runtimeType == other.runtimeType &&
          studyFieldNameAr == other.studyFieldNameAr &&
          studyFieldNameEn == other.studyFieldNameEn &&
          studyFieldDescAr == other.studyFieldDescAr &&
          studyFieldDescEn == other.studyFieldDescEn &&
          studyFieldId == other.studyFieldId;

  @override
  int get hashCode =>
      studyFieldNameAr.hashCode ^
      studyFieldNameEn.hashCode ^
      studyFieldDescAr.hashCode ^
      studyFieldDescEn.hashCode ^
      studyFieldId.hashCode;

  StudyFieldViewModel({this.studyFieldNameAr, this.studyFieldNameEn,
      this.studyFieldDescAr, this.studyFieldDescEn, this.studyFieldId , this.imagePath});

  static List<StudyFieldViewModel> fromListJson(List<dynamic> studyFieldsListJson){
    List<StudyFieldViewModel> studyFields = List();
    if(studyFieldsListJson!=null && studyFieldsListJson is List){
      for(int i = 0 ; i < studyFieldsListJson.length ; i++){
        studyFields.add(StudyFieldViewModel.fromGetAllJson(studyFieldsListJson[i]));
      }
    }
    return studyFields;
  }
  static StudyFieldViewModel fromGetAllJson(studyFieldJson) {
    return StudyFieldViewModel(
      studyFieldDescAr: studyFieldJson[ApiParseKeys.DESCRIPTION_AR],
      studyFieldDescEn: studyFieldJson[ApiParseKeys.DESCRIPTION_EN],
      studyFieldNameAr: studyFieldJson[ApiParseKeys.NAME_AR],
      studyFieldNameEn: studyFieldJson[ApiParseKeys.NAME_EN],
      studyFieldId: studyFieldJson[ApiParseKeys.FIELD_OF_STUDY_ID],
    );
  }


  static StudyFieldViewModel fromUserJson(studyFieldJson) {
    return StudyFieldViewModel(
      studyFieldDescAr: studyFieldJson[ApiParseKeys.DESCRIPTION_AR],
      studyFieldDescEn: studyFieldJson[ApiParseKeys.DESCRIPTION_EN],
      studyFieldNameAr: studyFieldJson[ApiParseKeys.NAME_AR],
      studyFieldNameEn: studyFieldJson[ApiParseKeys.NAME_EN],
      studyFieldId: studyFieldJson[ApiParseKeys.FIELD_OF_STUDY_ID],
    );
  }







}
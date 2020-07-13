import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

class StudyFieldViewModel {
  String studyFieldNameAr, studyFieldNameEn , studyFieldDescAr , studyFieldDescEn ;
  int studyFieldId ;

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
      this.studyFieldDescAr, this.studyFieldDescEn, this.studyFieldId});

  static List<StudyFieldViewModel> fromListJson(List<dynamic> studyFieldsListJson){
    List<StudyFieldViewModel> studyFields = List();
    if(studyFieldsListJson!=null && studyFieldsListJson is List){
      for(int i = 0 ; i < studyFieldsListJson.length ; i++){
        studyFields.add(StudyFieldViewModel.fromJson(studyFieldsListJson[i]));
      }
    }
    return studyFields;
  }

  static StudyFieldViewModel fromJson(studyFieldJson) {




    return StudyFieldViewModel(
      studyFieldDescAr: studyFieldJson[ApiParseKeys.DESCRIPTION_AR],
      studyFieldDescEn: studyFieldJson[ApiParseKeys.DESCRIPTION_EN],
      studyFieldNameAr: studyFieldJson[ApiParseKeys.NAME_AR],
      studyFieldNameEn: studyFieldJson[ApiParseKeys.NAME_EN],
      studyFieldId: studyFieldJson[ApiParseKeys.FIELD_OF_STUDY_ID],
    );
  }






}
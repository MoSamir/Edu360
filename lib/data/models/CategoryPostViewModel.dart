import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';

class CategoryPostViewModel {
  StudyFieldViewModel studyField ;
  List<PostViewModel> fieldPosts ;
  CategoryPostViewModel({this.studyField , this.fieldPosts});
}
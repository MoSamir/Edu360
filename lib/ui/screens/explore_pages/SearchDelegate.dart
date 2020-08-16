import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/screens/explore_pages/AllContent.dart';
import 'package:flutter/material.dart';

class ContentSearch extends SearchDelegate{

  List<dynamic> coursesSpace , teachersSpace , postsSpace , userSpace ;
  ContentSearch({this.coursesSpace , this.teachersSpace , this.postsSpace , this.userSpace});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<PostViewModel> filteredPosts = getFilteredPosts();
    List<UserViewModel> filteredUsers = getFilteredUsers();
    List<UserViewModel> filteredTeachers = getFilteredTeachers();
    List<CourseViewModel> filteredCourses = getFilteredCourses();

    return AllContent(
      courses: filteredCourses,
      posts: filteredPosts,
      teachers: filteredTeachers,
      users: filteredUsers,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return AllContent(
      courses: coursesSpace,
      posts: postsSpace,
      teachers: teachersSpace,
      users: userSpace,
    );
  }

  List<PostViewModel> getFilteredPosts() {
    List<PostViewModel> filteredPosts = List();
    for(int i = 0 ; i < postsSpace.length ; i++){
      PostViewModel post = postsSpace[i];
      if(post.canMatch(query))
        filteredPosts.add(post);
    }
    return filteredPosts;
  }
  List<UserViewModel> getFilteredUsers() {
    List<UserViewModel> filteredUsers = List();
    for(int i = 0 ; i < userSpace.length ; i++){
      UserViewModel user = userSpace[i];
      if(user.canMatch(query))
        filteredUsers.add(user);
    }
    return filteredUsers;
  }
  List<UserViewModel> getFilteredTeachers() {
    List<UserViewModel> filteredUsers = List();
    for(int i = 0 ; i < teachersSpace.length ; i++){
      UserViewModel user = teachersSpace[i];
      if(user.canMatch(query))
        filteredUsers.add(user);
    }
    return filteredUsers;
  }
  List<CourseViewModel> getFilteredCourses() {
    List<CourseViewModel> filteredCourses = List();
    for(int i = 0 ; i < coursesSpace.length ; i++){
      CourseViewModel course = coursesSpace[i];
      if(course.canMatch(query))
        filteredCourses.add(course);
    }
    return filteredCourses;
  }
}
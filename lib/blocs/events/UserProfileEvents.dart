abstract class UserProfileEvents {}

class LoadUserProfile extends UserProfileEvents{
  final int userId ;
  LoadUserProfile({this.userId});
}

class UnfollowUser extends UserProfileEvents{
  final int userId ;
  UnfollowUser({this.userId});
}

class FollowUser extends UserProfileEvents{
  final int userId ;
  FollowUser({this.userId});
}


class LoadOtherUsersProfile extends UserProfileEvents{
  final int userId ;
  LoadOtherUsersProfile({this.userId});
}
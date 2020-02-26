

class User{
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String bio;
  final String email;
  final String age;
  final String gender;
  final String profilePhoto;
  final String phoneNumber;
  final String loginType;

  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.email, 
    this.age,
    this.gender,
    this.profilePhoto,
    this.phoneNumber,
    this.loginType,
  });


  factory User.fromGoogle(){
    return User();
  }


}
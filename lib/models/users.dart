

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String userName;
  final String displayName;
  final String firstName;
  final String lastName;
  final String bio;
  final String email;
  final String age;
  final String gender;
  final String profilePhoto;
  final String phoneNumber;
  final int accountType;
  final Timestamp dateCreated;
  final Timestamp dateUpdated;

  User({
    this.id,
    this.userName,
    this.displayName,
    this.firstName,
    this.lastName,
    this.bio,
    this.email, 
    this.age,
    this.gender,
    this.profilePhoto,
    this.phoneNumber,
    this.accountType,
    this.dateCreated,
    this.dateUpdated,
  });


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['userName'] = userName;
    map['displayName'] = displayName;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['bio'] = bio;
    map['email'] = email;
    map['age'] = age;
    map['gender'] = gender;
    map['profilePhoto'] = profilePhoto;
    map['phoneNumber'] = phoneNumber;
    map['accountType'] = accountType;
    map['dateCreated'] = dateCreated;
    map['dateUpdated'] = dateUpdated;
  }

  
  factory User.fromDocument( doc){
    return User(
      id:  doc["id"], 
      // userName: doc['username'],
      // displayName: doc['displayName'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      bio: doc['bio'],
      email: doc['email'],
      age: doc['age'],
      gender: doc['gender'],
      profilePhoto: doc['profilePhoto'],
		  phoneNumber: doc['phoneNumber'],
      accountType: doc['accountType'],
      dateCreated: doc['dateCreated'],
      dateUpdated: doc['dateUpdated'],
    );
  }

  factory User.fromNewRegister(userInfo){
    return User(
      id: userInfo['id'],  
      email: userInfo['email'],
      firstName: userInfo['firstName'],
      lastName: userInfo['lastName'],
      profilePhoto: userInfo['photo'],
      dateCreated:  Timestamp.fromDate( userInfo['dateCreated']), 
      dateUpdated: Timestamp.fromDate( userInfo['dateUpdated']),

    );    
  }
  
}
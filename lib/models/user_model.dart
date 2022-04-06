class UserModel{
  String? name;
  String? email;
  String? photourl;
  String? bannercolor;
  UserModel(this.name,this.email,this.photourl);

  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "email":email,
      "photourl":photourl,
    };
  }
}
class AppUser {
  String name;
  String uid;
  String profile;
  AppUser(this.name, this.uid, this.profile);

  @override
  int get hashCode => Object.hash(uid, name);

  @override
  operator ==(Object other) => other is AppUser && uid == other.uid;

  Map<String, dynamic> toMap() {
    return {'name': name, 'uid': uid, 'profile': profile};
  }

  AppUser fromMap() {
    return AppUser(name, uid, profile);
  }

  AppUser.fromFirestore(Map<String, dynamic> firestoreMap)
      : name = firestoreMap['name'],
        uid = firestoreMap['uid'],
        profile = firestoreMap['photourl'];
}

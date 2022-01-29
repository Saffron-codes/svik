String chatRoomId(String user1, String user2) {
    // if (user2[0].toLowerCase().codeUnits[0] >
    //     user1.toLowerCase().codeUnits[0]) {
    //   return "$user1$user2";
    // } else {
    //   return "$user2$user1";
    // }
    return user1.hashCode <= user2.hashCode
    ? user1 + "-"+ user2: user2 + "-"+ user1;
  }
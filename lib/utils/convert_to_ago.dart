DateTime dateTime =  DateTime.now();

String convertToAgo(DateTime input) {
    Duration difference = dateTime.difference(input);

    if (difference.inDays>=31){
      return '${(difference.inDays/30).toInt()} mon ago';
    }
    else if (difference.inDays>=1 && difference.inDays<30) {
      if(difference.inDays == 1){
        return '${difference.inDays} day ago'; 
      }
      return '${difference.inDays} days ago';
    }
     else if (difference.inHours >= 1 && difference.inHours<24) {
       if(difference.inDays == 1){
        return '${difference.inHours} hour ago'; 
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1 && difference.inMinutes <60) {
      if(difference.inMinutes == 1){
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inMinutes} mins ago';
    } else if (difference.inSeconds >= 1 && difference.inSeconds <60) {
      return '${difference.inSeconds} sec ago';
    }
    else {
      return 'just now';
    }
  }
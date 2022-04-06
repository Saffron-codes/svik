DateTime dateTime =  DateTime.now();

String convertToAgo(DateTime input,DateTime currentTime) {
    Duration difference = currentTime.difference(input);

    if (difference.inDays>=31){
      return '${(difference.inDays/30).toInt()} mon ago';
    }
    else if (difference.inDays>=1 && difference.inDays<30) {
      if(difference.inDays == 1){
        return '${difference.inDays} d ago'; 
      }
      return '${difference.inDays} d ago';
    }
     else if (difference.inHours >= 1 && difference.inHours<24) {
       if(difference.inDays == 1){
        return '${difference.inHours} h ago'; 
      }
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes >= 1 && difference.inMinutes <60) {
      if(difference.inMinutes == 1){
        return '${difference.inMinutes} m ago';
      }
      return '${difference.inMinutes} m ago';
    } else if (difference.inSeconds >= 1 && difference.inSeconds <60) {
      return '${difference.inSeconds} sec ago';
    }
    else {
      return 'just now';
    }
  }
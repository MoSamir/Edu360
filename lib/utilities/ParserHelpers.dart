import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/apis/helpers/URL.dart';

class ParserHelper {

  static String parseURL(String url){
    if(url == null) return url;

    if(url.contains(URL.BASE_URL)) return url ;
    return URL.BASE_URL + "/" + url;
  }

}
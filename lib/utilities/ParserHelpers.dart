import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';

class ParserHelper {

  static String parseURL(String url){

try{
  url.replaceFirst('[','');
  url.replaceFirst(']', '');
} catch(exception){}

try{



  url = url.split("\\").join("/");

  String tempURL = "";
  for(int i = 0 ; i <url.length ; i++){
    if(url[i] == '\\') tempURL+="/";
    else tempURL+=url[i];
  }
  url = tempURL;
} catch(exception){

}


    if(url == null) return url;
    if(url.contains(URL.BASE_URL)) return url ;
    return URL.BASE_URL + "/" + url;
  }
  static Future<String> getFileFromNetwork(String url) async {
    final store = await CacheStore.getInstance();
    final file = await store.getFile(url);
    return file.path;
  }


}
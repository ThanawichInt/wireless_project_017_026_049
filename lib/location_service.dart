import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:logger/logger.dart';

class LocationService {
  final String key = 'AIzaSyBLeC5zLpf2gZx6IV5AZZRTY5X-WnQiLG8';

  Future<String> getPlaceID(String index) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$index&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json["candidates"][0]["place_id"] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String index) async {
    var logger = Logger();
    final placeId = await getPlaceID(index); // changed variable name to placeId
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = json['result'] as Map<String, dynamic>;

    print(result);
    return result;
  }
}

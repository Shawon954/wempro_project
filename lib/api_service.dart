import 'data_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = 'http://team.dev.helpabode.com:54292/api/wempro/flutter-dev/coding-test-2024/';



  Future<Getdata> fetchData() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    return getdataFromJson(response.body);
  } else {
  throw Exception('Failed to load data');
  }
  }

}

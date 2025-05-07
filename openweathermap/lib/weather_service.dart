import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'bee8bf8df6a4b192ab8e6d6b1ee5e2dd'; // Thay bằng API key mới
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/onecall';

  Future<List<Map<String, dynamic>>> fetchDailyWeather(double lat, double lon) async {
    final url = Uri.parse(
        '$baseUrl?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&units=metric&appid=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Kiểm tra xem dữ liệu có trường 'daily' không
        if (data.containsKey('daily')) {
          final daily = data['daily'] as List;
          return daily.take(7).map((day) {
            return {
              'date': DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000).toLocal(),
              'temp': day['temp']['day'],
              'weather': day['weather'][0]['description'],
              'icon': day['weather'][0]['icon'],
            };
          }).toList();
        } else {
          throw Exception('Dữ liệu không chứa trường "daily".');
        }
      } else {
        // In thông tin lỗi để debug
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi kết nối hoặc lỗi không mong muốn
      print('Exception: $e');
      throw Exception('Failed to load weather data. Error: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  WeatherService(this.apiKey);

  Future<List<Map<String, dynamic>>> fetchDailyForecast(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Lọc dữ liệu dự báo hàng ngày (lấy thời điểm 12:00 mỗi ngày)
        final List forecasts = data['list'];
        final dailyForecasts = forecasts.where((forecast) {
          final dateTime = DateTime.parse(forecast['dt_txt']);
          return dateTime.hour == 12; // Lấy thời điểm 12:00 mỗi ngày
        }).map((forecast) {
          return {
            'date': DateTime.parse(forecast['dt_txt']),
            'temp': forecast['main']['temp'],
            'weather': forecast['weather'][0]['description'],
            'icon': forecast['weather'][0]['icon'],
          };
        }).toList();

        return dailyForecasts;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid API key.');
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the city name.');
      } else {
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load weather data. Error: $e');
    }
  }
}
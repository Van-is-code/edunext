import 'package:flutter/material.dart';
import 'package:openweathermap/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<List<Map<String, dynamic>>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchDailyWeather(21.0285, 105.8542); // Lat/Lon của Hà Nội
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dự báo thời tiết 7 ngày'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            final weatherList = snapshot.data!;
            return ListView.builder(
              itemCount: weatherList.length,
              itemBuilder: (context, index) {
                final weather = weatherList[index];
                return ListTile(
                  leading: Image.network(
                      'https://openweathermap.org/img/wn/${weather['icon']}@2x.png'),
                  title: Text(
                      '${weather['date'].toString().substring(0, 10)} - ${weather['temp']}°C'),
                  subtitle: Text('${weather['weather']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
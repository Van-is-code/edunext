import 'package:flutter/material.dart';
import 'package:openweathermap/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService('3d608afabef942c675a598dc9533a621'); // Thay bằng API key hợp lệ
  late Future<List<Map<String, dynamic>>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchDailyForecast('Hanoi'); // Thay 'Hanoi' bằng tên thành phố bạn muốn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dự báo thời tiết 5 ngày'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Lỗi: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _weatherFuture = _weatherService.fetchDailyForecast('Hanoi');
                        });
                      },
                      child: Text('Thử lại'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Không có dữ liệu',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            } else {
              final weatherList = snapshot.data!;
              return ListView.builder(
                itemCount: weatherList.length,
                itemBuilder: (context, index) {
                  final weather = weatherList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.network(
                            'https://openweathermap.org/img/wn/${weather['icon']}@2x.png',
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50);
                            },
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weather['date'].toString().substring(0, 10)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${weather['temp']}°C',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${weather['weather']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
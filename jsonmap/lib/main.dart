import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _tileUrl;
  bool _isLoading = true;

  Future<void> _loadMapStyleFromAsset() async {
    try {
      String jsonString = await rootBundle.loadString('assets/forests.json');
      Map<String, dynamic> data = json.decode(jsonString);

      setState(() {
        _tileUrl =
        'https://api.tomtom.com/style/2/custom/style/dG9tdG9tQEBARFNySTJwd0J0NklJUGk0Rzs3OGM0MGQ0Ny1iNjI1LTQ2ZjktYjkwMy0xZjhhYTA0MGMzNjY=.json?key=Q5qYfELfD7vxTAaOmnkjD7YxuxUYWslM';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading map style from asset: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyleFromAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom JSON Map'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tileUrl != null
          ? FlutterMap(
        options: MapOptions(
          center: LatLng(52.376372, 4.908066),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: _tileUrl!,
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      )
          : Center(
        child: Text('Failed to load map data.'),
      ),
    );
  }
}

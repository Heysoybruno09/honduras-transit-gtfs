import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const HonduranTransitApp());
}

class HonduranTransitApp extends StatelessWidget {
  const HonduranTransitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tránsito GTFS Honduras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TransitMapScreen(),
      // Configuración de idioma (Español por defecto)
      supportedLocales: const [Locale('es', 'HN')],
    );
  }
}

class TransitMapScreen extends StatefulWidget {
  const TransitMapScreen({super.key});

  @override
  State<TransitMapScreen> createState() => _TransitMapScreenState();
}

class _TransitMapScreenState extends State<TransitMapScreen> {
  // Centro aproximado de Honduras
  final LatLng _hondurasCenter = const LatLng(15.199999, -86.241905);
  
  // Marcadores de paradas hardcodeados de nuestro feed GTFS
  final List<Marker> _markers = [
    Marker(
      point: const LatLng(15.7667, -86.7833), // La Ceiba Ferry
      width: 40,
      height: 40,
      child: const Icon(Icons.directions_boat, color: Colors.blue, size: 30),
    ),
    Marker(
      point: const LatLng(16.3333, -86.4833), // Roatán Ferry
      width: 40,
      height: 40,
      child: const Icon(Icons.directions_boat, color: Colors.blue, size: 30),
    ),
    Marker(
      point: const LatLng(16.0967, -86.8933), // Utila Ferry
      width: 40,
      height: 40,
      child: const Icon(Icons.directions_boat, color: Colors.blue, size: 30),
    ),
    Marker(
      point: const LatLng(15.4633, -88.0161), // San Pedro Sula GCM
      width: 40,
      height: 40,
      child: const Icon(Icons.directions_bus, color: Colors.red, size: 30),
    ),
    Marker(
      point: const LatLng(14.0753, -87.2183), // Tegucigalpa
      width: 40,
      height: 40,
      child: const Icon(Icons.directions_bus, color: Colors.red, size: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas y Paradas GTFS'),
        elevation: 2,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _hondurasCenter,
          initialZoom: 7.0,
        ),
        children: [
          TileLayer(
            // Usando OSM. Para offline completo se usaría un plugin como flutter_map_tile_caching o mbtiles offline
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.honduras_transit_gtfs',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showTripPlanner(context);
        },
        label: const Text('Planear Viaje'),
        icon: const Icon(Icons.alt_route),
      ),
    );
  }

  void _showTripPlanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Planificador de Viajes GTFS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Origen (ej. San Pedro Sula)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Destino (ej. Roatán)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cargando horarios offline desde GTFS...')),
                );
              },
              child: const Text('Buscar Rutas', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

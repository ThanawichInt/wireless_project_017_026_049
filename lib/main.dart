import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_la/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:project_la/location_service.dart';
import 'package:project_la/direction_model.dart';
import 'package:project_la/direction_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: AuthPage(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(13.796986, 100.328670),
    zoom: 11.5,
  );
  final TextEditingController _searchController = TextEditingController();

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;

  void signUserout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Bar of the application
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Google Maps',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Search!",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                var place =
                    await LocationService().getPlace(_searchController.text);
                _camera(place);
              },
              icon: const Icon(Icons.search, color: Colors.black),
            ),
            IconButton(
                onPressed: signUserout,
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
        ),
      ),

      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin,
              if (_destination != null) _destination,
            },
            polylines: _info != null
                ? {
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                  }
                : {},
            onLongPress: _addMarker,
          ),
          Positioned(
            bottom: 90,
            right: 20,
            child: Container(
              height: 200,
              // color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_origin != null)
                    FloatingActionButton(
                      onPressed: () => _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _origin.position,
                            zoom: 14.5,
                            tilt: 50.0,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.my_location),
                    ),
                  const SizedBox(height: 10),
                  if (_destination != null)
                    FloatingActionButton(
                      onPressed: () => _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _destination.position,
                            zoom: 14.5,
                            tilt: 50.0,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.place, color: Colors.white),
                    ),
                  const SizedBox(height: 10),
                  if (_origin != null && _destination != null)
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _origin = null;
                          _destination = null;
                          _info = null;
                        });
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.clear),
                    ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                _info != null
                    ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(_initialCameraPosition),
              ),
              child: const Icon(Icons.center_focus_strong),
            ),
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );

        _destination = null;

        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      final directions = await DirectionRepository()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
  }

  Future<void> _camera(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _googleMapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tclearpartner/src/model/location.dart';
import 'package:tclearpartner/src/model/step_res.dart';
import 'package:tclearpartner/src/model/trips_info_res.dart';
import 'package:tclearpartner/src/repositotry/place_service.dart';
import 'package:tclearpartner/src/utils/colors.dart';

class ViewDistance extends StatefulWidget {
  final Location location;

  ViewDistance(this.location);
  @override
  _ViewDistanceState createState() => _ViewDistanceState();
}

class _ViewDistanceState extends State<ViewDistance> {
  Completer<GoogleMapController> _controller = Completer();
  bool mapToggle = false;
  var _tripDistance = 0;
  Position _currentLocation;
  double valueDistance = 0;

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        _currentLocation = currloc;
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem khoảng cách'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            child: mapToggle
                ? GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              //rotateGesturesEnabled: false,
              //scrollGesturesEnabled: false,
              //tiltGesturesEnabled: false,
              markers: _createMarker(),
              polylines: _drawPolyline(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _moveCamera();
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.location.lat, widget.location.lng),
                  zoom: 14),
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: MediaQuery.of(context).size.width -10,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: white,
                  border: Border.all(width: 1, color: Colors.black45),
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: FutureBuilder(
                  future: getDistance(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return Text('Cách vị trí của bạn khoảng: 0m');
                      case ConnectionState.done:
                        return Text('Cách vị trí của bạn khoảng: ${snapshot.data.toString()}',);
                      default:
                        return Text('Cách vị trí của bạn khoảng: 0m');
                    }

                  }
              )),
        ],
      ),
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("to_address"),
        position: LatLng(widget.location.lat, widget.location.lng),
      ),
      Marker(
        markerId: MarkerId("from_address"),
        position: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        draggable: true,
        infoWindow: InfoWindow(
          title: 'Vị trí của bạn',
          snippet: 'lol'
        ),
      ),
    ].toSet();
  }

  void _moveCamera() {
    if (mapToggle) {
      var fromLatLng = widget.location;
      var toLatLng = _currentLocation;

      var sLat, sLng, nLat, nLng;
      if (fromLatLng.lat <= toLatLng.latitude) {
        sLat = fromLatLng.lat;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.lat;
      }

      if (fromLatLng.lng <= toLatLng.longitude) {
        sLng = fromLatLng.lng;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.lng;
      }

      LatLngBounds bounds = LatLngBounds(
          northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _controller.future.then((mapController) {
        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      });
      // _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {}
  }

  List<LatLng> latlng = List();
  Set<Polyline> _drawPolyline() {
    var fromLatLng =
    LatLng(widget.location.lat, widget.location.lng); //widget.location;
    var toLatLng = LatLng(_currentLocation.latitude,
        _currentLocation.longitude); //_currentLocation;
    latlng.add(fromLatLng);
    latlng.add(toLatLng);
    return <Polyline>[
      Polyline(
          polylineId: PolylineId(fromLatLng.toString()),
          visible: true,
          points: latlng,
          width: 5,
          color: green),
    ].toSet();
  }

  Future<String> getDistance() async{
    double m = 0;
    String distance = "0";
    try{
      await Geolocator().distanceBetween(_currentLocation.latitude, _currentLocation.longitude, widget.location.lat, widget.location.lng).then((value){
        m = value;
      });
      if(m >= 1000){
        distance = (m/1000).toStringAsFixed(0) + 'km';
      }else{
        distance = m.toStringAsFixed(0) + 'm';
      }
      return distance;
    }catch(e){
      return "0m";
    }
  }

  Set<Polyline> _checkDrawPolyline() {
    if (mapToggle) {
      var from = _currentLocation;
      var to = widget.location;
      PlaceService.getStep(
          from.latitude, from.longitude, to.lat, to.lng)
          .then((vl) {
        TripInfoRes infoRes = vl;

        _tripDistance = infoRes.distance;
        setState(() {
        });
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }
        return <Polyline>[
          Polyline(
            //polylineId: PolylineId(fromLatLng.toString()),
              visible: true,
              points: paths,
              width: 5,
              color: green),
        ].toSet();
      });
    }

  }
}

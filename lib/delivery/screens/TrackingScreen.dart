import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mighty_delivery/main/components/BodyCornerWidget.dart';
import 'package:mighty_delivery/main/models/OrderListModel.dart';
import 'package:mighty_delivery/main/network/RestApis.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class TrackingScreen extends StatefulWidget {
  final List<OrderData> order;
  final LatLng? latLng;

  TrackingScreen({required this.order, required this.latLng});

  @override
  TrackingScreenState createState() => TrackingScreenState();
}

class TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController controller;

  late PolylinePoints polylinePoints;

  List<Marker> markers = [];

  late CameraPosition initialLocation;

  LatLng? sourceLocation;

  double cameraZoom = 14;

  double cameraTilt = 0;
  double cameraBearing = 30;
  late Marker deliveryBoy;
  late LatLng orderLatLong;

  final Set<Polyline> polyline = {};
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];

  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    polylinePoints = PolylinePoints();

    positionStream = Geolocator.getPositionStream().listen((event) async {
      sourceLocation = LatLng(event.latitude, event.longitude);
      await updateLocation(latitude: event.latitude.toString(), longitude: event.longitude.toString()).then((value) {
        MarkerId id = MarkerId("DeliveryBoy");
        markers.remove(id);
        deliveryBoy = Marker(
          markerId: id,
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(title: language.yourLocation, snippet: '${language.lastUpdateAt} ${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );

        markers.add(deliveryBoy);
        widget.order.map((e) {
          markers.add(
            Marker(
              markerId: MarkerId('Destination'),
              position: e.status==ORDER_ACTIVE ? LatLng(e.pickupPoint!.latitude.toDouble(), e.pickupPoint!.longitude.toDouble()) : LatLng(e.deliveryPoint!.latitude.toDouble(), e.deliveryPoint!.longitude.toDouble()),
              infoWindow: InfoWindow(title: e.status==ORDER_ACTIVE ? e.pickupPoint!.address : e.deliveryPoint!.address),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            ),
          );
        }).toList();

        setPolyLines(orderLat: orderLatLong);
        onMapCreated(controller);
      }).catchError((error) {
        log(event);
      });
      setState(() {});
    });

    orderLatLong = LatLng(widget.latLng!.latitude, widget.latLng!.longitude);
  }

  Future<void> setPolyLines({required LatLng orderLat}) async {
    _polylines.clear();
    polylineCoordinates.clear();
    var result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapAPIKey,
      PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
      PointLatLng(orderLat.latitude, orderLat.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
      _polylines.add(Polyline(
        visible: true,
        width: 5,
        polylineId: PolylineId('poly'),
        color: Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates,
      ));
      setState(() {});
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(sourceLocation!.latitude, sourceLocation!.longitude), 14));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.trackingOrder),
      ),
      body: BodyCornerWidget(
        child: sourceLocation != null
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    markers: markers.map((e) => e).toSet(),
                    polylines: _polylines,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation!,
                      zoom: cameraZoom,
                      tilt: cameraTilt,
                      bearing: cameraBearing,
                    ),
                    onMapCreated: onMapCreated,
                  ),
                  Container(
                    height: 200,
                    color: context.scaffoldBackgroundColor,
                    child: ListView.separated(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: widget.order.length,
                        itemBuilder: (_, index) {
                          OrderData data = widget.order[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${language.order}# ${data.id}', style: boldTextStyle()),
                                  AppButton(
                                    padding: EdgeInsets.zero,
                                    color: colorPrimary,
                                    text: language.track,
                                    textStyle: primaryTextStyle(color: Colors.white),
                                    onTap: () async {
                                      orderLatLong = data.status==ORDER_ACTIVE ? LatLng(data.pickupPoint!.latitude.toDouble(), data.pickupPoint!.longitude.toDouble()) : LatLng(data.deliveryPoint!.latitude.toDouble(), data.deliveryPoint!.longitude.toDouble());
                                      await setPolyLines(orderLat: orderLatLong);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on, color: colorPrimary),
                                  Text(data.status==ORDER_ACTIVE ?  data.pickupPoint!.address.validate() : data.deliveryPoint!.address.validate(), style: primaryTextStyle()).expand(),
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (_, index) {
                          return Divider();
                        }),
                  ),
                ],
              )
            : loaderWidget(),
      ),
    );
  }
}

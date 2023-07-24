import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/data/providers/data_provider.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? _lastTap;
  bool isLocationChanged = false;
  bool isLoading = false;
  String? locality;
  String? country;
  String? place;
  LatLng? currentLocator;
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;

    currentLocator = LatLng(double.parse(provider.latitude.toString()),
        double.parse(provider.longitude.toString()));

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: isLocationChanged
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      provider.latitude = _lastTap?.latitude;
                      provider.longitude = _lastTap?.longitude;
                      //     context,
                      //     [_lastTap?.latitude, _lastTap?.longitude],
                      //     locality ?? '');
                      // await viewProfile(context);
                      // setState(() {
                      //   isLoading = false;
                      // });
                      Navigator.pop(context);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (ctx) {
                      //   return const AddressPage();
                      // }));
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Change Location")),
              )
            : null,
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            GoogleMap(
              myLocationEnabled: true, buildingsEnabled: true,
              // tiltGesturesEnabled: true,
              // compassEnabled: true,

              onTap: (LatLng pos) async {
                await getPlaceAddress(pos);
              },

              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },

              initialCameraPosition: CameraPosition(
                target: currentLocator!,
                zoom: 11.0,
              ),
              markers: <Marker>{
                Marker(
                  onDragEnd: (value) async {
                    print(value);
                    await getPlaceAddress(value);
                  },
                  draggable: true,
                  markerId: const MarkerId('test_marker_id'),
                  position: _lastTap ?? currentLocator!,
                  infoWindow: InfoWindow(
                    title: place,
                    // snippet: '*',
                  ),
                ),
              },
              gestureRecognizers: //
                  <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
            Positioned(
                top: 10,
                left: size.width * .05,
                // right: size.width * .05,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorManager.whiteText,
                      borderRadius: BorderRadius.circular(5)),
                  width: size.width * .8,
                  height: 50,
                  child: TextField(
                      controller:
                          GoogleMapControllers.googleMapSearchController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: SizedBox(
                            width: size.width * .2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                    onTap: searchLocation,
                                    child: const Icon(Icons.search)),
                                Container(
                                  height: 35,
                                  width: .1,
                                  color: ColorManager.background,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (isLocationChanged) {
                                        GoogleMapControllers
                                            .googleMapSearchController
                                            .clear();
                                        setState(() {
                                          isLocationChanged = false;
                                        });
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      } else if (GoogleMapControllers
                                          .googleMapSearchController
                                          .text
                                          .isNotEmpty) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        // Navigator.pop(context);
                                        GoogleMapControllers
                                            .googleMapSearchController
                                            .clear();
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Icon(Icons.close))
                              ],
                            ),
                          ))),
                )),
            isLocationChanged
                ? Positioned(
                    // left: size.width * .3,
                    bottom: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorManager.whiteText,
                          borderRadius: BorderRadius.circular(10)),
                      constraints: BoxConstraints(minWidth: size.width * .43),
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 25,
                                child: Text(
                                  ' $place',
                                  style: getSemiBoldtStyle(
                                      color: ColorManager.textColor,
                                      fontSize: 13),
                                )),
                            SizedBox(
                                height: 20,
                                child: Text(
                                  country ?? '',
                                  style: getRegularStyle(
                                      color: ColorManager.grayLight,
                                      fontSize: 10),
                                )),
                            SizedBox(
                              height: 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_lastTap?.latitude.toString().substring(0, 8)}, ',
                                    style: getSemiBoldtStyle(
                                        color: ColorManager.primary,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    _lastTap?.longitude
                                            .toString()
                                            .substring(0, 8) ??
                                        '',
                                    style: getSemiBoldtStyle(
                                        color: ColorManager.primary,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  getPlaceAddress(pos) async {
    setState(() {
      _lastTap = pos;
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      // print(_lastTap);
      // print(placemarks);
      getLocationName(placemarks);

      setState(() {
        country = ' ${placemarks[0].country}';
        place = locality?.split('|')[0];
      });
      if (pos != currentLocator) {
        setState(() {
          isLocationChanged = true;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        isLocationChanged = false;
      });
    }
  }

  searchLocation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    List<Location> locations = await locationFromAddress(
        GoogleMapControllers.googleMapSearchController.text);

    setState(() {
      currentLocator = LatLng(locations[0].latitude, locations[0].longitude);
      _lastTap = LatLng(locations[0].latitude, locations[0].longitude);
    });
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocator!, zoom: 14)));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locations[0].latitude, locations[0].longitude);
      // print(_lastTap);
      // print(placemarks);
      // print(placemarks[0].subLocality!.isEmpty);
      getLocationName(placemarks);

      setState(() {
        country = ' ${placemarks[0].country}';
        place = locality?.split('|')[0];
      });
      if (_lastTap != currentLocator) {
        setState(() {
          isLocationChanged = true;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        isLocationChanged = false;
      });
    }

    setState(() {
      isLocationChanged = true;
    });
  }

  getLocationName(List<Placemark> placemarks) {
    if (placemarks[0].subLocality!.isNotEmpty) {
      setState(() {
        locality = '${placemarks[0].subLocality} | ${placemarks[0].country}';
      });
    } else if (placemarks[0].locality!.isNotEmpty) {
      setState(() {
        locality = '${placemarks[0].locality} | ${placemarks[0].country}';
      });
    } else if (placemarks[0].street!.isNotEmpty) {
      setState(() {
        locality = '${placemarks[0].street} | ${placemarks[0].country}';
      });
    } else if (placemarks[0].subAdministrativeArea!.isNotEmpty) {
      setState(() {
        locality =
            '${placemarks[0].subAdministrativeArea} | ${placemarks[0].country}';
      });
    } else if (placemarks[0].administrativeArea!.isNotEmpty) {
      setState(() {
        locality =
            '${placemarks[0].administrativeArea} | ${placemarks[0].country}';
      });
    } else if (placemarks[0].name!.isNotEmpty) {
      setState(() {
        locality = '${placemarks[0].name} | ${placemarks[0].country}';
      });
    } else {}
  }
}

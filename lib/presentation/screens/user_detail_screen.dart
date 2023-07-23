import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:magadh_tech/data/model/user_list.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';

class UserDetailScreen extends StatefulWidget {
  final Users users;
  const UserDetailScreen({super.key, required this.users});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentLocator = LatLng(
        double.parse(widget.users.location?.latitude.toString() ?? ''),
        double.parse(widget.users.location?.longitude.toString() ?? ''));
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          color: ColorManager.grayDark,
        ),
        backgroundColor: ColorManager.primary,
        title: Text(
          "${widget.users.name}",
          style: getSemiBoldtStyle(color: ColorManager.textColor, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: ClipOval(
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  imageUrl: "https://flutter.magadh.co/${widget.users.image}",
                  errorWidget: (context, url, error) {
                    return Container(
                      color: ColorManager.grayDark,
                    );
                  },
                ),
              ),
            ),
            Text(
              widget.users.name ?? '',
              style:
                  getRegularStyle(color: ColorManager.textColor, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Container(
                width: size.width * .9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: const Color.fromARGB(255, 222, 222, 222))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 300,
                                  width: size.width * .85,
                                  child: GoogleMap(
                                    buildingsEnabled: true,
                                    indoorViewEnabled: true,
                                    liteModeEnabled: true,
                                    zoomControlsEnabled: true,
                                    trafficEnabled: true,
                                    // mapToolbarEnabled: false,
                                    // tiltGesturesEnabled: true,

                                    // compassEnabled: true,

                                    // onTap: (LatLng pos) async {
                                    //   await getPlaceAddress(pos);
                                    // },

                                    // onMapCreated: (controller) {
                                    //   setState(() {
                                    //     mapController = controller;
                                    //   });
                                    // },
                                    initialCameraPosition: CameraPosition(
                                      target: currentLocator,
                                      zoom: 11.0,
                                    ),
                                    markers: <Marker>{
                                      Marker(
                                        markerId:
                                            const MarkerId('test_marker_id'),
                                        position: currentLocator,
                                        // infoWindow: InfoWindow(
                                        //   title: place,
                                        //   // snippet: '*',
                                        // ),
                                      ),
                                    },
                                    // gestureRecognizers: //
                                    //     <Factory<OneSequenceGestureRecognizer>>{
                                    //   Factory<OneSequenceGestureRecognizer>(
                                    //     () => EagerGestureRecognizer(),
                                    //   ),
                                    // },
                                    // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                    //   Factory<OneSequenceGestureRecognizer>(
                                    //     () => EagerGestureRecognizer(),
                                    //   ),
                                    // }
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Contact Number",
                                          style: getRegularStyle(
                                              color: ColorManager.textColor,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          widget.users.phone.toString(),
                                          style: getRegularStyle(
                                              color: ColorManager.textColor,
                                              fontSize: 10),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: getRegularStyle(
                                              color: ColorManager.textColor,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          widget.users.email ?? '',
                                          style: getRegularStyle(
                                              color: ColorManager.textColor,
                                              fontSize: 10),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Text(
                                //   data.dateOfBirth!.substring(0, 10),
                                //   style: getRegularStyle(
                                //       color: ColorManager.textColor2,
                                //       fontSize: 12),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // Text(
                                //   "Address",
                                //   style: getRegularStyle(
                                //       color: ColorManager.textColor,
                                //       fontSize: 16),
                                // ),
                                // Text(
                                //   data.presentAddress ?? '',
                                //   style: getRegularStyle(
                                //       color: ColorManager.textColor,
                                //       fontSize: 12),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

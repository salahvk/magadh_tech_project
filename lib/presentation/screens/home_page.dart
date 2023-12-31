// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:magadh_tech/config/route_manager.dart';
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/data/services/noti_services.dart';
import 'package:magadh_tech/presentation/screens/user_detail_screen.dart';
import 'package:magadh_tech/data/providers/data_provider.dart';
import 'package:magadh_tech/data/repositories/login_request.dart';
import 'package:magadh_tech/presentation/widgets/custom_drawer.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 1;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {
      _currentPage++;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    HomeController.pageController.text = _currentPage.toString();
    await LoginImp(context: context).getUsers();
    // FetchEmployeesData.getData(context, page: _currentPage);
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showNotification(
          title: message.notification?.title, body: message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: true);
    final userData = provider.usersListModel?.users;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(
          "Users",
          style:
              getSemiBoldtStyle(color: ColorManager.background, fontSize: 16),
        ),
        actions: [
          Builder(
            builder: (context) => InkWell(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://flutter.magadh.co/${provider.loginVerifyModel?.user?.image}",
                    errorWidget: (context, url, error) {
                      return Container(
                        color: ColorManager.grayDark,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      endDrawer: SizedBox(
        width: size.width * .5,
        height: size.height * 0.5,
        child: const CustomDrawer(),
      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: const WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: userData?.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ClipOval(
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl:
                      "https://flutter.magadh.co/${userData?[index].image}",
                  errorWidget: (context, url, error) {
                    return Container(
                      color: ColorManager.grayDark,
                    );
                  },
                ),
              ),
              title: Row(
                children: [
                  Text(userData?[index].name ?? ''),
                ],
              ),
              subtitle: Text(userData?[index].phone.toString() ?? ''),
              onTap: () {
                Navigator.push(
                    context,
                    FadePageRoute(
                        page: UserDetailScreen(users: userData![index])));
              },
            );
          },
        ),
      ),
    );
  }
}

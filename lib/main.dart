import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:test/consts.dart';
import 'package:test/firebase/firebase_options.dart';
import 'package:test/firebase/notification_service.dart';
import 'graphql/graphql_config.dart';
import 'pages/home_page.dart';

void main() async {
  //! تغییر رنگ نوار وضعیت بالای موبایل
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  //
  //! قفل کردن چرخش موبایل -موقت
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //
  //! اینیشیالیز کردن فایربیس و سرویس نوتیفیکیشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService2().initialize();
  //
  final client = GraphQLConfig.client();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: CacheProvider(
        child: Sizer(
          builder: (context, orientation, deviceType) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.cupertino,
            theme: ThemeData(
                primaryColor: kBlueColor,
                useMaterial3: true,
                scaffoldBackgroundColor: Colors.white),
            home: const HomePage1(),
          ),
        ),
      ),
    );
  }
}

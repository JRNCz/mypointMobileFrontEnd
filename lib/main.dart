import 'package:flutter/material.dart';
import 'package:mypointfrontend/appData/provider/rendermap.dart';
import 'package:mypointfrontend/appData/provider/showpassword.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackGeneral.dart';
import 'package:mypointfrontend/screens/AppInfo/about.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackCarPark.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackValidateCarPark.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackCarParkThanks.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackAddComment.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackSpecify.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackCategory.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackSubCategory.dart';
import 'package:mypointfrontend/screens/Shop/itemOrder.dart';
import 'package:mypointfrontend/screens/Home/loading.dart';
import 'package:mypointfrontend/screens/Home/home.dart';
import 'package:mypointfrontend/screens/AccountManagement/newAccount.dart';
import 'package:mypointfrontend/screens/AccountManagement/register.dart';
import 'package:mypointfrontend/screens/AccountManagement/account.dart';
import 'package:mypointfrontend/screens/Home/scan.dart';
import 'package:mypointfrontend/screens/Home/settings.dart';
import 'package:mypointfrontend/screens/Shop/shop.dart';
import 'package:mypointfrontend/screens/Feedback/feedbackThanks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PasswordInterface()),
    ChangeNotifierProvider(create: (_) => User()),
    ChangeNotifierProvider(create: (_) => RenderMap())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/loading', routes: {
      '/loading': (context) => const LoadingScreen(),
      '/home': (context) => const MapSample(),
      '/register': (context) => const Register(),
      '/account': (context) => const Account(),
      '/createaccount': (context) => const NewAccount(),
      '/feedback': (context) => const FeedbackScreen(),
      '/feedback/catagory': (context) => const FeedbackCatScreen(),
      '/feedback/catagory/subcatagory': (context) => const FeedSubCatScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/about': (context) => const AboutScreen(),
      '/shop': (context) => const ShopScreen(),
      '/scan': (context) => const ScanScreen(),
      '/comment': (context) => const CommentScreen(),
      '/item/order': (context) => const ItemOrder(),
      '/feedback/catagory/subcatagory/thankyou': (context) =>
          const FeedbackThankyou(),
      '/feedback/carpark': (context) => const CarParkScreen(),
      '/feedback/carpark/add': (context) => const AddCarParkScreen(),
      '/feedback/carpark/add/thankyou': (context) =>
          const CarParkFeedbackThankyou(),
      '/feedback/placeholder': (context) => const FeedbackMainScreen(),
    });
  }
}

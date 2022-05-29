import 'package:medicross_patient/Provider/appointment_controller.dart';
import 'package:medicross_patient/Provider/check_connectivity.dart';
import 'package:medicross_patient/Service/database_service.dart';
import 'package:medicross_patient/Provider/datetime_controller.dart';
import 'package:medicross_patient/Provider/notifications_controller.dart';
import 'package:medicross_patient/Provider/rating_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'homepage_controller.dart';
import 'login_ controller.dart';
import 'register_controller.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<RegisterController>(
    create: (context) => RegisterController(),
  ),
  ChangeNotifierProvider<HomePageController>(
    create: (context) => HomePageController(),
  ),
  ChangeNotifierProvider<LoginController>(
    create: (context) => LoginController(),
  ),
  ChangeNotifierProvider<DatabaseService>(
    create: (context) => DatabaseService(),
  ),
  ChangeNotifierProvider<NotificationController>(
    create: (context) => NotificationController(),
  ),
  ChangeNotifierProvider<DateTimeController>(
    create: (context) => DateTimeController(),
  ),
  ChangeNotifierProvider<AppointmentController>(
    create: (context) => AppointmentController(),
  ),
   ChangeNotifierProvider<CheckConnectivity>(
    create: (context) => CheckConnectivity(),
  ),
  ChangeNotifierProvider<RatingController>(
    create: (context) => RatingController(),
  ),
];

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
 static Future initialize(FlutterLocalNotificationsPlugin
 flutterLocalNotificationsPlugin)async{
  var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
  var IOSInitialize = new DarwinInitializationSettings();
  var initializeSettings = new InitializationSettings(android:
  androidInitialize, iOS: IOSInitialize);
  await flutterLocalNotificationsPlugin.initialize(initializeSettings);
 }

 static Future showNotification({var id = 0, required String title, required
 String body, var payload, required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
 })async{
   AndroidNotificationDetails androidNotificationDetails = new
   AndroidNotificationDetails('2', 'Test Notification', playSound: true,
       importance: Importance.max, priority: Priority.high);

   var notify = NotificationDetails(android:
   androidNotificationDetails, iOS:
   DarwinNotificationDetails());
   await flutterLocalNotificationsPlugin.show(id, title, body, notify);
   
 }

}
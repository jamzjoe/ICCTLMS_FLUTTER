import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{

  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails()async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max
        )
    );
  }

  static showNotification(


      {required String title, required String body, required String payload}) {

  }
  static Future showNotifications({
  int id = 0,
    String? title,
    String? body,
    String? payload
}) async =>
      _notifications.show(id,
        title,
        body,
        await _notificationDetails(),
      payload: payload,);
      



}
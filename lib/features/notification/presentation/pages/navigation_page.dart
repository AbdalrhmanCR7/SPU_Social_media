import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return buildNotificationItem(context, index);
        },
      ),
    );
  }

  // دالة لبناء عنصر الإشعار
  Widget buildNotificationItem(BuildContext context, int index) {
    // مثال: نستخدم الـ index لتحديد نوع الإشعار وصورة الشخص بشكل عشوائي
    String notificationType;
    IconData notificationIcon;
    if (index % 3 == 0) {
      notificationType = 'loved your post';
      notificationIcon = Icons.favorite;
    } else if (index % 3 == 1) {
      notificationType = 'commented on your post';
      notificationIcon = Icons.comment;
    } else {
      notificationType = 'followed you';
      notificationIcon = Icons.person_add;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(
          'https://example.com/user_$index.jpg', // صورة المستخدم (مثال)
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'User Name ', // اسم الشخص الذي قام بالإشعار
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: notificationType, // نوع الإشعار (Love/Comment/Follow)
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5.0),
          Icon(notificationIcon, color: Colors.grey), // أيقونة الإشعار
        ],
      ),
      subtitle: Text(
        '2 hours ago', // زمن الإشعار (مثال)
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        // عند النقر على الإشعار
        print('Notification tapped');
      },
    );
  }
}
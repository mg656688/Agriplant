import 'package:flutter/material.dart';
import 'package:sh_toast/show_toast.dart';

void toastbottomSheet(String title, {Color? color}) {
  ShToast.showNotification(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    toastOptions: NotificationOptions(
      notificationType: NotificationType.sheet,
      toastColor: color ?? Colors.black, // Provide a default color if color is null
    ),
  );
}

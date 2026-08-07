# Notifications (Client-only implementation)

This project uses a client-first approach to order notifications so it can run on the Firebase free tier without requiring Blaze/billing. Key points:

- The app saves the device FCM token to `users/{uid}.fcmToken` when a user signs in (handled by `NotificationService`).
- The app listens to `orders` documents for the signed-in user and shows local notifications when an order's `status` field changes. This requires no server-side functions and works on free projects.

How it works

1. User signs in.
2. `NotificationService.initialize()` subscribes to auth changes, saves the FCM token to Firestore, and starts listening to `orders` where `userId == uid`.
3. When an order document's `status` field changes, the app shows a local notification using `flutter_local_notifications`.

Testing with Firebase Console

- You can send a notification directly to a device token for manual testing:

  1. Get the device token from Firestore: `users/<uid>.fcmToken`.
  2. Go to Firebase Console → Cloud Messaging → Send your first message.
  3. Choose "Target" → "Single device" and paste the token.

Simulating status changes

- To test the client listener, update an order doc in Firestore (via Console or code) and change its `status` field. The running app will receive the change and display a local notification.

Notes

- Local notifications require device/emulator support. On iOS and Android emulators, ensure notifications are enabled. On web the local notification plugin is not used; foreground FCM messages are handled by `onMessage`.
- If you later enable billing and want server-triggered notifications, we can add a Cloud Function that reads `users/{uid}.fcmToken` and uses the Admin SDK to send messages. That will require Blaze and enabling Artifact Registry / Cloud Build.


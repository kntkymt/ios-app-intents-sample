import AppIntents

/// A second app intent that also conforms to the `system` domain `open` schema,
/// to test whether multiple `.system.open` declarations are allowed.
///
/// Unlike ``OpenAppIntent`` (which opens a top-level screen), this opens the app
/// directly to a specific ``NotificationEntity``'s detail screen.
//@AppIntent(schema: .system.open)
//struct OpenNotificationIntent: OpenIntent {
//    @Parameter(title: "Notification")
//    var target: NotificationEntity
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        let navigation = AppNavigation.shared
//        navigation.selectedScreen = .notification
//
//        // Push the matching notification's detail screen.
//        if let notification = await NotificationRepository()
//            .getNotifications()
//            .first(where: { $0.id == target.id }) {
//            navigation.notificationPath = [notification]
//        }
//
//        return .result()
//    }
//}

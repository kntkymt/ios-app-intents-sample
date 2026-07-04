import SwiftUI

/// The app's root view. Splits the to-do list and the notifications list into
/// separate tabs, and binds the selected tab to ``AppNavigation`` so
/// ``OpenAppIntent`` can switch tabs via the `.system.open` schema.
struct RootView: View {
    @State private var navigation = AppNavigation.shared

    var body: some View {
        TabView(selection: $navigation.selectedScreen) {
            Tab(AppScreen.todo.title, systemImage: "checklist", value: AppScreen.todo) {
                TodoScreen()
            }
            Tab(AppScreen.notification.title, systemImage: "bell", value: AppScreen.notification) {
                NotificationScreen()
            }
        }
        .sheet(item: $navigation.presentedCaptureMode) { captureMode in
            CameraScreen(captureMode: captureMode)
        }
    }
}

#Preview {
    RootView()
}

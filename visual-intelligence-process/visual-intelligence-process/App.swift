import SwiftUI
import SampleAppIntents
import AppIntents
import Intents

//@main
//struct App: SwiftUI.App {
//
//    init() {
//        let logger = Logger()
//        logger.trace()
//        AppDependencyManager.shared.add(dependency: logger)
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


@main
final class Application: NSObject, UIApplicationDelegate {

    private lazy var rootViewController = UIHostingController(rootView: ContentView())

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Logger().trace(message: "option: \(options)")
        return true
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Logger().trace(message: "option: \(String(describing: launchOptions))")

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupSceneRouter()
        setupLogger()

        Logger().trace(message: "option: \(String(describing: launchOptions))")

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger().trace()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Logger().trace()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger().trace()
    }
}

private extension Application {
    func setupLogger() {
        let logger = Logger()
        AppDependencyManager.shared.add(dependency: logger)
    }

    func setupSceneRouter() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}

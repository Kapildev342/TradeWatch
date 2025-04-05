import UIKit
import Flutter
import Firebase
import FirebaseAuth
import UserNotifications
import flutter_downloader
import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
       signOutOldUser()
      GeneratedPluginRegistrant.register(with: self)
      FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          application.registerForRemoteNotifications()
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url) {
                            let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
                            self.handleDynamicLink(dynamicLink)
                            return true
                        }
        return true
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink?) {
              guard let dynamicLink = dynamicLink else { return }
            guard dynamicLink.url != nil else { return }
          }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        //self.parseURL(userActivity.webpageURL?.absoluteString) // original link as parameter for parsing function

        return true
    }
    
    @available (iOS 14.0,*)
    func requestTrackingAuthorization(completionHandler completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void){
        let trackingStatus = ATTrackingManager.AuthorizationStatus.authorized
        completion(trackingStatus)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let firebaseAuth = Auth.auth()
            firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)

        }
        override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            let firebaseAuth = Auth.auth()
            if (firebaseAuth.canHandleNotification(userInfo)){
                print(userInfo)
                return
            }
        }
    
    
    
}


private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

extension AppDelegate{

func signOutOldUser(){
    if let _ = UserDefaults.standard.value(forKey: "isNewuser"){}
    else{
        do{
            UserDefaults.standard.set(true, forKey: "isNewuser")
            try Auth.auth().signOut()
        }
catch{}
    }
}
}



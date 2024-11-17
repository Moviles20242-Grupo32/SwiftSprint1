//
//  App13App.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI
import Firebase

@main
struct App13App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        FirebaseApp.configure()
    }
    
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var promotionTimer: DispatchSourceTimer?
    
    var orderTimer: DispatchSourceTimer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
        }

        startPromotionNotifications()
        startNoOrderNotifications()
        return true
    }
    
    
    func startPromotionNotifications() {
        let queue = DispatchQueue.global(qos: .background)
        promotionTimer = DispatchSource.makeTimerSource(queue: queue)
        promotionTimer?.schedule(deadline: .now(), repeating: 120) // 120 seconds (2 minutes)
        
        promotionTimer?.setEventHandler { [weak self] in
            self?.sendPromotionNotification()
        }
        
        promotionTimer?.resume()
    }

    func sendPromotionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alerta promoción!"
        content.body = "Revisa los descuentos en caja Creps!"
        content.sound = .default

        // Immediate notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding promotion notification: \(error.localizedDescription)")
            } else {
                print("Promotion notification scheduled successfully")
            }
        }
    }
    
    func startNoOrderNotifications() {
        let queue = DispatchQueue.global(qos: .background)
        orderTimer = DispatchSource.makeTimerSource(queue: queue)
        orderTimer?.schedule(deadline: .now(), repeating: 15)
        
        orderTimer?.setEventHandler { [weak self] in
            self?.sendNoOrderNotification()
        }
        
        orderTimer?.resume()
    }

    func sendNoOrderNotification() {
        
        print("order")
        if !(AuthViewModel.shared.HomeModel.cartItems.isEmpty){
            print("order2")
            let content = UNMutableNotificationContent()
            content.title = "Orden incompleta"
            content.body = "Finaliza tu orden!"
            content.sound = .default

            // Immediate notification trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding promotion notification: \(error.localizedDescription)")
                } else {
                    print("Promotion notification scheduled successfully")
                }
            }
        }

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
            // Sign the user out when app is about to close
        @EnvironmentObject var viewModel: AuthViewModel
//        viewModel.signOut()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Mostrar la notificación incluso cuando la aplicación está en primer plano
        completionHandler([.alert, .sound])
    }
}






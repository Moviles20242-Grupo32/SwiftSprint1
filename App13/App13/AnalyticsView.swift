//
//  AnalyticsView.swift
//  App13
//
//  Created by Daniela Uribe on 9/09/24.
//

import SwiftUI
import FirebaseAnalytics

final class AnalyticsManager{
    
    static let shared = AnalyticsManager()
    private init(){}
        
        func logEvent(name: String, params: [String:Any]?=nil){
            Analytics.logEvent(name, parameters: params)
        }
        
        func setUserId(userId: String){
            Analytics.setUserID(userId)
        }
        
        func setUserProperty(value: String?, property:String){
            Analytics.setUserProperty(value, forName: property)
        }
}

//struct AnalyticsView: View {
//    var body: some View {
//        VStack(spacing: 40){
//            Button("Click me"){
//                AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick", params: [
//                    "screenTitle" : "Hello World"
//                ])
//            }
//        }
//        .analyticsScreen(name: "AnalyticsView")
//        .onAppear{
//            AnalyticsManager.shared.logEvent(name: "AnalyticsViewAppear")
//            AnalyticsManager.shared.setUserId(userId: "ABCD")
//            AnalyticsManager.shared.setUserProperty(value:true.description, property: "user is premium")
//        }
//    }
//}
//    
//
//
//
//#Preview {
//    AnalyticsView()
//}

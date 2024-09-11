//
//  AuthViewModel.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var FormIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        }catch{
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(password: String){
//        guard let user = Auth.auth().currentUser else {
//                    print("DEBUG: No user is currently signed in.")
//                    return
//                }
//
//        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
//
//                user.reauthenticate(with: credential) { result, error in
//                    if let error = error {
//                        print("DEBUG: Failed to re-authenticate with error \(error.localizedDescription)")
//                        return
//                    }
//
//                    user.delete { error in
//                        if let error = error {
//                            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
//                            return
//                        }
//
//                        print("DEBUG: Account deleted successfully.")
//                        // Sign out the user and clear session
//                        do {
//                            try Auth.auth().signOut()
//                            // Perform any additional clean-up, such as navigating away from the view
//                        } catch {
//                            print("DEBUG: Failed to sign out after account deletion with error \(error.localizedDescription)")
//                        }
//                    }
//                }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
}

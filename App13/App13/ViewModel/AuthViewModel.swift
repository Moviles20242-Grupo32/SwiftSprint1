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
    @Published var incorrectUserPassword: Bool = false
    @Published var userExists: Bool = false
    
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
            if error.localizedDescription == "The supplied auth credential is malformed or has expired."{
                incorrectUserPassword = true
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        
        //checks if the user already exists before creating a new one.
        do {
            if let user = try await DatabaseManager.shared.fetchUser(uid: email) {
                userExists = true
            }else { //user does not exists, proceed to create a new one.
                
                do{
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    self.userSession = result.user
                    let user = User(id: result.user.uid, fullname: fullname, email: email)
                    try await DatabaseManager.shared.createUser(user: user)
                    await fetchUser()
                }catch{
                    print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Failed to fetch user during Create User validation: \(error.localizedDescription)")
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
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            // Use DatabaseManager to fetch user
            self.currentUser = try await DatabaseManager.shared.fetchUser(uid: uid)
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
    
}

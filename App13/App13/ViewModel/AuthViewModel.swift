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
    
    // Published properties to update UI when user session or state changes
    @Published var userSession: FirebaseAuth.User? // Tracks current Firebase user session
    @Published var currentUser: User?   // Stores app-specific user data
    @Published var incorrectUserPassword: Bool = false // Flag for incorrect login attempts
    @Published var userExists: Bool = false // Flag to indicate if a user already exists
    
    
    // Initializes user session and fetches user data if logged in
    init(){
        self.userSession = Auth.auth().currentUser
        
        if let user = Auth.auth().currentUser {
            print("DEBUG: Auth currentUser UID: \(user.uid)")
        } else {
            print("DEBUG: No current user logged in.")
        }
        
        Task{
            await fetchUser()
        }
    }

    
    // Signs in the user with email and password, fetches user data if successful
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
    
    // Creates a new user, checking first if they already exist in the database
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        
        // Checks if the user already exists before creating a new one.
        do {
            if (try await DatabaseManager.shared.fetchUser(uid: email)) != nil {
                userExists = true // User exists
            }else { // User does not exists, proceed to create a new one.
                do{ // Creates a new Firebase user and stores user data in the database
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    self.userSession = result.user
                    let user = User(id: result.user.uid, fullname: fullname, email: email)
                    print("Va a crear usuario")
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
    
    // Logs out the current user, clearing session and user data
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // Fetches the current user's data from the database
    func fetchUser() async {
<<<<<<< Updated upstream
        guard let uid = Auth.auth().currentUser?.uid else { return } //if no active user found, return.
=======
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("Se extrae usuario con id" + uid)
>>>>>>> Stashed changes
        do {
            // Use DatabaseManager to fetch user
            self.currentUser = try await DatabaseManager.shared.fetchUser(uid: uid)
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
    
}

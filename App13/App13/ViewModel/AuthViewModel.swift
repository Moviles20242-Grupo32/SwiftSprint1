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
import Network

protocol AuthenticationFormProtocol {
    var FormIsValid: Bool {get}
}

var isConnected: Bool = false
var currentUser: User?

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var incorrectUserPassword: Bool = false
    @Published var userExists: Bool = false
    @Published var HomeModel = HomeViewModel.shared
    @Published var alertMessage: String = ""
    @Published var errorMessageUserExists = ""
    @Published var errorMessageEmail = ""
    @Published var errorMessagePassword = ""
    @Published var errorMessageName = ""
    @Published var showAlert: Bool = false
    private var monitor: NWPathMonitor
    @Published var LocationModel = LocationViewModel.shared
    static let shared = AuthViewModel()
    var timer: Timer?
    
    @Published var fullNameLimit = 50
    @Published var emailLimit = 70
    @Published var passwordLimit = 50
    
    @Published var fullNameInferiorLimit = 4
    @Published var emailInferiorLimit = 10
    @Published var passwordInferiorLimit = 6

    init() {
        
        self.monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "MonitorQueue", qos: .userInteractive)
        monitor.start(queue: queue)
        let delay: TimeInterval = 2
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let newConnectionState = (path.status == .satisfied)
                if newConnectionState != isConnected {
                    isConnected = newConnectionState
                    print("Connection status changed: \(isConnected == true ? "Connected" : "Disconnected")")
                    self?.HomeModel.fetchData()
                }
                
                if isConnected{
                    self?.LocationModel.extractLocation()
                }
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            // Background thread for non-UI work
            DispatchQueue.global(qos: .background).async {
                // Nest userInteractive thread for fetching data and updating the UI
                DispatchQueue.global(qos: .userInteractive).async {
                    self?.HomeModel.fetchData()
                    print("Fetching data in background")
                }
            }
        }
        
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
        
        do {
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
        
        guard isConnected else {
            // Show alert if there's no internet connection
            alertMessage = "No hay conexión a internet. No se puede registrar el usuario."
            showAlert = true
            return
        }
        
        //checks if the user already exists before creating a new one.
        do {
            // validate user existance:
            if (try await DatabaseManager.shared.fetchUserByEmail(email: email)) != nil {
                userExists = true
                errorMessageUserExists = "El Usuario que está intentando registrar ya existe."
                return
            } else {
                // User does not exists, proceed to validate input data and create user.
                do{
                    
                    // validate email:
                    let tldRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|edu|org|net|gov|io|co)"
                    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", tldRegex)
                    if !emailPredicate.evaluate(with: email) {
                        errorMessageEmail = "Formato incorrecto"
                        return
                    }
                    if email.count > emailLimit || email.count < emailInferiorLimit {
                        errorMessageEmail = "Máximo 50 y mínimo 10 carácteres"
                        return
                    }
                    
                    // validate name:
                    if fullname.count > fullNameLimit || fullname.count < fullNameInferiorLimit {
                        errorMessageName = "Máximo 50 carácteres y mínimo 4 carácteres"
                        return
                    }
                    
                    // validate password:
                    if password.count > passwordLimit || password.count < passwordInferiorLimit {
                        errorMessagePassword = "Máximo 50 carácteres y mínimo 6 carácteres"
                        return
                    }
                    
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    self.userSession = result.user
                    let user = User(id: result.user.uid, fullname: fullname, email: email)
                    print("Va a crear usuario")
                    try await DatabaseManager.shared.createUser(user: user)
                    await fetchUser()
                    
                    errorMessageUserExists = ""
                    errorMessageEmail = ""
                    errorMessagePassword = ""
                    errorMessageName = ""
                    
                }catch{
                    print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Failed to fetch user during Create User validation: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
       
        do {
            HomeModel.clearCart()
            try Auth.auth().signOut()
            self.userSession = nil
            currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
        
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("Se extrae usuario con id" + uid)

        do {
            // Use DatabaseManager to fetch user
            currentUser = try await DatabaseManager.shared.fetchUser(uid: uid)
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
    
}

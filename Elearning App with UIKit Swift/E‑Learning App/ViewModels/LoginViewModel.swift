//
//  LoginViewModel.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var currentUser: User?
    
    // Callbacks for UI updates
    var onLoading: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogout: (() -> Void)?
    
    private let firebaseService = FirebaseService.shared
    private let userDefaults = UserDefaults.standard
    
    init() {
        setupSavedEmail()
    }
    
    private func setupSavedEmail() {
        if let savedEmail = userDefaults.string(forKey: "userEmail") {
            email = savedEmail
        }
    }
    
    func login(email: String, password: String) {
        self.email = email
        self.password = password
        
        guard !email.isEmpty, !password.isEmpty else {
            onError?("Please enter both email and password")
            return
        }
        
        guard isValidEmail(email) else {
            onError?("Please enter a valid email address")
            return
        }
        
        onLoading?(true)
        
        firebaseService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let firebaseUser):
                    // Convert Firebase user to app user
                    self?.firebaseService.convertToAppUser(firebaseUser: firebaseUser) { appUserResult in
                        DispatchQueue.main.async {
                            switch appUserResult {
                            case .success(let appUser):
                                self?.currentUser = appUser
                                self?.userDefaults.set(email, forKey: "userEmail")
                                self?.userDefaults.set(true, forKey: "isLoggedIn")
                                self?.onLoginSuccess?()
                            case .failure(let error):
                                self?.onError?(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func logout() {
        do {
            try firebaseService.signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.userDefaults.set(false, forKey: "isLoggedIn")
                self.userDefaults.removeObject(forKey: "userEmail")
                self.onLogout?()
            }
        } catch {
            DispatchQueue.main.async {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func forgotPassword(email: String) {
        firebaseService.resetPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onError?("Password reset link sent to your email")
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


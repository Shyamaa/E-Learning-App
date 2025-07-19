//
//  LoginViewModel.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var currentUser: User?
    
    // Callbacks for UI updates
    var onLoading: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogout: (() -> Void)?
    
    private let authService: AuthService
    private let userDefaults = UserDefaults.standard
    
    init(authService: AuthService = MockAuthService()) {
        self.authService = authService
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
        
        let user = User(
            email: email,
            password: password,
            firstName: "John",
            lastName: "Doe",
            profileImageURL: nil,
            joinDate: Date(),
            lastLoginDate: Date(),
            preferences: User.UserPreferences(
                notificationsEnabled: true,
                darkModeEnabled: false,
                autoPlayVideos: true,
                downloadOverWifiOnly: true,
                language: "en"
            ),
            progress: User.UserProgress(
                completedCourses: 2,
                totalCourses: 5,
                totalStudyTime: 180,
                currentStreak: 7,
                achievements: [
                    User.Achievement(
                        title: "First Course",
                        description: "Completed your first course",
                        icon: "star.fill",
                        dateEarned: Date().addingTimeInterval(-86400 * 7),
                        type: .firstCourse
                    ),
                    User.Achievement(
                        title: "Week Streak",
                        description: "Studied for 7 days in a row",
                        icon: "flame.fill",
                        dateEarned: Date(),
                        type: .weekStreak
                    )
                ]
            )
        )
        
        authService.login(user: user) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.userDefaults.set(email, forKey: "userEmail")
                    self?.userDefaults.set(true, forKey: "isLoggedIn")
                    self?.onLoginSuccess?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func logout() {
        authService.logout { [weak self] _ in
            DispatchQueue.main.async {
                self?.currentUser = nil
                self?.userDefaults.set(false, forKey: "isLoggedIn")
                self?.onLogout?()
            }
        }
    }
    
    func forgotPassword(email: String) {
        authService.forgotPassword(email: email) { [weak self] result in
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


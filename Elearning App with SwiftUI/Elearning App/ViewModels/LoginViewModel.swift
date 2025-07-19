//
//  LoginViewModel.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var currentUser: User?

    // ✅ Persist state with @AppStorage, used by the App
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("userEmail") var savedEmail: String = ""

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = MockAuthService()) {
        self.authService = authService
        setupBindings()
    }
    
    private func setupBindings() {
        // Auto-fill email if previously saved
        if !savedEmail.isEmpty {
            email = savedEmail
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }

        isLoading = true
        errorMessage = nil
        
        authService.login(user: User(
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
        )) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isLoggedIn = true
                    self?.savedEmail = self?.email ?? ""
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        email = ""
        password = ""
        errorMessage = nil
    }
    
    func forgotPassword() {
        // Implement forgot password functionality
        errorMessage = "Password reset link sent to your email"
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

//
//  LoginViewModel.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

class LoginViewModel {
    private let authService: AuthService

    var onLoading: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    init(authService: AuthService = MockAuthService()) {
        self.authService = authService
    }

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            onError?("Please enter both email and password")
            return
        }

        onLoading?(true)
        let user = User(email: email, password: password)
        authService.login(user: user) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success:
                    self?.onLoginSuccess?()
                case .failure(let err):
                    self?.onError?(err.localizedDescription)
                }
            }
        }
    }
}


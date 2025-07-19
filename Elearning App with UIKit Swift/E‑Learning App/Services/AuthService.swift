//
//  AuthService.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

protocol AuthService {
    func login(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class MockAuthService: AuthService {
    func login(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if user.email == "student@example.com" && user.password == "learning123" {
                // Return the user with updated last login date
                let updatedUser = user
                // In a real app, you'd update the lastLoginDate here
                completion(.success(updatedUser))
            } else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success(()))
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if email == "student@example.com" {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Email not found"])))
            }
        }
    }
}


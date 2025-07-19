//
//  AuthService.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

protocol AuthService {
    func login(user: User, completion: @escaping (Result<Bool, Error>) -> Void)
}

class MockAuthService: AuthService {
    func login(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if user.email == "student@example.com" && user.password == "learning123" {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
            }
        }
    }
}


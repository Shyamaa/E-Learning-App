//
//  FirebaseConfigChecker.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseConfigChecker {
    static let shared = FirebaseConfigChecker()
    
    private init() {}
    
    func checkConfiguration() -> [String: Any] {
        var status: [String: Any] = [:]
        
        // Check if Firebase is configured
        if FirebaseApp.app() != nil {
            status["firebase_configured"] = true
        } else {
            status["firebase_configured"] = false
            status["error"] = "Firebase not configured. Check GoogleService-Info.plist"
        }
        
        // Check current user
        if let currentUser = Auth.auth().currentUser {
            status["user_logged_in"] = true
            status["user_email"] = currentUser.email
            status["user_uid"] = currentUser.uid
        } else {
            status["user_logged_in"] = false
        }
        
        // Check Firestore connection
        let db = Firestore.firestore()
        db.collection("test").document("connection").getDocument { document, error in
            if let error = error {
                status["firestore_connected"] = false
                status["firestore_error"] = error.localizedDescription
            } else {
                status["firestore_connected"] = true
            }
        }
        
        return status
    }
    
    func printConfigurationStatus() {
        let status = checkConfiguration()
        print("🔥 Firebase Configuration Status:")
        print("==================================")
        
        for (key, value) in status {
            print("\(key): \(value)")
        }
        print("==================================")
    }
    
    func testFirebaseConnection(completion: @escaping (Bool, String?) -> Void) {
        // Test Firestore connection
        let db = Firestore.firestore()
        db.collection("test").document("connection").getDocument { document, error in
            if let error = error {
                completion(false, "Firestore connection failed: \(error.localizedDescription)")
            } else {
                completion(true, "Firebase connection successful!")
            }
        }
    }
}

// MARK: - Usage Example
/*
 Add this to your SceneDelegate or AppDelegate to test Firebase:
 
 FirebaseConfigChecker.shared.printConfigurationStatus()
 FirebaseConfigChecker.shared.testFirebaseConnection { success, message in
     if success {
         print("✅ \(message ?? "Firebase working!")")
     } else {
         print("❌ \(message ?? "Firebase failed!")")
     }
 }
 */ 
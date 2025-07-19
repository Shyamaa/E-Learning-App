//
//  FirebaseService.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseAnalytics

class FirebaseService {
    static let shared = FirebaseService()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {}
    
    // MARK: - Authentication
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }
            
            // Create user profile in Firestore
            let userData: [String: Any] = [
                "uid": user.uid,
                "email": email,
                "firstName": firstName,
                "lastName": lastName,
                "createdAt": FieldValue.serverTimestamp(),
                "lastLoginAt": FieldValue.serverTimestamp(),
                "preferences": [
                    "notificationsEnabled": true,
                    "darkModeEnabled": false,
                    "autoPlayVideos": true,
                    "downloadOverWifiOnly": true
                ]
            ]
            
            self?.db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign in failed"])))
                return
            }
            
            // Update last login time
            self?.db.collection("users").document(user.uid).updateData([
                "lastLoginAt": FieldValue.serverTimestamp()
            ])
            
            completion(.success(user))
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getCurrentUser() -> FirebaseAuth.User? {
        return auth.currentUser
    }
    
    // MARK: - User Model Conversion
    func convertToAppUser(firebaseUser: FirebaseAuth.User, completion: @escaping (Result<User, Error>) -> Void) {
        getUserProfile(uid: firebaseUser.uid) { result in
            switch result {
            case .success(let userData):
                do {
                    let appUser = try self.createAppUser(from: userData, firebaseUser: firebaseUser)
                    completion(.success(appUser))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createAppUser(from userData: [String: Any], firebaseUser: FirebaseAuth.User) throws -> User {
        guard let email = userData["email"] as? String,
              let firstName = userData["firstName"] as? String,
              let lastName = userData["lastName"] as? String else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }
        
        let profileImageURL = userData["profileImageURL"] as? String
        let joinDate = (userData["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        let lastLoginDate = (userData["lastLoginAt"] as? Timestamp)?.dateValue() ?? Date()
        
        // Create preferences
        let preferencesData = userData["preferences"] as? [String: Any] ?? [:]
        let preferences = User.UserPreferences(
            notificationsEnabled: preferencesData["notificationsEnabled"] as? Bool ?? true,
            darkModeEnabled: preferencesData["darkModeEnabled"] as? Bool ?? false,
            autoPlayVideos: preferencesData["autoPlayVideos"] as? Bool ?? true,
            downloadOverWifiOnly: preferencesData["downloadOverWifiOnly"] as? Bool ?? true,
            language: preferencesData["language"] as? String ?? "en"
        )
        
        // Create progress (you can enhance this with real progress data)
        let progress = User.UserProgress(
            completedCourses: 0,
            totalCourses: 0,
            totalStudyTime: 0,
            currentStreak: 0,
            achievements: []
        )
        
        return User(
            email: email,
            password: "", // Don't store password in app model
            firstName: firstName,
            lastName: lastName,
            profileImageURL: profileImageURL,
            joinDate: joinDate,
            lastLoginDate: lastLoginDate,
            preferences: preferences,
            progress: progress
        )
    }
    
    // MARK: - User Profile
    func getUserProfile(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                return
            }
            
            completion(.success(data))
        }
    }
    
    func updateUserProfile(uid: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(uid).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Courses
    func getCourses(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection("courses").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let courses = documents.compactMap { document -> [String: Any]? in
                var data = document.data()
                data["id"] = document.documentID
                return data
            }
            
            completion(.success(courses))
        }
    }
    
    func getCourse(courseId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("courses").document(courseId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  var data = document.data() else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Course not found"])))
                return
            }
            
            data["id"] = document.documentID
            completion(.success(data))
        }
    }
    
    func getLessons(courseId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection("courses").document(courseId).collection("lessons").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let lessons = documents.compactMap { document -> [String: Any]? in
                var data = document.data()
                data["id"] = document.documentID
                return data
            }
            
            completion(.success(lessons))
        }
    }
    
    // MARK: - User Progress
    func getUserProgress(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(uid).collection("progress").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([:]))
                return
            }
            
            var progress: [String: Any] = [:]
            for document in documents {
                progress[document.documentID] = document.data()
            }
            
            completion(.success(progress))
        }
    }
    
    func updateLessonProgress(uid: String, courseId: String, lessonId: String, progress: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        let progressData: [String: Any] = [
            "progress": progress,
            "completedAt": progress >= 1.0 ? FieldValue.serverTimestamp() : nil,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).collection("progress").document("\(courseId)_\(lessonId)").setData(progressData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Search
    func searchCourses(query: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection("courses")
            .whereField("title", isGreaterThanOrEqualTo: query)
            .whereField("title", isLessThan: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let courses = documents.compactMap { document -> [String: Any]? in
                    var data = document.data()
                    data["id"] = document.documentID
                    return data
                }
                
                completion(.success(courses))
            }
    }
    
    // MARK: - Storage (Temporarily Disabled - Region Issue)
    func uploadProfileImage(uid: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        // Temporary workaround - return a placeholder URL
        // TODO: Fix Firebase Storage region issue
        let placeholderURL = "https://via.placeholder.com/150x150/007AFF/FFFFFF?text=Profile"
        completion(.success(placeholderURL))
        
        // Original code (commented out until Storage is fixed):
        /*
        let imageRef = storage.reference().child("profile_images/\(uid).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
        */
    }
    
    // MARK: - Analytics
    func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    func setUserProperty(value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
} 
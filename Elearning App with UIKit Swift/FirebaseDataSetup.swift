//
//  FirebaseDataSetup.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//
//  This file contains sample data setup for Firebase
//  Run this once to populate your Firestore database with sample courses

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseDataSetup {
    static let shared = FirebaseDataSetup()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func setupSampleData(completion: @escaping (Bool) -> Void) {
        let courses = [
            [
                "title": "iOS Development Fundamentals",
                "description": "Learn the basics of iOS development with Swift and UIKit",
                "instructor": "John Smith",
                "duration": "8 weeks",
                "level": "Beginner",
                "rating": 4.8,
                "studentsEnrolled": 1250,
                "price": 99.99,
                "imageUrl": "https://example.com/ios-fundamentals.jpg",
                "category": "Programming",
                "tags": ["iOS", "Swift", "UIKit", "Beginner"],
                "createdAt": FieldValue.serverTimestamp()
            ],
            [
                "title": "Advanced Swift Programming",
                "description": "Master advanced Swift concepts and best practices",
                "instructor": "Sarah Johnson",
                "duration": "6 weeks",
                "level": "Advanced",
                "rating": 4.9,
                "studentsEnrolled": 850,
                "price": 149.99,
                "imageUrl": "https://example.com/advanced-swift.jpg",
                "category": "Programming",
                "tags": ["Swift", "Advanced", "Programming", "Best Practices"],
                "createdAt": FieldValue.serverTimestamp()
            ],
            [
                "title": "UI/UX Design Principles",
                "description": "Learn modern UI/UX design principles for mobile apps",
                "instructor": "Mike Chen",
                "duration": "10 weeks",
                "level": "Intermediate",
                "rating": 4.7,
                "studentsEnrolled": 2100,
                "price": 129.99,
                "imageUrl": "https://example.com/uiux-design.jpg",
                "category": "Design",
                "tags": ["UI/UX", "Design", "Mobile", "User Experience"],
                "createdAt": FieldValue.serverTimestamp()
            ],
            [
                "title": "Firebase Backend Development",
                "description": "Build scalable backend solutions with Firebase",
                "instructor": "Emily Davis",
                "duration": "7 weeks",
                "level": "Intermediate",
                "rating": 4.6,
                "studentsEnrolled": 950,
                "price": 119.99,
                "imageUrl": "https://example.com/firebase-backend.jpg",
                "category": "Backend",
                "tags": ["Firebase", "Backend", "Database", "Cloud"],
                "createdAt": FieldValue.serverTimestamp()
            ],
            [
                "title": "Machine Learning for iOS",
                "description": "Integrate machine learning into your iOS apps",
                "instructor": "David Wilson",
                "duration": "12 weeks",
                "level": "Advanced",
                "rating": 4.9,
                "studentsEnrolled": 650,
                "price": 199.99,
                "imageUrl": "https://example.com/ml-ios.jpg",
                "category": "AI/ML",
                "tags": ["Machine Learning", "iOS", "Core ML", "AI"],
                "createdAt": FieldValue.serverTimestamp()
            ]
        ]
        
        let lessons = [
            // iOS Development Fundamentals Lessons
            [
                "title": "Introduction to iOS Development",
                "description": "Overview of iOS development ecosystem and tools",
                "duration": 45,
                "videoUrl": "https://example.com/lesson1.mp4",
                "thumbnailUrl": "https://example.com/lesson1-thumb.jpg",
                "order": 1
            ],
            [
                "title": "Swift Basics",
                "description": "Learn fundamental Swift programming concepts",
                "duration": 60,
                "videoUrl": "https://example.com/lesson2.mp4",
                "thumbnailUrl": "https://example.com/lesson2-thumb.jpg",
                "order": 2
            ],
            [
                "title": "UIKit Fundamentals",
                "description": "Understanding UIKit framework and basic UI components",
                "duration": 75,
                "videoUrl": "https://example.com/lesson3.mp4",
                "thumbnailUrl": "https://example.com/lesson3-thumb.jpg",
                "order": 3
            ],
            [
                "title": "Auto Layout and Constraints",
                "description": "Master Auto Layout for responsive UI design",
                "duration": 90,
                "videoUrl": "https://example.com/lesson4.mp4",
                "thumbnailUrl": "https://example.com/lesson4-thumb.jpg",
                "order": 4
            ],
            [
                "title": "Navigation and Table Views",
                "description": "Implement navigation and display data in table views",
                "duration": 80,
                "videoUrl": "https://example.com/lesson5.mp4",
                "thumbnailUrl": "https://example.com/lesson5-thumb.jpg",
                "order": 5
            ]
        ]
        
        var completedCourses = 0
        let totalCourses = courses.count
        
        for (index, courseData) in courses.enumerated() {
            // Add course
            db.collection("courses").addDocument(data: courseData) { [weak self] error, documentRef in
                if let error = error {
                    print("Error adding course: \(error)")
                    completedCourses += 1
                    if completedCourses == totalCourses {
                        completion(false)
                    }
                    return
                }
                
                guard let documentRef = documentRef else {
                    completedCourses += 1
                    if completedCourses == totalCourses {
                        completion(false)
                    }
                    return
                }
                
                // Add lessons for this course
                for lessonData in lessons {
                    self?.db.collection("courses").document(documentRef.documentID).collection("lessons").addDocument(data: lessonData) { error, _ in
                        if let error = error {
                            print("Error adding lesson: \(error)")
                        }
                    }
                }
                
                completedCourses += 1
                if completedCourses == totalCourses {
                    completion(true)
                }
            }
        }
    }
    
    func setupUserPreferences(uid: String, completion: @escaping (Bool) -> Void) {
        let preferences = [
            "notificationsEnabled": true,
            "darkModeEnabled": false,
            "autoPlayVideos": true,
            "downloadOverWifiOnly": true,
            "language": "en",
            "timezone": "UTC"
        ]
        
        db.collection("users").document(uid).updateData([
            "preferences": preferences
        ]) { error in
            if let error = error {
                print("Error setting user preferences: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func setupSampleUserProgress(uid: String, completion: @escaping (Bool) -> Void) {
        let progressData = [
            "course_1_lesson_1": [
                "progress": 1.0,
                "completedAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
            ],
            "course_1_lesson_2": [
                "progress": 0.75,
                "updatedAt": FieldValue.serverTimestamp()
            ],
            "course_2_lesson_1": [
                "progress": 0.5,
                "updatedAt": FieldValue.serverTimestamp()
            ]
        ]
        
        var completedProgress = 0
        let totalProgress = progressData.count
        
        for (key, data) in progressData {
            db.collection("users").document(uid).collection("progress").document(key).setData(data) { error in
                if let error = error {
                    print("Error setting progress: \(error)")
                }
                
                completedProgress += 1
                if completedProgress == totalProgress {
                    completion(true)
                }
            }
        }
    }
}

// MARK: - Usage Example
/*
 To use this setup script, call it once after Firebase is configured:
 
 FirebaseDataSetup.shared.setupSampleData { success in
     if success {
         print("Sample data setup completed successfully!")
     } else {
         print("Failed to setup sample data")
     }
 }
 */ 
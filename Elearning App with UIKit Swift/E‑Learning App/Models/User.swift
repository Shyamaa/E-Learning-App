//
//  User.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

struct User: Codable {
    let id: UUID = UUID()
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let profileImageURL: String?
    let joinDate: Date
    let lastLoginDate: Date
    let preferences: UserPreferences
    let progress: UserProgress
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    struct UserPreferences: Codable {
        let notificationsEnabled: Bool
        let darkModeEnabled: Bool
        let autoPlayVideos: Bool
        let downloadOverWifiOnly: Bool
        let language: String
    }
    
    struct UserProgress: Codable {
        let completedCourses: Int
        let totalCourses: Int
        let totalStudyTime: Int // in minutes
        let currentStreak: Int // days
        let achievements: [Achievement]
        
        var completionRate: Double {
            guard totalCourses > 0 else { return 0 }
            return Double(completedCourses) / Double(totalCourses) * 100
        }
    }
    
    struct Achievement: Codable, Identifiable {
        let id: UUID = UUID()
        let title: String
        let description: String
        let icon: String
        let dateEarned: Date
        let type: AchievementType
        
        enum AchievementType: String, Codable, CaseIterable {
            case firstCourse = "First Course"
            case weekStreak = "Week Streak"
            case perfectScore = "Perfect Score"
            case socialLearner = "Social Learner"
            case nightOwl = "Night Owl"
            
            var color: String {
                switch self {
                case .firstCourse: return "blue"
                case .weekStreak: return "orange"
                case .perfectScore: return "green"
                case .socialLearner: return "purple"
                case .nightOwl: return "indigo"
                }
            }
        }
    }
}


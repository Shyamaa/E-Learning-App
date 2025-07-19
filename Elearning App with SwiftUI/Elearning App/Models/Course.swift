//
//  Course.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

struct Course: Identifiable, Codable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let lessons: [Lesson]
    let category: CourseCategory
    let difficulty: CourseDifficulty
    let estimatedDuration: Int // in minutes
    let instructor: String
    let thumbnailURL: String?
    let isCompleted: Bool = false
    let progress: Double = 0.0
    
    enum CourseCategory: String, CaseIterable, Codable {
        case programming = "Programming"
        case design = "Design"
        case business = "Business"
        case marketing = "Marketing"
        case personalDevelopment = "Personal Development"
        
        var icon: String {
            switch self {
            case .programming: return "laptopcomputer"
            case .design: return "paintbrush"
            case .business: return "briefcase"
            case .marketing: return "megaphone"
            case .personalDevelopment: return "person.fill"
            }
        }
    }
    
    enum CourseDifficulty: String, CaseIterable, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "orange"
            case .advanced: return "red"
            }
        }
    }
}


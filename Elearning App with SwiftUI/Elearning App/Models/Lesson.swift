//
//  Lesson.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

struct Lesson: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let content: String
    let duration: Int // in minutes
    let lessonType: LessonType
    var isCompleted: Bool = false
    let videoURL: String?
    let resources: [LessonResource]
    
    enum LessonType: String, CaseIterable, Codable {
        case video = "Video"
        case reading = "Reading"
        case quiz = "Quiz"
        case assignment = "Assignment"
        
        var icon: String {
            switch self {
            case .video: return "play.circle.fill"
            case .reading: return "book.fill"
            case .quiz: return "questionmark.circle.fill"
            case .assignment: return "pencil.circle.fill"
            }
        }
    }
}

struct LessonResource: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let url: String
    let type: ResourceType
    
    enum ResourceType: String, CaseIterable, Codable {
        case pdf = "PDF"
        case link = "Link"
        case download = "Download"
        
        var icon: String {
            switch self {
            case .pdf: return "doc.fill"
            case .link: return "link"
            case .download: return "arrow.down.circle.fill"
            }
        }
    }
}

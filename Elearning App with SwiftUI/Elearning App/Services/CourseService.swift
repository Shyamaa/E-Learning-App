//
//  CourseService.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

protocol CourseService {
    func fetchCourses(completion: @escaping ([Course]) -> Void)
}

class MockCourseService: CourseService {
    func fetchCourses(completion: @escaping ([Course]) -> Void) {
        let iosLessons = [
            Lesson(
                title: "Introduction to SwiftUI",
                content: "SwiftUI is a modern framework for building user interfaces across all Apple platforms. Learn the fundamentals of declarative UI programming.",
                duration: 20,
                lessonType: .video,
                videoURL: "https://example.com/swiftui-intro",
                resources: [
                    LessonResource(title: "SwiftUI Cheat Sheet", url: "https://example.com/cheatsheet", type: .pdf),
                    LessonResource(title: "Sample Code", url: "https://github.com/example/swiftui-samples", type: .link)
                ]
            ),
            Lesson(
                title: "Building Your First App",
                content: "Create a complete iOS app from scratch using SwiftUI. We'll cover navigation, data binding, and user interactions.",
                duration: 30,
                lessonType: .reading,
                videoURL: nil,
                resources: [
                    LessonResource(title: "Project Files", url: "https://example.com/project-files", type: .download)
                ]
            ),
            Lesson(
                title: "State Management",
                content: "Master SwiftUI's state management system including @State, @Binding, @ObservedObject, and @EnvironmentObject.",
                duration: 25,
                lessonType: .video,
                videoURL: "https://example.com/state-management",
                resources: []
            )
        ]
        
        let designLessons = [
            Lesson(
                title: "UI/UX Fundamentals",
                content: "Learn the core principles of user interface and user experience design. Understand how to create intuitive and beautiful interfaces.",
                duration: 25,
                lessonType: .reading,
                videoURL: nil,
                resources: [
                    LessonResource(title: "Design Guidelines", url: "https://example.com/guidelines", type: .pdf)
                ]
            ),
            Lesson(
                title: "Design Tools & Workflows",
                content: "Explore popular design tools like Figma, Sketch, and Adobe XD. Learn efficient workflows for creating professional designs.",
                duration: 35,
                lessonType: .video,
                videoURL: "https://example.com/design-tools",
                resources: [
                    LessonResource(title: "Figma Templates", url: "https://example.com/templates", type: .download)
                ]
            )
        ]
        
        let courses = [
            Course(
                title: "iOS Development with SwiftUI",
                description: "Master iOS app development using Apple's modern SwiftUI framework. Build beautiful, responsive apps with less code.",
                lessons: iosLessons,
                category: .programming,
                difficulty: .intermediate,
                estimatedDuration: 75,
                instructor: "Sarah Johnson",
                thumbnailURL: "https://example.com/ios-thumbnail"
            ),
            Course(
                title: "UI/UX Design Masterclass",
                description: "Learn to create stunning user interfaces and exceptional user experiences. From wireframes to prototypes.",
                lessons: designLessons,
                category: .design,
                difficulty: .beginner,
                estimatedDuration: 60,
                instructor: "Mike Chen",
                thumbnailURL: "https://example.com/design-thumbnail"
            ),
            Course(
                title: "Digital Marketing Strategy",
                description: "Develop comprehensive digital marketing strategies that drive results. Learn SEO, social media, and content marketing.",
                lessons: [
                    Lesson(
                        title: "Marketing Fundamentals",
                        content: "Understanding the basics of digital marketing and how to create effective campaigns.",
                        duration: 20,
                        lessonType: .reading,
                        videoURL: nil,
                        resources: []
                    )
                ],
                category: .marketing,
                difficulty: .beginner,
                estimatedDuration: 20,
                instructor: "Emily Rodriguez",
                thumbnailURL: "https://example.com/marketing-thumbnail"
            )
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(courses)
        }
    }
}

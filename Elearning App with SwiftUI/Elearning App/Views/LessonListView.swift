//
//  LessonListView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import SwiftUI

struct LessonListView: View {
    let course: Course

    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Course header
                    CourseHeaderView(course: course)
                    
                    // Lessons
                    ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                        NavigationLink(destination: LessonDetailView(viewModel: LessonDetailViewModel(lesson: lesson))) {
                            LessonCardView(lesson: lesson, lessonNumber: index + 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// Course Header View
struct CourseHeaderView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Course info
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(course.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
            
            // Course stats
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(course.lessons.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Lessons")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("~\(course.estimatedDuration)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("Minutes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text(course.difficulty.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(course.difficulty.color))
                    
                    Text("Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Lesson Card View
struct LessonCardView: View {
    let lesson: Lesson
    let lessonNumber: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Lesson number circle
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Text("\(lessonNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            // Lesson content
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("~\(lesson.duration) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Arrow indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        LessonListView(course: Course(
            title: "iOS Development",
            description: "Learn Swift & SwiftUI",
            lessons: [
                Lesson(
                    title: "Introduction",
                    content: "Welcome to the course.",
                    duration: 15,
                    lessonType: .reading,
                    videoURL: nil,
                    resources: []
                ),
                Lesson(
                    title: "Advanced Topic",
                    content: "In-depth content here.",
                    duration: 20,
                    lessonType: .video,
                    videoURL: "https://example.com/video",
                    resources: []
                )
            ],
            category: .programming,
            difficulty: .beginner,
            estimatedDuration: 35,
            instructor: "John Doe",
            thumbnailURL: nil
        ))
    }
}

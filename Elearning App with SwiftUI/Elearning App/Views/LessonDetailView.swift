//
//  LessonDetailView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import SwiftUI

struct LessonDetailView: View {
    @ObservedObject var viewModel: LessonDetailViewModel
    @State private var isCompleted = false

    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Lesson header
                    LessonHeaderView(lesson: viewModel.lesson)
                    
                    // Lesson content
                    LessonContentView(lesson: viewModel.lesson)
                    
                    // Action buttons
                    LessonActionButtons(isCompleted: $isCompleted)
                }
                .padding()
            }
        }
        .navigationTitle("Lesson")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Lesson Header View
struct LessonHeaderView: View {
    let lesson: Lesson
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Lesson title
            Text(lesson.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Lesson metadata
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    
                    Text("~\(lesson.duration) minutes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: lesson.lessonType.icon)
                        .foregroundColor(.blue)
                        .font(.caption)
                    
                    Text(lesson.lessonType.rawValue)
                        .font(.subheadline)
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

// Lesson Content View
struct LessonContentView: View {
    let lesson: Lesson
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Content")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(lesson.content)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(6)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// Lesson Action Buttons
struct LessonActionButtons: View {
    @Binding var isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Mark as completed button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isCompleted.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isCompleted ? .green : .blue)
                    
                    Text(isCompleted ? "Completed" : "Mark as Completed")
                        .fontWeight(.semibold)
                        .foregroundColor(isCompleted ? .green : .blue)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCompleted ? Color.green : Color.blue, lineWidth: 2)
                )
            }
            
            // Next lesson button
            Button(action: {
                // Navigate to next lesson
            }) {
                HStack(spacing: 8) {
                    Text("Next Lesson")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(!isCompleted)
            .opacity(isCompleted ? 1.0 : 0.5)
        }
    }
}

#Preview {
    NavigationView {
        LessonDetailView(viewModel: LessonDetailViewModel(
            lesson: Lesson(
                title: "Introduction to SwiftUI",
                content: "SwiftUI is a modern framework for building user interfaces across all Apple platforms. It provides a declarative syntax that makes it easy to create beautiful, responsive apps with less code than ever before.\n\nIn this lesson, we'll explore the fundamental concepts of SwiftUI, including views, modifiers, and state management. You'll learn how to create your first SwiftUI app and understand the key differences between SwiftUI and UIKit.",
                duration: 25,
                lessonType: .reading,
                videoURL: nil,
                resources: [
                    LessonResource(
                        title: "SwiftUI Documentation",
                        url: "https://developer.apple.com/documentation/swiftui",
                        type: .link
                    ),
                    LessonResource(
                        title: "Sample Code",
                        url: "https://github.com/apple/swiftui-examples",
                        type: .link
                    )
                ]
            )
        ))
    }
}

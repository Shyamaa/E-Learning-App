//
//  CourseListView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation
import SwiftUI

struct CourseListView: View {
    @StateObject private var viewModel = CourseListViewModel()
    @EnvironmentObject var loginVM: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.courses.isEmpty {
                    // Loading or empty state
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Loading courses...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // Course list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.courses) { course in
                                NavigationLink(destination: LessonListView(course: course)) {
                                    CourseCardView(course: course)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Courses")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Course Card View
struct CourseCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Course header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(course.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .font(.caption)
            }
            
            // Course stats
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    
                    Text("\(course.lessons.count) lessons")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    
                    Text("~\(course.estimatedDuration) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Progress indicator
                HStack(spacing: 4) {
                    Image(systemName: course.isCompleted ? "checkmark.circle.fill" : "play.circle.fill")
                        .foregroundColor(course.isCompleted ? .green : .blue)
                        .font(.caption)
                    
                    Text(course.isCompleted ? "Completed" : "Ready to start")
                        .font(.caption)
                        .foregroundColor(course.isCompleted ? .green : .blue)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CourseListView()
        .environmentObject(LoginViewModel())
}

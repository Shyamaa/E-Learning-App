//
//  HomeView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var viewModel = CourseListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    WelcomeHeaderView(user: loginVM.currentUser)
                    
                    // Progress Overview
                    ProgressOverviewView(user: loginVM.currentUser)
                    
                    // Continue Learning
                    ContinueLearningView(courses: viewModel.courses)
                    
                    // Featured Courses
                    FeaturedCoursesView(courses: viewModel.courses)
                    
                    // Quick Actions
                    QuickActionsView()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Welcome Header View
struct WelcomeHeaderView: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back,")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text(user?.firstName ?? "Learner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Current time
                VStack(alignment: .trailing, spacing: 4) {
                    Text(Date().formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Motivational message
            Text("Ready to continue your learning journey?")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

// Progress Overview View
struct ProgressOverviewView: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                // Completion Rate
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(user?.progress.completionRate ?? 0) / 100)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(user?.progress.completionRate ?? 0))%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Text("Completion")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 12) {
                    // Current Streak
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(user?.progress.currentStreak ?? 0) days")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Current Streak")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Study Time
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(user?.progress.totalStudyTime ?? 0) min")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Total Study Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Continue Learning View
struct ContinueLearningView: View {
    let courses: [Course]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Continue Learning")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if courses.isEmpty {
                Text("No courses in progress")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(courses.prefix(3)) { course in
                            NavigationLink(destination: LessonListView(course: course)) {
                                ContinueLearningCardView(course: course)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// Continue Learning Card View
struct ContinueLearningCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Course image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 200, height: 120)
                .overlay(
                    Image(systemName: course.category.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(course.instructor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Progress bar
                ProgressView(value: 0.3)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 4)
                
                Text("30% Complete")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 200)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Featured Courses View
struct FeaturedCoursesView: View {
    let courses: [Course]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Courses")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if courses.isEmpty {
                Text("No featured courses available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            } else {
                VStack(spacing: 12) {
                    ForEach(courses.prefix(2)) { course in
                        NavigationLink(destination: LessonListView(course: course)) {
                            FeaturedCourseRowView(course: course)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// Featured Course Row View
struct FeaturedCourseRowView: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 12) {
            // Course image placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: course.category.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(course.instructor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Text(course.difficulty.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(course.difficulty.color).opacity(0.2))
                        )
                        .foregroundColor(Color(course.difficulty.color))
                    
                    Text("\(course.estimatedDuration) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
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

// Quick Actions View
struct QuickActionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionButton(
                    title: "Browse Courses",
                    icon: "book.fill",
                    color: .blue
                ) {
                    // Navigate to courses
                }
                
                QuickActionButton(
                    title: "My Progress",
                    icon: "chart.bar.fill",
                    color: .green
                ) {
                    // Navigate to progress
                }
                
                QuickActionButton(
                    title: "Achievements",
                    icon: "star.fill",
                    color: .orange
                ) {
                    // Navigate to achievements
                }
                
                QuickActionButton(
                    title: "Settings",
                    icon: "gear",
                    color: .purple
                ) {
                    // Navigate to settings
                }
            }
        }
    }
}

// Quick Action Button View
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LoginViewModel())
} 
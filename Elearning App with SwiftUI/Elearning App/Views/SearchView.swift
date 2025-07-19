//
//  SearchView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = CourseListViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: Course.CourseCategory?
    @State private var selectedDifficulty: Course.CourseDifficulty?
    
    var filteredCourses: [Course] {
        var courses = viewModel.courses
        
        // Filter by search text
        if !searchText.isEmpty {
            courses = courses.filter { course in
                course.title.localizedCaseInsensitiveContains(searchText) ||
                course.description.localizedCaseInsensitiveContains(searchText) ||
                course.instructor.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by category
        if let category = selectedCategory {
            courses = courses.filter { $0.category == category }
        }
        
        // Filter by difficulty
        if let difficulty = selectedDifficulty {
            courses = courses.filter { $0.difficulty == difficulty }
        }
        
        return courses
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Filter Chips
                FilterChipsView(
                    selectedCategory: $selectedCategory,
                    selectedDifficulty: $selectedDifficulty
                )
                .padding(.horizontal)
                
                // Results
                if viewModel.courses.isEmpty {
                    // Loading state
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Loading courses...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredCourses.isEmpty {
                    // No results
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No courses found")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Try adjusting your search or filters")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Course list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredCourses) { course in
                                NavigationLink(destination: LessonListView(course: course)) {
                                    SearchCourseCardView(course: course)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Search Bar View
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search courses, instructors...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Filter Chips View
struct FilterChipsView: View {
    @Binding var selectedCategory: Course.CourseCategory?
    @Binding var selectedDifficulty: Course.CourseDifficulty?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Category filters
                ForEach(Course.CourseCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        if selectedCategory == category {
                            selectedCategory = nil
                        } else {
                            selectedCategory = category
                        }
                    }
                }
                
                Divider()
                    .frame(height: 20)
                
                // Difficulty filters
                ForEach(Course.CourseDifficulty.allCases, id: \.self) { difficulty in
                    FilterChip(
                        title: difficulty.rawValue,
                        icon: "flag.fill",
                        isSelected: selectedDifficulty == difficulty,
                        color: Color(difficulty.color)
                    ) {
                        if selectedDifficulty == difficulty {
                            selectedDifficulty = nil
                        } else {
                            selectedDifficulty = difficulty
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Filter Chip View
struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    init(title: String, icon: String, isSelected: Bool, color: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color : Color(.systemGray5))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

// Search Course Card View
struct SearchCourseCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Course header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
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
            
            // Course metadata
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: course.category.icon)
                        .foregroundColor(.blue)
                        .font(.caption)
                    
                    Text(course.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    
                    Text(course.instructor)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    
                    Text("\(course.estimatedDuration) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Difficulty badge
            HStack {
                Text(course.difficulty.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(course.difficulty.color).opacity(0.2))
                    )
                    .foregroundColor(Color(course.difficulty.color))
                
                Spacer()
                
                Text("\(course.lessons.count) lessons")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SearchView()
} 
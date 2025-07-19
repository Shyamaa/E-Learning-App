//
//  CourseListViewModel.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

class CourseListViewModel {
    var courses: [Course] = []
    
    // Callbacks for UI updates
    var onCoursesLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let courseService: CourseService
    
    init(courseService: CourseService = MockCourseService()) {
        self.courseService = courseService
        loadCourses()
    }
    
    func loadCourses() {
        courseService.fetchCourses { [weak self] courses in
            DispatchQueue.main.async {
                self?.courses = courses
                self?.onCoursesLoaded?()
            }
        }
    }
    
    func refreshCourses() {
        loadCourses()
    }
} 
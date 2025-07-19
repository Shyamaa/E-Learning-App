//
//  CourseListViewModel.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private let courseService: CourseService

    init(courseService: CourseService = MockCourseService()) {
        self.courseService = courseService
        loadCourses()
    }

    func loadCourses() {
        courseService.fetchCourses { [weak self] result in
            self?.courses = result
        }
    }
}

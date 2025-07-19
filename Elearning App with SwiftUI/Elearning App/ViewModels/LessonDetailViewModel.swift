//
//  LessonDetailViewModel.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import Foundation

class LessonDetailViewModel: ObservableObject {
    let lesson: Lesson

    init(lesson: Lesson) {
        self.lesson = lesson
    }
}

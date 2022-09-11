//
//  Course.swift
//  Networking
//
//  Created by Daniil Oreshenkov on 29.08.2022.
//

import Foundation

struct Course: Decodable {
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
    let number_of_tests: Int
    
    init(name: String, imageUrl: String, numberOfLessons: Int, numberOfTests: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.number_of_lessons = numberOfLessons
        self.number_of_tests = numberOfTests
    }
}

struct Course2: Codable {
    let name: String
    let imageUrl: String
    let number_of_lessons: String
    let number_of_tests: String
}

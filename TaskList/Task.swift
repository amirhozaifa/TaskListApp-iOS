//
//  Task.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import Foundation

struct Task: Identifiable & Hashable {
    let id: String
    let title: String
    let description: String
    let date: Date
    
    init(id: String, title: String, description: String, date: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
    }
    
    init(title: String, description: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.date = date
    }
}

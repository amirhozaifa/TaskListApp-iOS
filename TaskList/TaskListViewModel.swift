//
//  TaskListViewModel.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import Foundation
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    init() {
        loadTasks()
        tasks = [
            Task(title: "Sample Title 1", description: "Sample description 1", date: .now),
            Task(title: "Sample Title 2", description: "Sample description 2", date: .now),
            Task(title: "Sample Title 3", description: "Sample description 3", date: .now),
        ]
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        saveTasks()
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll(where: {$0.id == task.id})
        saveTasks()
    }
    func deleteTask(index: IndexSet) {
        tasks.remove(atOffsets: index)
        saveTasks()
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasksInfo"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        } else {
            tasks = []
        }
    }
    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasksInfo")
        }
    }
}

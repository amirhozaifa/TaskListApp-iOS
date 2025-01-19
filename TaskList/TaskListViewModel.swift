//
//  TaskListViewModel.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import Foundation

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    init() {
        tasks = [
//            Task(title: "A", description: "AA", date: .now),
//            Task(title: "A", description: "AA", date: .now),
//            Task(title: "B", description: "AA", date: .now),
        ]
    }
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func updateTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll(where: {$0.id == task.id})
    }
    func deleteTask(index: IndexSet) {
        tasks.remove(atOffsets: index)
    }
    
}

//
//  TaskListViewModel.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [Task] = []
    
    init() {
        loadTasks()
        tasks = [
            Task(title: "Sample Title 1", description: "Sample description 1", date: .now),
            Task(title: "Sample Title 2", description: "Sample description 2", date: .now),
            Task(title: "Sample Title 3", description: "Sample description 3", date: .now),
        ]
        addSubscribers()
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
    
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var filteredTasks: [Task] = []
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterTask()
            }
            .store(in: &cancellables)
    }
    
    private func filterTask() {
        guard !searchText.isEmpty else {
            filteredTasks = []
            return
        }
        
        let search = searchText.lowercased()
        filteredTasks = tasks.filter({ task in
            let titleContainsSearch = task.title.lowercased().contains(search)
            let descriptionContainsSearch = task.description.lowercased().contains(search)
            return titleContainsSearch || descriptionContainsSearch
        })
    }
}

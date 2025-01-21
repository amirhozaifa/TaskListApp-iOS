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
        tasks = [
            Task(title: "Sample Title 1", description: "Sample description 1", date: .now),
            Task(title: "Sample Title 2", description: "Sample description 2", date: .now),
            Task(title: "Sample Title 3", description: "Sample description 3", date: .now),
        ]
        loadTasks()
        addSubscribers()
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        setNotification(task)
        filterTasks()
        saveTasks()
    }
    
    func updateTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            removeNotification(tasks[index])
            tasks[index] = task
            setNotification(task)
        }
        filterTasks()
        saveTasks()
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll(where: {$0.id == task.id})
        removeNotification(task)
        filterTasks()
        saveTasks()
    }
    func deleteTask(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        removeNotification(tasks[index])
        tasks.remove(at: index)
        filterTasks()
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
                self?.filterTasks()
            }
            .store(in: &cancellables)
    }
    
    private func filterTasks() {
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
    
    private var taskNotificationIdentifiers: [String : String] = [:]
    
    private func setNotification(_ task: Task) {
        if !task.isReminderOn {
            return
        }
        removeNotification(task)
        
        let totalSecondsToSubtract = TimeInterval(task.reminderDays * 24 * 60 * 60 + task.reminderHours * 3600 + task.reminderMinutes * 60)
        let reminderDate = task.date.addingTimeInterval(-totalSecondsToSubtract)
        
        NotificationManager.instance.requestAuthorization()
        let notificationIdentifier = NotificationManager.instance.scheduleNotification(taskTitle: task.title, taskDate: task.date, reminderDate: reminderDate)
        
        taskNotificationIdentifiers[task.id] = notificationIdentifier
    }
    
    private func removeNotification(_ task: Task) {
        NotificationManager.instance.deleteNotification(taskNotificationIdentifiers[task.id])
        taskNotificationIdentifiers.removeValue(forKey: task.id)
    }
}

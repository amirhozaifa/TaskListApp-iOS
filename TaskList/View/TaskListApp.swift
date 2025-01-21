//
//  TaskListApp.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import SwiftUI

@main
struct TaskListApp: App {
    
    @StateObject var taskListViewModel: TaskListViewModel = TaskListViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
        }
        .environmentObject(taskListViewModel)
    }
}

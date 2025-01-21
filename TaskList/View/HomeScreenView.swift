//
//  HomeScreenView.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var taskListViewModel: TaskListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if taskListViewModel.tasks.isEmpty {
                    VStack {
                        Image(systemName: "text.document")
                            .font(.largeTitle)
                        Text("No tasks here yet")
                        
                    }
                    .foregroundColor(Color.secondary)
                } else {
                    List {
                        let highPriorityTasks = filteredTasks(by: .high)
                        let normalPriorityTasks = filteredTasks(by: .normal)
                        let lowPriorityTasks = filteredTasks(by: .low)

                        if !highPriorityTasks.isEmpty {
                            Section("High Priority Tasks") {
                                ForEach(highPriorityTasks) { task in
                                    TaskRowView(task: task)
                                }
                            }
                        }

                        if !normalPriorityTasks.isEmpty {
                            Section("Normal Priority Tasks") {
                                ForEach(normalPriorityTasks) { task in
                                    TaskRowView(task: task)
                                }
                            }
                        }

                        if !lowPriorityTasks.isEmpty {
                            Section("Low Priority Tasks") {
                                ForEach(lowPriorityTasks) { task in
                                    TaskRowView(task: task)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $taskListViewModel.searchText)
            .navigationTitle("Tasks")
            .navigationBarItems(
                trailing:
                    NavigationLink(
                    destination: {
                        AddTaskView(task: Task(), viewMode: false)
                    }, label: {
                        Image(systemName: "plus.circle")
                            .fontWeight(.bold)
                    })
            )
        }
    }
    
    private func filteredTasks(by priority: Task.Priority) -> [Task] {
        let tasks = taskListViewModel.isSearching ? taskListViewModel.filteredTasks : taskListViewModel.tasks
        return tasks.filter { $0.priority == priority }
    }
}

struct TaskRowView: View {
    @EnvironmentObject var taskListViewModel: TaskListViewModel
    var task: Task
    
    @State var showAlert: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(
            destination: {
                AddTaskView(task: task, viewMode: true)
            }, label: {})
            .opacity(0)
            .overlay(content: {
                Text("\(task.title)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .foregroundColor(.primary)
            Spacer()
            Menu {
                NavigationLink(
                destination: {
                    AddTaskView(task: task, viewMode: false)
                }, label: {
                    Text("Edit")
                })
                Button("Delete") {
                    showAlert.toggle()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(Angle(degrees: 90))
                    .padding(.leading)
                    .frame(maxHeight: .infinity)
                    .accentColor(Color.primary)
            }
        }
        .alert("Are you sure?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
                taskListViewModel.deleteTask(task: task)
            }
        }
    }
    
}

#Preview {
    HomeScreenView()
        .environmentObject(TaskListViewModel())
}

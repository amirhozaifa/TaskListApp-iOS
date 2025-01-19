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
            List {
                Section("List") {
                    ForEach(taskListViewModel.tasks) { task in
                        TaskRowView(task: task)
                    }
                }
            }
            .navigationTitle("App Title")
            .navigationBarItems(
                trailing:
                    NavigationLink(
                    destination: {
                        AddTaskView(task: Task(title: "", description: "", date: .now))
                    }, label: {
                        Image(systemName: "plus.circle")
                            .fontWeight(.bold)
                    })
            )
        }
    }
}

struct TaskRowView: View {
    @EnvironmentObject var taskListViewModel: TaskListViewModel
    var task: Task
    
    @State var showAlert: Bool = false
    
    var body: some View {
        HStack {
            Text("\(task.title)")
            Spacer()
            Menu {
                NavigationLink(
                destination: {
                    AddTaskView(task: task)
                }, label: {
                    Button("Update") {
                        
                    }
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

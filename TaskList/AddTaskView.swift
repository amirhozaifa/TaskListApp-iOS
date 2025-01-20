//
//  AddTaskView.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskListViewModel: TaskListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var task: Task
    let isViewOnly: Bool
    @State var title: String = ""
    @State var description: String = ""
    @State var date: Date = Date()
    
    init(task: Task, isViewOnly: Bool) {
        self.title = task.title
        self.description = task.description
        self.date = task.date
        self.task = task
        self.isViewOnly = isViewOnly
    }
    
    var body: some View {
        List() {
            TextField("Title", text: $title)
                .disabled(isViewOnly)
            VStack {
                Text("Description")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top)
                TextEditor(text: $description)
                    .textEditorStyle(.plain)
                    .frame(minHeight: 45)
                    .disabled(isViewOnly)
            }
            Group {
                if isViewOnly {
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .disabled(true)
                } else {
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                if (!isViewOnly) {
                    if (task.title.isEmpty) {
                        Text("New Task")
                    } else {
                        Text("Update Task")
                    }
                }
            }
        })
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }),
            trailing:
                Group {
                    if isViewOnly {
                        NavigationLink(
                            destination: AddTaskView(task: task, isViewOnly: false),
                            label: {
                                Text("Edit")
                            }
                        )
                    } else {
                        Button(action: {
                            if task.title.isEmpty {
                                taskListViewModel.addTask(task: Task(title: title, description: description, date: date))
                            } else {
                                taskListViewModel.updateTask(task: Task(id: task.id, title: title, description: description, date: date))
                            }
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                        }
                        )
                        .disabled(title.isEmpty || (title == task.title && description == task.description && date == task.date))
                    }
                }
                    
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        AddTaskView(task: Task(title: "", description: "", date: .now), isViewOnly: true)
    }
    .environmentObject(TaskListViewModel())
}

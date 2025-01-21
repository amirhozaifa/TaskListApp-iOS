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
    @State var viewMode: Bool
    @State var title: String = ""
    @State var description: String = ""
    @State var date: Date = Date()
    @State var isReminderOn: Bool = false
    @State var remindImmediately: Bool = false
        
    
    @State var reminderDays: Int = 0
    @State var reminderHours: Int = 0
    @State var reminderMinutes: Int = 0

    
    init(task: Task, viewMode: Bool) {
        self.title = task.title
        self.description = task.description
        self.date = task.date
        self.isReminderOn = task.isReminderOn
        self.remindImmediately = task.remindImmediately
        self.reminderDays = task.reminderDays
        self.reminderHours = task.reminderHours
        self.reminderMinutes = task.reminderMinutes
        
        self.task = task
        self.viewMode = viewMode
    }
    
    var body: some View {
        List() {
            TextField("Title", text: $title)
                .disabled(viewMode)
            VStack {
                Text("Description")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top)
                TextEditor(text: $description)
                    .textEditorStyle(.plain)
                    .frame(minHeight: 45)
                    .disabled(viewMode)
            }
            Group {
                if viewMode {
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .disabled(true)
                } else {
                    DatePicker("Date", selection: $date, in: .now...)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
            VStack {
                Toggle("Reminder", isOn: $isReminderOn)
                    .padding(.vertical, 5)
                    .disabled(viewMode)
                
                if isReminderOn {
                    VStack {
                        Toggle("Remind Immediately", isOn: $remindImmediately)
                            .padding(.vertical, 5)
                            .disabled(viewMode)
                        
                        if !remindImmediately {
                            VStack {
                                Text("Before")
                                Picker("Days", selection: $reminderDays) {
                                    ForEach(0..<31) { days in
                                        Text("\(days)d").tag(days)
                                    }
                                }
                                .disabled(viewMode)
                                .pickerStyle(MenuPickerStyle())
                                
                                Picker("Hours", selection: $reminderHours) {
                                    ForEach(0..<24) { hours in
                                        Text("\(hours)h").tag(hours)
                                    }
                                }
                                .disabled(viewMode)
                                .pickerStyle(MenuPickerStyle())
                                
                                Picker("Minutes", selection: $reminderMinutes) {
                                    ForEach(0..<60) { minutes in
                                        Text("\(minutes)m").tag(minutes)
                                    }
                                }
                                .disabled(viewMode)
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                if (!viewMode) {
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
                    if viewMode {
                        Button {
                            withAnimation {
                                viewMode.toggle()
                            }
                        } label: {
                            Text("Edit")
                        }
                    } else {
                        let currentTaskData: Task = Task(id: task.id, title: title, description: description, date: date, isReminderOn: isReminderOn, remindImmediately: remindImmediately, reminderDays: reminderDays, reminderHours: reminderHours, reminderMinutes: reminderMinutes)
                        Button(action: {
                                if task.title.isEmpty {
                                    taskListViewModel.addTask(task: currentTaskData)
                                } else {
                                    taskListViewModel.updateTask(task: currentTaskData)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Save")
                            }
                        )
                        .disabled(title.isEmpty || Task.isEqual(currentTaskData, task))
                    }
                }
                    
        )
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        AddTaskView(task: Task(), viewMode: false)
    }
    .environmentObject(TaskListViewModel())
}

//
//  AlertController.swift
//  RealmTasklistApp
//
//  Created by User on 18.01.2024.
//

import UIKit

protocol TaskListAlert {
    var listTitle: String? { get }
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController
}

protocol TaskAlert {
    var taskTitle: String? { get }
    var taskNote: String? { get }
    func createAlert(completion: @escaping (String, String) -> Void) -> UIAlertController
}

final class TaskListAlertControllerFactory: TaskListAlert {
    var listTitle: String?
    private let userAction: UserAction
    
    init(userAction: UserAction, listTitle: String?) {
        self.userAction = userAction
        self.listTitle = listTitle
    }
    
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: "Please set title for new task list",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let listTitle = alertController.textFields?.first?.text else { return }
            guard !listTitle.isEmpty else { return }
            completion(listTitle)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "New List"
            textField.text = self?.listTitle
        }
        
        return alertController
    }
}

// MARK: - TaskListUserAction
extension TaskListAlertControllerFactory {
    enum UserAction {
        case newList
        case editList
        
        var title: String {
            switch self {
            case .newList:
                return "New List"
            case .editList:
                return "Edit List"
            }
        }
    }
}

final class TaskAlertControllerFactory: TaskAlert {
    var taskTitle: String?
    var taskNote: String?
    
    private let userAction: UserAction
    
    init(userAction: UserAction, taskTitle: String?, taskNote: String?) {
        self.userAction = userAction
        self.taskTitle = taskTitle
        self.taskNote = taskNote
    }
    
    func createAlert(completion: @escaping (String, String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskTitle = alertController.textFields?.first?.text else { return }
            guard !taskTitle.isEmpty else { return }
            
            if let taskNote = alertController.textFields?.last?.text, !taskNote.isEmpty {
                completion(taskTitle, taskNote)
            } else {
                completion(taskTitle, "")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "New Task"
            textField.text = self?.taskTitle
        }
        
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "Note"
            textField.text = self?.taskNote
        }
        
        return alertController
    }
}

// MARK: - TaskUserAction
extension TaskAlertControllerFactory {
    enum UserAction {
        case newTask
        case editTask
        
        var title: String {
            switch self {
            case .newTask:
                return "New Task"
            case .editTask:
                return "Edit Task"
            }
        }
    }
}

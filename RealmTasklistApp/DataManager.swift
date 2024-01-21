//
//  DataManager.swift
//  RealmTasklistApp
//
//  Created by User on 18.01.2024.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let storageManager = StorageManager.shared
    
    private init() {}
    
    func createTempData(completion: @escaping () -> Void) {
        let shoppingList = TaskList()
        shoppingList.title = "Shopping List"
        
        let moviesList = TaskList(
            value: [
                "Movies List",
                Date(),
                [
                    ["The best of the best", "Must have", Date(), true],
                    ["Best film ever"]
                ]
            ]
        )
        
        let milk = Task()
        milk.title = "Milk"
        milk.note = "2L"
        
        let bread = Task(value: ["Bread", "", Date(), true])
        let apples = Task(value: ["title": "Apples", "note": "2Kg"])
        
        shoppingList.tasks.append(milk)
        shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
        
        DispatchQueue.main.async { [unowned self] in
            storageManager.save([shoppingList, moviesList])
            completion()
        }
    }
}

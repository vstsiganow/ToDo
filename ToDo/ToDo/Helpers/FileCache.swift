//
//  FileCache.swift
//  ToDo
//
//  Created by vtsyganov on 17.07.2022.
//

import Foundation



protocol FileCacheSpec {
    func addTodoItem(_ item: TodoItem) -> Bool
    func removeTodoItem(id: String)
    func saveItemsToCacheFile(name: String)
    func loadItemsFromCacheFile(name: String)
}

enum FileCacheError: Error {
    case existingId, notExistingId
}

final class FileCache: FileCacheSpec {
    // -MARK: Properties
    public var todoItems: [TodoItem] = []
    public var todoItemsName: String = ""
    
    // -MARK: Private properties
    private let defaultsKeyHelper = DefaultsKeyHelper.shared
    
    // -MARK: FileCacheSpec
    func addTodoItem(_ item: TodoItem) -> Bool {
        if let _ = getItemIndexFor(id: item.id) {
            todoItems.append(item)
            return true
        } else {
            return false
        }
    }
    
    func removeTodoItem(id: String) {
        guard let index = getItemIndexFor(id: id) else {
            return
        }
        todoItems.remove(at: index)
    }
    
    func saveItemsToCacheFile(name: String) {
        defaultsKeyHelper.setDataWith(data: todoItems, key: name)
    }
    
    func loadItemsFromCacheFile(name: String) {
        let data = defaultsKeyHelper.getDataFor(name)
        
        let items = convertJSONToItems(data)
        
        todoItems.removeAll()
        todoItems = items
    }
    
    func setListName() {
        guard let listName = defaultsKeyHelper.getCurrentDefaultsKey() else { return }
        todoItemsName = listName
    }
    
    // -MARK: Private methods
    private func convertItemsToJSON(_ items: [TodoItem]) -> [Any] {
        var jsonItems = [Any]()
        for item in items {
            jsonItems.append(item.json)
        }
        return jsonItems
    }
    
    private func convertJSONToItems(_ json: [Any]) -> [TodoItem] {
        var todoItems = [TodoItem]()
        for jsonItem in json {
            if let item = TodoItem.parse(json: jsonItem) {
                todoItems.append(item)
            }
        }
        return todoItems
    }
    
    private func getItemIndexFor(id: String) -> Int? {
        for item in 0...todoItems.count-1 {
            if todoItems[item].id == id {
                return item
            }
        }
        
        return nil
    }
}

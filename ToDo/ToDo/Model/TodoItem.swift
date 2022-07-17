//
//  TodoItem.swift
//  ToDo
//
//  Created by vtsyganov on 13.07.2022.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let significance: Significance
    let deadline: Date?
}

enum Significance: String {
    case low, common, high
}


extension TodoItem {
    
    private struct TodoItemJSON {
        let id: String
        let text: String
        let significance: String?
        let deadline: TimeInterval?
    }
    
    private var todoItemJSON: TodoItemJSON {
        let significance = self.significance != .common ? self.significance.rawValue : nil
        let deadline = self.deadline != nil ? self.deadline!.timeIntervalSince1970 : nil
        
        return TodoItemJSON(id: id, text: text, significance: significance, deadline: deadline)
    }
    
    var json: Any {
        let mirror = Mirror(reflecting: todoItemJSON)
        
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        return jsonData
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let data = json as? Data else { return nil }
        
        var significance: Significance?
        var date: Date?
        
        
        do {
            let prettyDictionaryData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let itemDict = prettyDictionaryData as? [String: Any] else { return nil }
            
            let jsonItem = TodoItemJSON(id: itemDict["id"] as! String, text: itemDict["text"] as! String, significance: itemDict["significance"] as? String, deadline: itemDict["deadline"] as? TimeInterval)
            
            if let significanceString = jsonItem.significance {
                significance = Significance(rawValue: significanceString)
            }
            
            if let deadline = jsonItem.deadline {
                date = Date(timeIntervalSince1970: deadline)
            }
            
            let item = TodoItem(id: jsonItem.id, text: jsonItem.text, significance: significance ?? Significance.common, deadline: date ?? nil)

            return item
            
        } catch {
            print("wrong data")
            return nil
        }
    }
    
}

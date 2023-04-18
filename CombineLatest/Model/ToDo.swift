//
//  ToDo.swift
//  CombineLatest
//
//  Created by Darshan on 16/04/23.
//

import Foundation
import CoreData

struct ToDoManager{
    private let toDorepository = ToDoModelRepository()
    
    func createCDToDo(user:CDUser,todo:ToDoModel){
        toDorepository.create(user:user,todo: todo)
    }
    func fetchToDo()->[ToDoModel]?{
        return toDorepository.getAll()
    }
    func fetchToDo(byIdentifier id:UUID)->ToDoModel?{
        return toDorepository.get(byIdentifier: id)
    }
    func updateToDo(todo:ToDoModel)->Bool{
        return toDorepository.update(todo: todo)
    }
    func deleteToDo(id:UUID)->Bool{
        return toDorepository.delete(id: id)
    }
    func getAllToDo()->[ToDoModel]?{
        return toDorepository.getAll()
    }
}

protocol ToDoModelDelegate{
    func create(user:CDUser,todo:ToDoModel)
    func getAll() ->[ToDoModel]?
    func get(byIdentifier id:UUID) -> ToDoModel?
    func update(todo:ToDoModel) -> Bool
    func delete(id:UUID) -> Bool
}
struct ToDoModelRepository:ToDoModelDelegate{
    
    func create(user:CDUser,todo: ToDoModel) {
        let cdToDo = CDToDo.init(context: CoreDataManager.shared.context)
        cdToDo.name = todo.name
        cdToDo.id = todo.id
        user.addToUserToDo(cdToDo)
        CoreDataManager.shared.saveContext()
    }
    
    func getAll() -> [ToDoModel]? {
        guard let result = CoreDataManager.shared.fetchManagedObject(manageObject: CDToDo.self) else{
            return nil
        }
        var arrayToDoModel = [ToDoModel]()
        for cdToDo in result{
            arrayToDoModel.append(cdToDo.getToDoModelFromCDToDo())
        }
        return arrayToDoModel
    }
    
    func get(byIdentifier id: UUID) -> ToDoModel? {
        if let todo = self.getCDToDo(byID: id){
            return todo.getToDoModelFromCDToDo()
        }else{
            return nil
        }
    }
    
    func update(todo: ToDoModel) -> Bool {
        guard let toDoID = todo.id else{return false}
        let result = self.getCDToDo(byID: toDoID)
        guard let result else{return false}
        result.id = todo.id
        result.name = todo.name
        CoreDataManager.shared.saveContext()
        return true
    }
    
    func delete(id: UUID) -> Bool {
        let result = self.getCDToDo(byID: id)
        guard let result else{return false}
        CoreDataManager.shared.context.delete(result)
        CoreDataManager.shared.saveContext()
        return true
    }
    
    private func getCDToDo(byID id:UUID)->CDToDo?{
        let fetchRequest = NSFetchRequest<CDToDo>(entityName: "CDToDo")
        fetchRequest.predicate = NSPredicate.init(format: "id==%@", id as CVarArg)
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest) as [CDToDo]
            guard let firstObject = result.first else{
                return nil
            }
            return firstObject
        }catch let error{
            debugPrint(error)
            return nil
        }
    }
}
struct ToDoModel{
    var id: UUID?
    var name: String?
}

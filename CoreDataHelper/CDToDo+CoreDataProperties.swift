//
//  CDToDo+CoreDataProperties.swift
//  
//
//  Created by Darshan on 16/04/23.
//
//

import Foundation
import CoreData


extension CDToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDToDo> {
        return NSFetchRequest<CDToDo>(entityName: "CDToDo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var toUser: CDUser?

}
extension CDToDo : Identifiable {

    func getToDoModelFromCDToDo()->ToDoModel{
        var objToDo = ToDoModel()
        objToDo.name  = self.name
        objToDo.id  = self.id
        return objToDo
    }
}

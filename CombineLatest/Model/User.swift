//
//  User.swift
//  CombineLatest
//
//  Created by Darshan on 13/04/23.
//

import Foundation
import CoreData

struct UserManager{
    
    private let userDatarepository = UserModelRepository()
    
    
    func createUser(user:UserModel)->CDUser?{
        userDatarepository.create(user: user)
    }
    func fetchUser()->[UserModel]?{
        return userDatarepository.getAll()
    }
    func fetchUser(byIdentifier id:UUID)->UserModel?{
        return userDatarepository.get(byIdentifier: id)
    }
    func fetchUser(byEmail email:String)->CDUser?{
        return userDatarepository.get(byEmail:email)
    }
    func updateUser(user:UserModel)->Bool{
        return userDatarepository.update(user: user)
    }
    func deleteUser(id:UUID)->Bool{
        return userDatarepository.delete(id: id)
    }
    func getAllUser()->[UserModel]?{
        return userDatarepository.getAll()
    }
    
}

protocol UserModelDelegate{
    func create(user:UserModel)->CDUser?
    func getAll() ->[UserModel]?
    func get(byIdentifier id:UUID) -> UserModel?
    func get(byEmail email:String)->CDUser?
    func update(user:UserModel) -> Bool
    func delete(id:UUID) -> Bool
    
}
struct UserModelRepository:UserModelDelegate{
    
    func create(user: UserModel)-> CDUser?{
        let cdUser = CDUser.init(context: CoreDataManager.shared.context)
        cdUser.email = user.email
        cdUser.password = user.password
        cdUser.id = user.id
        CoreDataManager.shared.saveContext()
        
        guard let result = CoreDataManager.shared.fetchManagedObject(manageObject: CDUser.self) else{
            return nil
        }
        let userdata = result.filter{$0.email == user.email}
        if userdata.count > 0{
            return userdata[0]
        }else{
            return nil
        }
        
    }
    
    func getAll() -> [UserModel]? {
        guard let result = CoreDataManager.shared.fetchManagedObject(manageObject: CDUser.self) else{
            return nil
        }
        var arrayUserModel = [UserModel]()
        for cdUser in result{
            arrayUserModel.append(cdUser.getUserFromCDUser())
        }
        return arrayUserModel
    }
    func get(byEmail email: String) -> CDUser? {
        if let cdUser = self.getCDUser(byEmail: email){
            return cdUser
        }else{
            return nil
        }
    }
    func get(byIdentifier id: UUID) -> UserModel? {
        if let cdUser = self.getCDUser(byID: id){
            return cdUser.getUserFromCDUser()
        }else{
            return nil
        }
    }
    func update(user:UserModel) -> Bool{
        guard let userId = user.id else{return false}
        let result = self.getCDUser(byID: userId)
        guard let result else{return false}
        result.email = user.email
        result.password = user.password
        result.id = user.id
        CoreDataManager.shared.saveContext()
        return true
    }
    func delete(id: UUID)->Bool {
        let result = self.getCDUser(byID: id)
        guard let result else{return false}
        CoreDataManager.shared.context.delete(result)
        CoreDataManager.shared.saveContext()
        return true
    }
    
    private func getCDUser(byID id:UUID)->CDUser?{
        let fetchRequest = NSFetchRequest<CDUser>(entityName: "CDUser")
        fetchRequest.predicate = NSPredicate.init(format: "id==%@", id as CVarArg)
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest) as [CDUser]
            guard let firstObject = result.first else{
                return nil
            }
            return firstObject
        }catch let error{
            debugPrint(error)
            return nil
        }
    }
    private func getCDUser(byEmail email:String)->CDUser?{
        let fetchRequest = NSFetchRequest<CDUser>(entityName: "CDUser")
        fetchRequest.predicate = NSPredicate.init(format: "email==%@", email as CVarArg)
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest) as [CDUser]
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
struct UserModel{
    var email: String?
    var id: UUID?
    var password: String?
}

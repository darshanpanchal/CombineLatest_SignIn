//
//  HomeViewModel.swift
//  CombineLatest
//
//  Created by Darshan on 17/04/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseAuth

final class HomeViewModel{
    
    static let shared = HomeViewModel()
    private init(){}
    var manager:UserManager = UserManager()

    @objc func performLogout(){
        
    }
    func fetchCurrentToDoList(result:@escaping (([ToDoModel])->Void)){
        if let currentUser:CDUser = self.getCurrentUserFromDB(){
            if let todoList:[CDToDo] = currentUser.userToDo?.allObjects as? [CDToDo]{
                let data = todoList.filter{$0.toUser?.email == currentUser.email}
                result(data.map{$0.getToDoModelFromCDToDo()})
            }else{
                result([])
            }
        }else{
            result([])
        }
        
    }
    func logOut(completion:()->Void){
        do{
            let _ = try FirebaseAuth.Auth.auth().signOut()
            kUserDefault.removeObject(forKey: kUserEmail)
            kUserDefault.synchronize()
            completion()
        }catch{
            
        }
    }
    func getCurrentUserFromDB()->CDUser?{
        if let currentEmail = kUserDefault.value(forKey: kUserEmail){
            return manager.fetchUser(byEmail: "\(currentEmail)")
        }else{
            return nil
        }
    }
}

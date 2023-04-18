//
//  HomeViewController.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//

import UIKit
import Firebase
import FirebaseAuth
import MetricKit


class HomeViewController: UIViewController {

    
    var homeViewModel = HomeViewModel.shared
    
    @IBOutlet private var tableViewToDo:UITableView!
    let refreshControl = UIRefreshControl()

    var arrayOfToDoList:[ToDoModel] = []{
        didSet{
            DispatchQueue.main.async{
                self.tableViewToDo.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Navigation
        self.configureNavigationLargeTitle()
        self.navigationItem.rightBarButtonItems = self.getNavigationBarItem()
        if let currentEmail = kUserDefault.value(forKey: kUserEmail){
            self.title = "\(currentEmail)" 
        }
        //Basic Setup
        self.setup()
        self.setupMetric()
    }
    private func setupMetric(){
        let manager = MXMetricManager.shared
        manager.add(self)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.homeViewModel.fetchCurrentToDoList { [weak self] result in
                self?.arrayOfToDoList = result
            }
        }
    }
    @objc @IBAction func logout(_ :UIBarButtonItem){
        self.logOutAlert()
    }
     private func logOutAlert(){
         self.presentAlert(title: "LogOut", message: "Are you sure you want to LogOut?", action1: self.alertAction(name: "Yes", style: .default, color: .blue, completion: { [weak self] in
             self?.homeViewModel.logOut { [weak self] in
                 self?.popToRootViewController()
             }
         }), action2: self.alertAction(name: "No", style: .cancel, color: .red, completion: nil))
    }
   
    @objc private func addToDo(_ : UIBarButtonItem){
        let addAlert = UIAlertController(title: "ToDo", message: "Please add ToDo name to add record.", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "Add", style: .default){[weak self] _ in
            guard let todoName = addAlert.textFields?.first else {return}
            if let text = todoName.text {
                let todoModel =  ToDoModel.init(id:UUID(),name:text)
                if let currentUserDetail = LogInViewModel.shared.getCurrentUserFromDB(){
                    ToDoManager().createCDToDo(user: currentUserDetail, todo: todoModel)
                    CoreDataManager.shared.saveContext()
                }
                self?.homeViewModel.fetchCurrentToDoList { [weak self] result in
                    self?.arrayOfToDoList = result
                }
            }
        }
        yesAction.setValue(UIColor.green, forKey: "titleTextColor")
        addAlert.addAction(yesAction)
        addAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        addAlert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "ToDo"
        })
        self.window?.rootViewController?.present(addAlert, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    func popToRootViewController(){
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfToDoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? UITableViewCell else { return UITableViewCell()}
        cell.textLabel?.text = self.arrayOfToDoList[indexPath.row].name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .destructive, title: nil) { _, _, completion in
            self.presentAlert(title: "Delete", message: "Are you sure you want to Delete?", action1: self.alertAction(name: "Yes", style: .default, color: .blue, completion: { [weak self] in
                if let todo = self?.arrayOfToDoList[indexPath.row]{
                    if ToDoManager().deleteToDo(id: todo.id!){
                        self?.homeViewModel.fetchCurrentToDoList { [weak self] result in
                            self?.arrayOfToDoList = result
                        }
                    }
                }
            }), action2: self.alertAction(name: "No", style: .cancel, color: .red, completion: nil))
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
extension HomeViewController:MXMetricManagerSubscriber{
    
}
extension HomeViewController{
    private func setup(){
        // Do any additional setup after loading the view.
        self.tableViewToDo.delegate = self
        self.tableViewToDo.dataSource = self
        self.tableViewToDo.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCell")
        self.tableViewToDo.reloadData()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableViewToDo.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.refreshControl.endRefreshing()
        self.homeViewModel.fetchCurrentToDoList { [weak self] result in
            self?.arrayOfToDoList = result
        }
    }
    func getNavigationBarItem()->[UIBarButtonItem]{
        var items = [UIBarButtonItem]()
        let add = UIBarButtonItem.init(image:UIImage(systemName: "plus.circle.fill") , style: .plain, target: self, action: #selector(addToDo(_ :)))
        
        let signout = UIBarButtonItem.init(image: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill"), style: .plain, target: self, action: #selector(logout(_:)))
        items.append(signout)
        items.append(add)
        return items
    }
}



//
//  SelectFriendViewController.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-20.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

class SelectFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let completionBlock: (String?) -> Void
    private let tableView = UITableView()
    private let friends: [String]
    
    private let cellIdentifier = "Cell"
    
    init(completionBlock: @escaping (String?) -> Void) {
        self.completionBlock = completionBlock
        self.friends = Array(LocalStorage.friends().keys).sorted()
        super.init(nibName: nil, bundle: nil)
        title = "Select Other Friend"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubviewForAutolayout(tableView)
        tableView.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor)
        tableView.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor)
        tableView.topAnchor.activateConstraint(equalTo: view.topAnchor)
        tableView.bottomAnchor.activateConstraint(equalTo: view.bottomAnchor)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVc))
        
        let addButton = UIButton(type: .contactAdd)
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    func dismissVc() {
        completionBlock(nil)
    }
    
    func addContact() {
        let alert = UIAlertController(title: "Add Friend", message: "Enter a name for your new friend.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Friend's name"
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.completionBlock(alert.textFields?.first?.text)
            
        }))
        
        present(alert, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewCellDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        completionBlock(friends[indexPath.row])
    }
}

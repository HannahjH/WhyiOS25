//
//  PostListTableViewController.swift
//  WhyiOS25
//
//  Created by Hannah Hoff on 3/20/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    var getPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshPosts()
        }
    }
    
    
    // MARK: - Table view data source
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        refreshPosts()
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        
        let addPostAlertController = UIAlertController(title: "Add your Reason", message: nil, preferredStyle: .alert)
        
        var nameTextField = UITextField()
        var cohortTextField = UITextField()
        var reasonTextField = UITextField()
        
        addPostAlertController.addTextField { (textfield) in
            nameTextField = textfield
            nameTextField.placeholder = "Enter your name"
        }
        
        addPostAlertController.addTextField { (textfield) in
            cohortTextField = textfield
            cohortTextField.placeholder = "Enter your cohort"
        }
        
        addPostAlertController.addTextField { (textfield) in
            reasonTextField = textfield
            reasonTextField.placeholder = "Why did you choose iOS?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addPostAlertController.addAction(cancelAction)
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let name = nameTextField.text, !name.isEmpty,
                let reason = reasonTextField.text, !reason.isEmpty,
                let cohort = cohortTextField.text, !cohort.isEmpty else { return }
            PostController.postReason(name: name, cohort: cohort, reason: reason, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.refreshPosts()
                    }
                }
            })
        }
        addPostAlertController.addAction(postAction)
        
        self.present(addPostAlertController, animated: true, completion: nil)
    }
    
    func refreshPosts(){
        PostController.getPosts { (posts) in
            if let posts = posts {
                self.getPosts = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
         let post = getPosts[indexPath.row]
        
        cell.nameLabel.text = post.name
        cell.cohortLabel.text = post.cohort
        cell.reasonLabel.text = post.reason
        
        return cell
    }
}

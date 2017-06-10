//
//  BooksViewController.swift
//  FireBooks
//
//  Created by NYU_SPS on 4/29/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {
    
    var books:[Book] = [Book]()
    var user:User!
    var userCountButton:UIBarButtonItem!
    
    let ref = FIRDatabase.database().reference(withPath: "books")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCountButton =
            UIBarButtonItem(title: "1",
                        style: .plain,
                        target: self,
                        action: #selector(countButtonDidTouched))
        userCountButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.leftBarButtonItem = userCountButton
        
        usersRef.observe(.value, with:{ snapshot in
            if snapshot.exists() {
                self.userCountButton.title = snapshot.childrenCount.description
            }
            else{
                self.userCountButton.title = "0"
            }
        })
        
        ref.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
          
            var items:[Book] = []
            
            for item in snapshot.children {
                
                let book = Book(snapshot: item as! FIRDataSnapshot)
                items.append(book)
            }
            
            self.books = items
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            
            guard let user = user else {return}
            
            self.user = User(authData: user)
            let userRef = self.usersRef.child(self.user.uid)
            userRef.setValue(self.user.email)
            userRef.onDisconnectRemoveValue()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let book = books[indexPath.row]
        cell.textLabel?.text = book.name
        cell.detailTextLabel?.text = book.author
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            let book = books[indexPath.row]
            book.ref?.removeValue()
        }
        
    }
    
    
    
    func countButtonDidTouched() {
        performSegue(withIdentifier: "showUsers", sender: nil)
    }
    
    @IBAction func addBook(_ sender: Any) {
        
        let alert = UIAlertController(title: "Book", message: "Add a Book", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            
            let name = alert.textFields![0]
            let author = alert.textFields![1]
            
            let book = Book(name: name.text!, author: author.text!)
            let bookRef = self.ref.child(name.text!.lowercased())
            
            bookRef.setValue(book.toAnyObject())

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

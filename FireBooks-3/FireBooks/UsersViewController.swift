//
//  UsersViewController.swift
//  FireBooks
//
//  Created by NYU_SPS on 4/29/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {
    
    var users:[String] = [String]()
    
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersRef.observe(.childAdded, with: { snapshot in
            
        guard let email = snapshot.value as? String else { return }
            
            self.users.append(email)
            
            let row = self.users.count - 1
            
            let indexPath  = IndexPath(row: row, section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .top)
            
        })
        
        usersRef.observe(.childRemoved, with: { snapshot in
            
            guard let email = snapshot.value as? String else { return }
            
            for(index, user) in self.users.enumerated(){
                
                if email == user {
                    let indexPath  = IndexPath(row: index, section: 0)
                    self.users.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })

    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user
        
        return cell
    }
    @IBAction func logout(_ sender: Any) {
        
        do {
            
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)

        } catch {
            
        }
        
    }
    
    
    
}

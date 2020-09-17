//
//  CurtainViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit


protocol CurtainViewControllerDelegate {
    func reloadData()
}


class CurtainViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var delegate: CurtainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension CurtainViewController : UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagTableViewCell
        
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTag = tags[indexPath.row]
        delegate?.reloadData()
    }
    
}
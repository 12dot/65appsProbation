//
//  CurtainViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

// MARK: - Delegate protocol for container VC
protocol CurtainViewControllerDelegate {
    func reloadQuestionsData()
}


class CurtainViewController: UIViewController{

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var delegate: CurtainViewControllerDelegate?
    public static let identifierFromContainer = "toCurtainVC"
    private static let tagCellIdentifier = "tagCell"
    
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigurations()
    }
    
    // MARK: - Configurations
    private func tableViewConfigurations(){
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - Extensions tableview
extension CurtainViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkService.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurtainViewController.tagCellIdentifier, for: indexPath) as! TagTableViewCell
        
        cell.tagLabel.text = NetworkService.tags[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkService.tagIndex = indexPath.row
        delegate?.reloadQuestionsData()
    }
    
}

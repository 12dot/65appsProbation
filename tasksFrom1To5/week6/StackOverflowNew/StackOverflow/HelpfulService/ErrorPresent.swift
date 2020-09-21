//
//  ErrorPresent.swift
//  StackOverflow
//
//  Created by 12dot on 20.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit


protocol ErrorPresentable {
    func showError(error: Swift.Error)
}

extension ErrorPresentable where Self: UIViewController {
    func showError(error: Swift.Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.present(self, animated: true, completion: nil)
    }

}

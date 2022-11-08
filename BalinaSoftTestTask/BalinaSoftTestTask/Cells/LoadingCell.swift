//
//  LoadingCell.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    func startActivity() {
        self.activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        self.activityIndicator.stopAnimating()
    }
}

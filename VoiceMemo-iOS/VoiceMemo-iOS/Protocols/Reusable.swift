//
//  Reusable.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/23.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}


// MARK: - Extensions

extension UITableViewCell: Reusable {
    
    static var reuseID: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseID)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseID) as? T else {
            fatalError("Can't Dequeue Cell: \(T.reuseID)")
        }
        
        return cell
    }
    
}

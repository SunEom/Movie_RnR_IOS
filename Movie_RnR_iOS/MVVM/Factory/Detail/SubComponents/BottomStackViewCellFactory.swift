//
//  TopStackViewFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/31.
//

import Foundation
import UIKit

struct BottomStackViewCellFactory {
    func getInstance(tableView: UITableView, indexPath: IndexPath) -> BottomStackViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomStackViewCell", for: indexPath) as! BottomStackViewCell
        cell.viewModel = BottomStackViewCellViewModel()
        cell.setUp()
        cell.bind()
        
        return cell
        
    }
}

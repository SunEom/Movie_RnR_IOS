//
//  TopStackViewFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/31.
//

import Foundation
import UIKit

struct TopStackViewCellFactory {
    func getInstance(tableView: UITableView, indexPath: IndexPath) -> TopStackViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopStackViewCell", for: indexPath) as! TopStackViewCell
        cell.viewModel = TopStackViewCellViewModel()
        cell.cellInit()
        
        return cell
        
    }
}

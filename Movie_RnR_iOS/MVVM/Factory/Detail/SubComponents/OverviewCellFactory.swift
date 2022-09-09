//
//  OverviewCellFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/31.
//

import Foundation
import UIKit

struct OverviewCellFactory {
    func getInstance(tableView: UITableView, indexPath: IndexPath) -> OverviewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
        cell.viewModel = OverviewCellViewModel()
        cell.cellInit()
        return cell
    }
}

//
//  TitleCellFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/31.
//

import Foundation
import UIKit

struct TitleCellFactory {
    func getInstance(tableView: UITableView, indexPath: IndexPath) -> TitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Title, for: indexPath) as! TitleCell
        cell.viewModel = TitleCellViewModel()
        cell.setUp()
        cell.bind()
        return cell
    }
}

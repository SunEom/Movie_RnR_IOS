//
//  CommentCellFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/01.
//

import Foundation
import UIKit

struct CommentCellFactory {
    func getInstance(viewController: CommentViewController, tableView:UITableView, indexPath: IndexPath, comment: Comment) -> CommentCellViewController {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCellViewController
        cell.viewModel = CommentCellViewModel(vc: viewController, comment: comment)
        cell.cellInit()
        return cell
    }
}

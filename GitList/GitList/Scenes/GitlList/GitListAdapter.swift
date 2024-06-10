//
//  GitListAdapter.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import UIKit

enum GitListAdapter {
    static func adaptToGitCellViewModel(_ response: [GitResponse]) -> [GitCellViewModel] {
        response.map { result in
            GitCellViewModel(name: result.owner?.login ?? "",
                             photoURL: result.owner?.avatarUrl ?? "",
                             fileQuantity: "\(result.files.count)")
        }
    }
}

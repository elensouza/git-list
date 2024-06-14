//
//  GitListCellViewModelStub.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation

@testable import GitList

extension GitCellViewModel {
    static func stub(name: String = "LettyVieira",
                     photoURL: String = "https://avatars.githubusercontent.com/u/125707542?v=4",
                     fileQuantity: String = "Arquivos: 1") -> Self {
        .init(name: name,
              photoURL: photoURL,
              fileQuantity: fileQuantity)
    }
}

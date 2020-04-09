//
//  CoreDataProtocols.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 09/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation

protocol CoreDataServiceProtocol {
    func requestFavorites(completion: (_ complete: Bool) -> ())
    func saveFavorites(completion: (_ finished:Bool) -> ())
    func deleteFavorites(index: Int)
}

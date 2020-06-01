//
//  HikeListController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/5/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation

enum HikeListError: Error {
    case failed
}

protocol HikeListController {
    func getHikeList(completion: @escaping (Result<HikeList, HikeListError>) -> Void)
}

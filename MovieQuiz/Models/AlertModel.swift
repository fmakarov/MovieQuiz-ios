//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by paul kellerman on 22.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)
}

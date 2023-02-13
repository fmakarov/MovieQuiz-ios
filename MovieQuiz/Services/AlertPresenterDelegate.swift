//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by paul kellerman on 23.12.2022.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func showResult(model: AlertModel?)
}

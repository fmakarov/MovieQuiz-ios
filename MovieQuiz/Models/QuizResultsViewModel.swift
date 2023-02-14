//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by paul kellerman on 17.12.2022.
//

import Foundation

final class QuizResultsViewModel {
    // для состояния "Результат квиза"
      let title: String
      let text: String
      let buttonText: String
    
    init(title: String, text: String, buttonText: String) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
}

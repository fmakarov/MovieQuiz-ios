//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by paul kellerman on 17.12.2022.
//

import Foundation

final class QuizQuestion {
      let image: Data
      let text: String
      let correctAnswer: Bool
    
    init(image: Data, text: String, correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
}

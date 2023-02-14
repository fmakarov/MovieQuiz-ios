//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by paul kellerman on 17.12.2022.
//

import UIKit

final class QuizStepViewModel {
    // для состояния "Вопрос задан"
      let image: UIImage
      let question: String
      let questionNumber: String
    
    init(image: UIImage, question: String, questionNumber: String) {
        self.image = image
        self.question = question
        self.questionNumber = questionNumber
    }
}



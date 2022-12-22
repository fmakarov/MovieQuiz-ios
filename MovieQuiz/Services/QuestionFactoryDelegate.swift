//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by paul kellerman on 19.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}

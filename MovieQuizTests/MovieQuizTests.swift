//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by paul kellerman on 15.02.2023.
//

import XCTest
@testable import MovieQuiz


final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        let mockViewController = MovieQuizViewController()
        let sut = MovieQuizPresenter(viewController: mockViewController)

        let emtyData = Data()
        let question = QuizQuestion(image: emtyData, text: "Question Text", correctAnswer: true)

        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1 / 10")
    }
    
}

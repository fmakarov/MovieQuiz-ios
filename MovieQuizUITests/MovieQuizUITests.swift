//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by paul kellerman on 15.02.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app  = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let lableIndex = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(lableIndex.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() {
        let firstPoster = app.images["Poster"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertFalse(indexLabel.label == "1/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testAlert() {
        let indexLabel = app.staticTexts["Index"]
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
            print(indexLabel.label)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        let indexLabel = app.staticTexts["Index"]
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
            print(indexLabel.label)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }

}

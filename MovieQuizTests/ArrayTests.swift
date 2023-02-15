//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by paul kellerman on 15.02.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 2, 3, 4, 5]
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutRange() throws {
        //Give
        let array = [1, 2, 3, 4, 5]
        //When
        let value = array[safe: 6]
        
        //Then
        XCTAssertNil(value)
    }
}

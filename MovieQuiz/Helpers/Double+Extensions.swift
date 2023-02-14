//
//  Double+Extensions.swift
//  MovieQuiz
//
//  Created by paul kellerman on 12.02.2023.
//

import Foundation

extension Double {
    func rounding(before count: Int) -> Double {
        let div = pow(10.0, Double(count))
        return (self * div).rounded() / div
    }
}

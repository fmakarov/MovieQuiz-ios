//
//  StaticService.swift
//  MovieQuiz
//
//  Created by paul kellerman on 12.02.2023.
//

import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.double(forKey: Keys.correct.rawValue)
            let total = userDefaults.double(forKey: Keys.correct.rawValue)
            let result = (correct / total) * 100
            
            return result.rounding(before: 2)
        }
    }
    
    
    func store(correct count: Int, total amount: Int) {
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if self.bestGame < gameRecord {
            self.bestGame = gameRecord
        }
        
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        
        userDefaults.set(correct + count, forKey: Keys.correct.rawValue)
        userDefaults.set(total + amount, forKey: Keys.total.rawValue)
    }
    
    
} 

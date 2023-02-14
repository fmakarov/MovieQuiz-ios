//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by paul kellerman on 17.12.2022.
//
import UIKit

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}
struct Movie: Codable {
    let id: String
    let title: String
    let year: String
    let image: String
    let releaseDate: String
    let runtimeMins: String
    let directors: String
    let actorList: [Actor]
}

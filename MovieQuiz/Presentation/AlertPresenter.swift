//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by paul kellerman on 22.12.2022.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(result: AlertModel) {
        let alertController = UIAlertController.init(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { _ in
            result.completion()
        })
        
        alertController.addAction(action)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}

import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private var presenter: MovieQuizPresenter!
    private var alert: AlertPresenterProtocol?
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    private enum ParseError: Error {
        case yearFailure
        case runtimeMinsFailure
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }

    // проверка состояния кнопок
    @IBOutlet private weak var noBtnState: UIButton!
    @IBOutlet private weak var yesBtnState: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        alert = AlertPresenter(viewController: self)
            
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
}

extension MovieQuizViewController {
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    // Функция отображения
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let action = AlertModel(title: Constants.AlertLabel.title, message: message, buttonText: Constants.AlertButton.buttonText) {
            self.presenter.restartGame()
        }
        
        alert?.showAlert(result: action)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        presenter.correctAnswers = 0
        
        let action = AlertModel(title: "Попробовать ещё раз", message: message, buttonText: Constants.AlertButton.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alert?.showAlert(result: action)
    }
}

import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesBtnState: UIButton!
    @IBOutlet private var noBtnState: UIButton!

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
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alert = AlertPresenter(viewController: self)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let action = AlertModel(title: Constants.AlertLabel.title, message: message, buttonText: Constants.AlertButton.buttonText) {
            self.presenter.restartGame()
        }
        
        alert?.showAlert(result: action)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let action = AlertModel(title: "Попробовать ещё раз", message: message, buttonText: Constants.AlertButton.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alert?.showAlert(result: action)
    }
}

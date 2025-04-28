//
//  LoginViewController.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//
//
//  LoginViewController.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        emailTextField.placeholder = "Example@gmail.com"
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailContainerView.layer.borderColor = UIColor.gray.cgColor
        emailContainerView.layer.borderWidth = 1.0
        emailContainerView.layer.cornerRadius = 10.0
        
        passwordTextField.placeholder = "Example1234"
        passwordTextField.isSecureTextEntry = true
        passwordContainerView.layer.borderColor = UIColor.gray.cgColor
        passwordContainerView.layer.borderWidth = 1.0
        passwordContainerView.layer.cornerRadius = 10.0
        
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 8

        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func bindViewModel() {
        viewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                //Move to new page
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
            }
            .store(in: &cancellables)
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Please enter email and password"
            return
        }
        
        viewModel.loginWithCredentials(email: email, password: password)
    }
    
    @objc private func registerTapped() {
        //Move to register page
    }
}

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
    @IBOutlet weak var passwordEyeImageView: UIImageView!
    
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var isPasswordVisible = false

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        passwordEyeImageView.isUserInteractionEnabled = true
        let passwordEyeTap = UITapGestureRecognizer(target: self, action: #selector(passwordEyeTapped))
        passwordEyeImageView.addGestureRecognizer(passwordEyeTap)
        passwordEyeImageView.image = UIImage(systemName: "eye.slash")
        
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func bindViewModel() {
        viewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.navigateToHome()
                }
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
            }
            .store(in: &cancellables)
    }
    
    private func navigateToHome() {
        let homeViewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        let nav = UINavigationController(rootViewController: homeVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Please enter email and password"
            return
        }
        
        viewModel.loginWithCredentials(email: email, password: password)
    }
    
    @objc private func passwordEyeTapped() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        passwordEyeImageView.image = UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash")
    }
    
    @objc private func registerTapped() {
        let authService = Auth0Service()
        let registerVM = RegisterViewModel(authService: authService)
        let registerVC = RegisterViewController(viewModel: registerVM)
        
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

//
//  RegisterViewController.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameContainerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordEyeImageView: UIImageView!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordContainerView: UIView!
    @IBOutlet weak var confirmPasswordEyeImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    private var viewModel = RegisterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var isPasswordVisible = false
    private var isConfirmPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 20.0
        
        passwordTextField.placeholder = "Example1234"
        passwordContainerView.layer.borderColor = UIColor.gray.cgColor
        passwordContainerView.layer.borderWidth = 1.0
        passwordContainerView.layer.cornerRadius = 10.0
        
        confirmPasswordTextField.placeholder = "Example1234"
        confirmPasswordContainerView.layer.borderColor = UIColor.gray.cgColor
        confirmPasswordContainerView.layer.borderWidth = 1.0
        confirmPasswordContainerView.layer.cornerRadius = 10.0
        
        nameTextField.placeholder = "Example"
        nameContainerView.layer.borderColor = UIColor.gray.cgColor
        nameContainerView.layer.borderWidth = 1.0
        nameContainerView.layer.cornerRadius = 10.0
        
        emailTextField.placeholder = "Example@gmail.com"
        emailContainerView.layer.borderColor = UIColor.gray.cgColor
        emailContainerView.layer.borderWidth = 1.0
        emailContainerView.layer.cornerRadius = 10.0
        
        passwordEyeImageView.isUserInteractionEnabled = true
        let passwordEyeTap = UITapGestureRecognizer(target: self, action: #selector(passwordEyeTapped))
        passwordEyeImageView.addGestureRecognizer(passwordEyeTap)
        passwordTextField.isSecureTextEntry = true
        passwordEyeImageView.image = UIImage(systemName: "eye.slash")
        
        confirmPasswordEyeImageView.isUserInteractionEnabled = true
        let confirmEyeTap = UITapGestureRecognizer(target: self, action: #selector(confirmPasswordEyeTapped))
        confirmPasswordEyeImageView.addGestureRecognizer(confirmEyeTap)
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordEyeImageView.image = UIImage(systemName: "eye.slash")
        
        backImageView.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backImageView.addGestureRecognizer(backTap)
        
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.$errorMessage
            .sink { [weak self] error in
                self?.errorLabel.text = error
            }
            .store(in: &cancellables)
        
        viewModel.$isRegistrationSuccess
            .sink { [weak self] success in
                if success {
                    self?.showRegistrationSuccessAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showRegistrationSuccessAlert() {
        let alert = UIAlertController(title: "Registration Successful",
                                      message: "Your account has been created. Please login.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    @objc private func passwordEyeTapped() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        passwordEyeImageView.image = UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash")
    }

    @objc private func confirmPasswordEyeTapped() {
        isConfirmPasswordVisible.toggle()
        confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordVisible
        confirmPasswordEyeImageView.image = UIImage(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerTapped() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        viewModel.register(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
    
    private func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }

}

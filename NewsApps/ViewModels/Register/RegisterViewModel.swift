//
//  RegisterViewModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

class RegisterViewModel {
    @Published var errorMessage: String?
    @Published var isRegistrationSuccess: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: Auth0Service
    
    init(authService: Auth0Service = Auth0Service()) {
        self.authService = authService
    }
    
    func register(name: String, email: String, password: String, confirmPassword: String) {
        guard validateInputs(name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword) else { return }
        
        authService.register(name: name, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.isRegistrationSuccess = true
            }
            .store(in: &cancellables)
    }
    
    private func validateInputs(name: String,
                               email: String,
                               password: String,
                               confirmPassword: String) -> Bool {
        guard !name.isEmpty else {
            errorMessage = "Name cannot be empty"
            return false
        }
        
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return false
        }
        
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            return false
        }
        
        return true
    }
}

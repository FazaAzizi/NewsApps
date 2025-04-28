//
//  LoginViewModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var isAuthenticated: Bool = false
    @Published var userName: String = ""
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: Auth0Service

    init(authService: Auth0Service) {
        self.authService = authService
    }
    
    func loginWithCredentials(email: String, password: String) {
        authService.loginWithCredentials(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { user in
                self.isAuthenticated = true
                self.userName = user.name
                self.errorMessage = nil
            }
            .store(in: &cancellables)
    }
}

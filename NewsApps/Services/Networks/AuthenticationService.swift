//
//  AuthenticationService.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

protocol AuthenticationService {
    func login() -> AnyPublisher<User, Error>
    func loginWithCredentials(email: String, password: String) -> AnyPublisher<User, Error>
    func logout() -> AnyPublisher<Void, Error>
    func register(name: String, email: String, password: String) -> AnyPublisher<Void, Error>
    func checkSession() -> AnyPublisher<User?, Error>
    func getCredentials() -> AnyPublisher<Credentials, Error>
}


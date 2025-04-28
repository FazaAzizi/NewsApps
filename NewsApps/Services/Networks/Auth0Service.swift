//
//  Auth0Service.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Auth0
import Combine
import JWTDecode

class Auth0Service: AuthenticationService {
    
    func login() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth0
                .webAuth()
                .start { result in
                    switch result {
                    case .success(let credentials):
                        do {
                            let user = try self.extractUser(from: credentials.idToken)
                            self.saveLoginTime()
                            promise(.success(user))
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Auth0
                .webAuth()
                .clearSession { result in
                    switch result {
                    case .success:
                        UserDefaults.standard.removeObject(forKey: "loginTimestamp")
                        promise(.success(()))
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func loginWithCredentials(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth0
                .authentication()
                .login(
                    usernameOrEmail: email,
                    password: password,
                    realmOrConnection: "Username-Password-Authentication",
                    scope: "openid profile email"
                )
                .start { result in
                    switch result {
                    case .success(let credentials):
                        do {
                            let user = try self.extractUser(from: credentials.idToken)
                            self.saveLoginTime()
                            self.saveUser(user)
                            promise(.success(user))
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func checkSession() -> AnyPublisher<User?, Error> {
        return Future<User?, Error> { promise in
            if let loginTime = UserDefaults.standard.object(forKey: "loginTimestamp") as? Date {
                let timeElapsed = Date().timeIntervalSince(loginTime)
                if timeElapsed >= 600 {
                    self.logout()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { promise(.success(nil)) })
                        .store(in: &self.cancellables)
                    self.sendLogoutNotification()
                } else {
                    self.getCredentials()
                        .map { credentials -> User? in
                            try? self.extractUser(from: credentials.idToken)
                        }
                        .sink(receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                promise(.failure(error))
                            }
                        }, receiveValue: { user in
                            promise(.success(user))
                        })
                        .store(in: &self.cancellables)
                }
            } else {
                promise(.success(nil))
            }
        }.eraseToAnyPublisher()
    }
    
    func getCredentials() -> AnyPublisher<Credentials, Error> {
        return Fail(error: NSError(domain: "Not implemented", code: -1, userInfo: nil))
            .eraseToAnyPublisher()
    }
    
    private func extractUser(from idToken: String) throws -> User {
        let jwt = try decode(jwt: idToken)
        
        guard let id = jwt.subject,
              let name = jwt.claim(name: "name").string,
              let email = jwt.claim(name: "email").string else {
            throw NSError(domain: "Failed to extract user info", code: -1, userInfo: nil)
        }
        
        let pictureString = jwt.claim(name: "picture").string
        let pictureURL = pictureString != nil ? URL(string: pictureString!) : nil
        
        return User(id: id, name: name, email: email, picture: pictureURL)
    }
    
    private func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }
    
    func loadUser() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser") {
            let decoder = JSONDecoder()
            return try? decoder.decode(User.self, from: savedUserData)
        }
        return nil
    }
    
    private func saveLoginTime() {
        UserDefaults.standard.set(Date(), forKey: "loginTimestamp")
    }
    
    private func sendLogoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Session Expired"
        content.body = "Your account has been logged out due to inactivity"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "logoutNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    private var cancellables = Set<AnyCancellable>()
}

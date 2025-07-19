//
//  LoginViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        bindViewModel()
    }

    private func setupViews() {
        [emailField, passwordField, loginButton, statusLabel, spinner].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        loginButton.setTitle("Login", for: .normal)
        statusLabel.textColor = .systemRed
        spinner.hidesWhenStopped = true

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            spinner.leadingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 8),

            statusLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onLoading = { [weak self] loading in
            loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            self?.loginButton.isEnabled = !loading
        }

        viewModel.onLoginSuccess = { [weak self] in
            self?.statusLabel.textColor = .systemGreen
            self?.statusLabel.text = "Login Successful! 🎉"
        }

        viewModel.onError = { [weak self] message in
            self?.statusLabel.textColor = .systemRed
            self?.statusLabel.text = message
        }
    }

    @objc private func loginTapped() {
        statusLabel.text = ""
        viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
    }
}


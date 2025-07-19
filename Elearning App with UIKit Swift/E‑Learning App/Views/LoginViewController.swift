//
//  LoginViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let demoCredentialsView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.6).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Setup logo and title
        setupLogoAndTitle()
        
        // Setup form fields
        setupFormFields()
        
        // Setup buttons
        setupButtons()
        
        // Setup demo credentials
        setupDemoCredentials()
        
        // Setup constraints
        setupConstraints()
        
        // Update gradient frame
        DispatchQueue.main.async {
            gradientLayer.frame = self.view.bounds
        }
    }
    
    private func setupLogoAndTitle() {
        // Logo
        logoImageView.image = UIImage(systemName: "book.circle.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
        
        // Title
        titleLabel.text = "E-Learning App"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Learn at your own pace"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupFormFields() {
        // Email field
        emailField.placeholder = "Enter your email"
        emailField.borderStyle = .none
        emailField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        emailField.layer.cornerRadius = 12
        emailField.layer.shadowColor = UIColor.black.cgColor
        emailField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailField.layer.shadowOpacity = 0.1
        emailField.layer.shadowRadius = 4
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailField)
        
        // Password field
        passwordField.placeholder = "Enter your password"
        passwordField.borderStyle = .none
        passwordField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        passwordField.layer.cornerRadius = 12
        passwordField.layer.shadowColor = UIColor.black.cgColor
        passwordField.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordField.layer.shadowOpacity = 0.1
        passwordField.layer.shadowRadius = 4
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordField)
        
        // Add padding to text fields
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        emailField.leftView = emailPaddingView
        emailField.leftViewMode = .always
        passwordField.leftView = passwordPaddingView
        passwordField.leftViewMode = .always
    }
    
    private func setupButtons() {
        // Login button
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)
        
        // Forgot password button
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgotPasswordButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(forgotPasswordButton)
        
        // Sign up button
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        signUpButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signUpButton)
        
        // Status label
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)
        
        // Spinner
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
    }
    
    private func setupDemoCredentials() {
        demoCredentialsView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        demoCredentialsView.layer.cornerRadius = 12
        demoCredentialsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(demoCredentialsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Demo Credentials"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        demoCredentialsView.addSubview(titleLabel)
        
        let emailLabel = UILabel()
        emailLabel.text = "Email: student@example.com"
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        demoCredentialsView.addSubview(emailLabel)
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Password: learning123"
        passwordLabel.font = UIFont.systemFont(ofSize: 12)
        passwordLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        passwordLabel.textAlignment = .center
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        demoCredentialsView.addSubview(passwordLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: demoCredentialsView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: demoCredentialsView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: demoCredentialsView.trailingAnchor, constant: -12),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: demoCredentialsView.leadingAnchor, constant: 12),
            emailLabel.trailingAnchor.constraint(equalTo: demoCredentialsView.trailingAnchor, constant: -12),
            
            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            passwordLabel.leadingAnchor.constraint(equalTo: demoCredentialsView.leadingAnchor, constant: 12),
            passwordLabel.trailingAnchor.constraint(equalTo: demoCredentialsView.trailingAnchor, constant: -12),
            passwordLabel.bottomAnchor.constraint(equalTo: demoCredentialsView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Email field
            emailField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Login button
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Forgot password button
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Sign up button
            signUpButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Demo credentials
            demoCredentialsView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            demoCredentialsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            demoCredentialsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            demoCredentialsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func bindViewModel() {
        viewModel.onLoading = { [weak self] loading in
            loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            self?.loginButton.isEnabled = !loading
            self?.loginButton.backgroundColor = loading ? .systemGray : .white
        }

        viewModel.onLoginSuccess = { [weak self] in
            self?.statusLabel.textColor = .systemGreen
            self?.statusLabel.text = "Login Successful! 🎉"
            
            // Navigate to main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let mainVC = MainTabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                self?.present(mainVC, animated: true)
            }
        }

        viewModel.onError = { [weak self] message in
            self?.statusLabel.textColor = .systemRed
            self?.statusLabel.text = message
        }
        
        // Auto-fill email if available
        if !viewModel.email.isEmpty {
            emailField.text = viewModel.email
        }
    }

    @objc private func loginTapped() {
        statusLabel.text = ""
        viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
    }
    
    @objc private func forgotPasswordTapped() {
        let forgotPasswordVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @objc private func signUpTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}


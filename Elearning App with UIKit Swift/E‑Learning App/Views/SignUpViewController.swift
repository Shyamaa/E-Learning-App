//
//  SignUpViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class SignUpViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Components
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let firstNameField = UITextField()
    private let lastNameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    private let signUpButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        // Setup constraints
        setupConstraints()
        
        // Update gradient frame
        DispatchQueue.main.async {
            gradientLayer.frame = self.view.bounds
        }
    }
    
    private func setupLogoAndTitle() {
        // Logo
        logoImageView.image = UIImage(systemName: "person.badge.plus")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
        
        // Title
        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Join our learning community"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupFormFields() {
        // First Name field
        firstNameField.placeholder = "First Name"
        firstNameField.borderStyle = .none
        firstNameField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.shadowColor = UIColor.black.cgColor
        firstNameField.layer.shadowOffset = CGSize(width: 0, height: 2)
        firstNameField.layer.shadowOpacity = 0.1
        firstNameField.layer.shadowRadius = 4
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstNameField)
        
        // Last Name field
        lastNameField.placeholder = "Last Name"
        lastNameField.borderStyle = .none
        lastNameField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.shadowColor = UIColor.black.cgColor
        lastNameField.layer.shadowOffset = CGSize(width: 0, height: 2)
        lastNameField.layer.shadowOpacity = 0.1
        lastNameField.layer.shadowRadius = 4
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lastNameField)
        
        // Email field
        emailField.placeholder = "Email Address"
        emailField.borderStyle = .none
        emailField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        emailField.layer.cornerRadius = 12
        emailField.layer.shadowColor = UIColor.black.cgColor
        emailField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailField.layer.shadowOpacity = 0.1
        emailField.layer.shadowRadius = 4
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailField)
        
        // Password field
        passwordField.placeholder = "Password"
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
        
        // Confirm Password field
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.borderStyle = .none
        confirmPasswordField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        confirmPasswordField.layer.cornerRadius = 12
        confirmPasswordField.layer.shadowColor = UIColor.black.cgColor
        confirmPasswordField.layer.shadowOffset = CGSize(width: 0, height: 2)
        confirmPasswordField.layer.shadowOpacity = 0.1
        confirmPasswordField.layer.shadowRadius = 4
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPasswordField)
        
        // Add padding to text fields
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        firstNameField.leftView = paddingView
        firstNameField.leftViewMode = .always
        lastNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        lastNameField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        emailField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        passwordField.leftViewMode = .always
        confirmPasswordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        confirmPasswordField.leftViewMode = .always
    }
    
    private func setupButtons() {
        // Sign Up button
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        signUpButton.backgroundColor = .white
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.layer.cornerRadius = 12
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signUpButton)
        
        // Login button
        loginButton.setTitle("Already have an account? Sign In", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)
        
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
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
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
            
            // First Name field
            firstNameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            firstNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            firstNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            firstNameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Last Name field
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 16),
            lastNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            lastNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            lastNameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email field
            emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm Password field
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            confirmPasswordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            confirmPasswordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign Up button
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 24),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Login button
            loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    @objc private func signUpTapped() {
        statusLabel.text = ""
        
        // Validate fields
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            showError("Please enter your first name")
            return
        }
        
        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            showError("Please enter your last name")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            showError("Please enter your email")
            return
        }
        
        guard isValidEmail(email) else {
            showError("Please enter a valid email address")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showError("Please enter a password")
            return
        }
        
        guard password.count >= 6 else {
            showError("Password must be at least 6 characters")
            return
        }
        
        guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            showError("Please confirm your password")
            return
        }
        
        guard password == confirmPassword else {
            showError("Passwords do not match")
            return
        }
        
        // Show loading
        spinner.startAnimating()
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = .systemGray
        
        // Simulate sign up process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.spinner.stopAnimating()
            self.signUpButton.isEnabled = true
            self.signUpButton.backgroundColor = .white
            
            // Create user and save
            let user = User(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                profileImageURL: nil,
                joinDate: Date(),
                lastLoginDate: Date(),
                preferences: User.UserPreferences(
                    notificationsEnabled: true,
                    darkModeEnabled: false,
                    autoPlayVideos: true,
                    downloadOverWifiOnly: true,
                    language: "en"
                ),
                progress: User.UserProgress(
                    completedCourses: 0,
                    totalCourses: 0,
                    totalStudyTime: 0,
                    currentStreak: 0,
                    achievements: []
                )
            )
            
            // Save user data
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            // Show success and navigate
            self.showSuccess("Account created successfully! 🎉")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let mainVC = MainTabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true)
            }
        }
    }
    
    @objc private func loginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showError(_ message: String) {
        statusLabel.textColor = .systemRed
        statusLabel.text = message
    }
    
    private func showSuccess(_ message: String) {
        statusLabel.textColor = .systemGreen
        statusLabel.text = message
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
} 
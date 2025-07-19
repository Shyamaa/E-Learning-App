//
//  ForgotPasswordViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Components
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailField = UITextField()
    private let resetButton = UIButton(type: .system)
    private let backToLoginButton = UIButton(type: .system)
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
        logoImageView.image = UIImage(systemName: "lock.rotation")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
        
        // Title
        titleLabel.text = "Reset Password"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Enter your email to receive reset instructions"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupFormFields() {
        // Email field
        emailField.placeholder = "Enter your email address"
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
        
        // Add padding to text field
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        emailField.leftView = emailPaddingView
        emailField.leftViewMode = .always
    }
    
    private func setupButtons() {
        // Reset button
        resetButton.setTitle("Send Reset Link", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resetButton.backgroundColor = .white
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.layer.cornerRadius = 12
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resetButton)
        
        // Back to login button
        backToLoginButton.setTitle("Back to Sign In", for: .normal)
        backToLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backToLoginButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        backToLoginButton.addTarget(self, action: #selector(backToLoginTapped), for: .touchUpInside)
        backToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backToLoginButton)
        
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
            
            // Reset button
            resetButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Back to login button
            backToLoginButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 16),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: backToLoginButton.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    @objc private func resetTapped() {
        statusLabel.text = ""
        
        guard let email = emailField.text, !email.isEmpty else {
            showError("Please enter your email address")
            return
        }
        
        guard isValidEmail(email) else {
            showError("Please enter a valid email address")
            return
        }
        
        // Show loading
        spinner.startAnimating()
        resetButton.isEnabled = false
        resetButton.backgroundColor = .systemGray
        
        // Simulate password reset process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.spinner.stopAnimating()
            self.resetButton.isEnabled = true
            self.resetButton.backgroundColor = .white
            
            // Check if email exists (mock validation)
            if email == "student@example.com" {
                self.showSuccess("Password reset link sent to \(email) 📧")
                
                // Clear the email field
                self.emailField.text = ""
                
                // Show additional instructions
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showInstructions()
                }
            } else {
                self.showError("Email not found. Please check your email address or create a new account.")
            }
        }
    }
    
    @objc private func backToLoginTapped() {
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
    
    private func showInstructions() {
        let alert = UIAlertController(
            title: "Check Your Email",
            message: "We've sent you a password reset link. Please check your email and follow the instructions to reset your password.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
} 
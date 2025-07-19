//
//  EditProfileViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Components
    private let profileImageView = UIImageView()
    private let changePhotoButton = UIButton(type: .system)
    private let firstNameField = UITextField()
    private let lastNameField = UITextField()
    private let emailField = UITextField()
    private let bioTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    // Mock user data
    private var user = User(
        email: "student@example.com",
        password: "learning123",
        firstName: "John",
        lastName: "Doe",
        profileImageURL: nil,
        joinDate: Date().addingTimeInterval(-86400 * 30),
        lastLoginDate: Date(),
        preferences: User.UserPreferences(
            notificationsEnabled: true,
            darkModeEnabled: false,
            autoPlayVideos: true,
            downloadOverWifiOnly: true,
            language: "en"
        ),
        progress: User.UserProgress(
            completedCourses: 2,
            totalCourses: 5,
            totalStudyTime: 180,
            currentStreak: 7,
            achievements: []
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup profile image
        setupProfileImage()
        
        // Setup form fields
        setupFormFields()
        
        // Setup buttons
        setupButtons()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupProfileImage() {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemBlue
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.systemGray6
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        changePhotoButton.setTitleColor(.systemBlue, for: .normal)
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(changePhotoButton)
    }
    
    private func setupFormFields() {
        // First Name Field
        firstNameField.placeholder = "First Name"
        firstNameField.borderStyle = .none
        firstNameField.backgroundColor = UIColor.systemBackground
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = UIColor.systemGray4.cgColor
        firstNameField.font = UIFont.systemFont(ofSize: 16)
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstNameField)
        
        // Add padding to text field
        let firstNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        firstNameField.leftView = firstNamePaddingView
        firstNameField.leftViewMode = .always
        
        // Last Name Field
        lastNameField.placeholder = "Last Name"
        lastNameField.borderStyle = .none
        lastNameField.backgroundColor = UIColor.systemBackground
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = UIColor.systemGray4.cgColor
        lastNameField.font = UIFont.systemFont(ofSize: 16)
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lastNameField)
        
        // Add padding to text field
        let lastNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        lastNameField.leftView = lastNamePaddingView
        lastNameField.leftViewMode = .always
        
        // Email Field
        emailField.placeholder = "Email"
        emailField.borderStyle = .none
        emailField.backgroundColor = UIColor.systemBackground
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.systemGray4.cgColor
        emailField.font = UIFont.systemFont(ofSize: 16)
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailField)
        
        // Add padding to text field
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        emailField.leftView = emailPaddingView
        emailField.leftViewMode = .always
        
        // Bio TextView
        bioTextView.placeholder = "Tell us about yourself..."
        bioTextView.backgroundColor = UIColor.systemBackground
        bioTextView.layer.cornerRadius = 12
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bioTextView.font = UIFont.systemFont(ofSize: 16)
        bioTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bioTextView)
    }
    
    private func setupButtons() {
        // Save Button
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)
        
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = UIColor.systemGray6
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)
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
            
            // Profile image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Change photo button
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            changePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // First name field
            firstNameField.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 24),
            firstNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            firstNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            firstNameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Last name field
            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 16),
            lastNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lastNameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email field
            emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Bio text view
            bioTextView.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            bioTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bioTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Cancel button
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func populateFields() {
        firstNameField.text = user.firstName
        lastNameField.text = user.lastName
        emailField.text = user.email
        bioTextView.text = "Passionate learner interested in iOS development and design."
    }
    
    @objc private func changePhotoTapped() {
        let alert = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            // Camera functionality would be implemented here
        })
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            // Photo library functionality would be implemented here
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func saveTapped() {
        // Validate fields
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your first name")
            return
        }
        
        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your last name")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email")
            return
        }
        
        // Update user data
        user = User(
            email: email,
            password: user.password,
            firstName: firstName,
            lastName: lastName,
            profileImageURL: user.profileImageURL,
            joinDate: user.joinDate,
            lastLoginDate: Date(),
            preferences: user.preferences,
            progress: user.progress
        )
        
        // Save to UserDefaults
        UserDefaults.standard.set(email, forKey: "userEmail")
        
        showAlert(title: "Success", message: "Profile updated successfully!") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// Extension to add placeholder to UITextView
extension UITextView {
    var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                let label = UILabel()
                label.textColor = UIColor.systemGray3
                label.font = UIFont.systemFont(ofSize: 16)
                label.numberOfLines = 0
                addSubview(label)
                placeholderLabel = label
            }
            placeholderLabel?.text = newValue
        }
    }
    
    private var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private struct AssociatedKeys {
    static var placeholderLabel = "placeholderLabel"
} 

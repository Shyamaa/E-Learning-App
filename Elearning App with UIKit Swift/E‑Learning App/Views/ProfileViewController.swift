//
//  ProfileViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class ProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Components
    private let profileHeaderView = UIView()
    private let statsView = UIView()
    private let achievementsView = UIView()
    private let settingsView = UIView()
    
    // Mock user data
    private let user = User(
        email: "student@example.com",
        password: "learning123",
        firstName: "John",
        lastName: "Doe",
        profileImageURL: nil,
        joinDate: Date().addingTimeInterval(-86400 * 30), // 30 days ago
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
            achievements: [
                User.Achievement(
                    title: "First Course",
                    description: "Completed your first course",
                    icon: "star.fill",
                    dateEarned: Date().addingTimeInterval(-86400 * 7),
                    type: .firstCourse
                ),
                User.Achievement(
                    title: "Week Streak",
                    description: "Studied for 7 days in a row",
                    icon: "flame.fill",
                    dateEarned: Date(),
                    type: .weekStreak
                )
            ]
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup sections
        setupProfileHeader()
        setupStats()
        setupAchievements()
        setupSettings()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupProfileHeader() {
        profileHeaderView.backgroundColor = UIColor.systemBackground
        profileHeaderView.layer.cornerRadius = 16
        profileHeaderView.layer.shadowColor = UIColor.black.cgColor
        profileHeaderView.layer.shadowOffset = CGSize(width: 0, height: 4)
        profileHeaderView.layer.shadowOpacity = 0.1
        profileHeaderView.layer.shadowRadius = 8
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileHeaderView)
        
        // Profile image
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemBlue
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.addSubview(profileImageView)
        
        // Name label
        let nameLabel = UILabel()
        nameLabel.text = user.fullName
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.addSubview(nameLabel)
        
        // Email label
        let emailLabel = UILabel()
        emailLabel.text = user.email
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = .secondaryLabel
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.addSubview(emailLabel)
        
        // Member since label
        let memberSinceLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        memberSinceLabel.text = "Member since \(formatter.string(from: user.joinDate))"
        memberSinceLabel.font = UIFont.systemFont(ofSize: 14)
        memberSinceLabel.textColor = .secondaryLabel
        memberSinceLabel.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.addSubview(memberSinceLabel)
        
        // Edit button
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        editButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.layer.cornerRadius = 8
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            memberSinceLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            memberSinceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            memberSinceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            editButton.topAnchor.constraint(equalTo: memberSinceLabel.bottomAnchor, constant: 12),
            editButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            editButton.heightAnchor.constraint(equalToConstant: 32),
            editButton.bottomAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupStats() {
        statsView.backgroundColor = UIColor.systemBackground
        statsView.layer.cornerRadius = 16
        statsView.layer.shadowColor = UIColor.black.cgColor
        statsView.layer.shadowOffset = CGSize(width: 0, height: 4)
        statsView.layer.shadowOpacity = 0.1
        statsView.layer.shadowRadius = 8
        statsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Learning Stats"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(titleLabel)
        
        let statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 16
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(statsStackView)
        
        // Completed courses
        let completedView = createStatCard(
            title: "Completed",
            value: "\(user.progress.completedCourses)",
            subtitle: "courses",
            icon: "checkmark.circle.fill",
            color: .systemGreen
        )
        statsStackView.addArrangedSubview(completedView)
        
        // Total study time
        let studyTimeView = createStatCard(
            title: "Study Time",
            value: "\(user.progress.totalStudyTime)",
            subtitle: "minutes",
            icon: "clock.fill",
            color: .systemBlue
        )
        statsStackView.addArrangedSubview(studyTimeView)
        
        // Current streak
        let streakView = createStatCard(
            title: "Streak",
            value: "\(user.progress.currentStreak)",
            subtitle: "days",
            icon: "flame.fill",
            color: .systemOrange
        )
        statsStackView.addArrangedSubview(streakView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20),
            
            statsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statsStackView.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createStatCard(title: String, value: String, subtitle: String, icon: String, color: UIColor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = color.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = color
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(valueLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            valueLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            valueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    private func setupAchievements() {
        achievementsView.backgroundColor = UIColor.systemBackground
        achievementsView.layer.cornerRadius = 16
        achievementsView.layer.shadowColor = UIColor.black.cgColor
        achievementsView.layer.shadowOffset = CGSize(width: 0, height: 4)
        achievementsView.layer.shadowOpacity = 0.1
        achievementsView.layer.shadowRadius = 8
        achievementsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(achievementsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Achievements"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementsView.addSubview(titleLabel)
        
        let achievementsStackView = UIStackView()
        achievementsStackView.axis = .vertical
        achievementsStackView.spacing = 12
        achievementsStackView.translatesAutoresizingMaskIntoConstraints = false
        achievementsView.addSubview(achievementsStackView)
        
        for achievement in user.progress.achievements {
            let achievementView = createAchievementView(achievement: achievement)
            achievementsStackView.addArrangedSubview(achievementView)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: achievementsView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: achievementsView.leadingAnchor, constant: 20),
            
            achievementsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            achievementsStackView.leadingAnchor.constraint(equalTo: achievementsView.leadingAnchor, constant: 20),
            achievementsStackView.trailingAnchor.constraint(equalTo: achievementsView.trailingAnchor, constant: -20),
            achievementsStackView.bottomAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createAchievementView(achievement: User.Achievement) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 12
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: achievement.icon)
        iconImageView.tintColor = UIColor(named: achievement.type.color) ?? .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = achievement.title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = achievement.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: achievement.dateEarned)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    private func setupSettings() {
        settingsView.backgroundColor = UIColor.systemBackground
        settingsView.layer.cornerRadius = 16
        settingsView.layer.shadowColor = UIColor.black.cgColor
        settingsView.layer.shadowOffset = CGSize(width: 0, height: 4)
        settingsView.layer.shadowOpacity = 0.1
        settingsView.layer.shadowRadius = 8
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(settingsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsView.addSubview(titleLabel)
        
        let settingsStackView = UIStackView()
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 0
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.addSubview(settingsStackView)
        
        // Settings options
        let settingsOptions = [
            ("Notifications", "bell.fill", user.preferences.notificationsEnabled),
            ("Auto-play Videos", "play.fill", user.preferences.autoPlayVideos),
            ("Download over WiFi Only", "wifi", user.preferences.downloadOverWifiOnly)
        ]
        
        for (index, (title, icon, isEnabled)) in settingsOptions.enumerated() {
            let settingView = createSettingRow(title: title, icon: icon, isEnabled: isEnabled)
            settingsStackView.addArrangedSubview(settingView)
            
            if index < settingsOptions.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                settingsStackView.addArrangedSubview(separator)
            }
        }
        
        // Add theme settings row
        let themeSeparator = UIView()
        themeSeparator.backgroundColor = .separator
        themeSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        settingsStackView.addArrangedSubview(themeSeparator)
        
        let themeSettingView = createThemeSettingRow()
        settingsStackView.addArrangedSubview(themeSettingView)
        
        // Logout button
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        logoutButton.layer.cornerRadius = 12
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        settingsView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            settingsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            settingsStackView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            settingsStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -20),
            
            logoutButton.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createSettingRow(title: String, icon: String, isEnabled: Bool) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = isEnabled
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        return containerView
    }
    
    private func createThemeSettingRow() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "paintbrush.fill")
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "App Theme"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(chevronImageView)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(themeSettingsTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return containerView
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
            
            // Profile header
            profileHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Stats
            statsView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 16),
            statsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Achievements
            achievementsView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 16),
            achievementsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            achievementsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Settings
            settingsView.topAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: 16),
            settingsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            settingsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            settingsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func editProfileTapped() {
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func themeSettingsTapped() {
        let themeSettingsVC = ThemeSettingsViewController()
        navigationController?.pushViewController(themeSettingsVC, animated: true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            
            // Present login screen
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true) {
                // Reset tab bar controller
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0
                }
            }
        })
        present(alert, animated: true)
    }
} 
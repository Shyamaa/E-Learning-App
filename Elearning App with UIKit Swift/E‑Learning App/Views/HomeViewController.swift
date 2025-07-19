//
//  HomeViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = CourseListViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Components
    private let welcomeHeaderView = UIView()
    private let progressOverviewView = UIView()
    private let continueLearningView = UIView()
    private let featuredCoursesView = UIView()
    private let quickActionsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Home"
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
        setupWelcomeHeader()
        setupProgressOverview()
        setupContinueLearning()
        setupFeaturedCourses()
        setupQuickActions()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupWelcomeHeader() {
        welcomeHeaderView.backgroundColor = UIColor.systemBackground
        welcomeHeaderView.layer.cornerRadius = 16
        welcomeHeaderView.layer.shadowColor = UIColor.black.cgColor
        welcomeHeaderView.layer.shadowOffset = CGSize(width: 0, height: 4)
        welcomeHeaderView.layer.shadowOpacity = 0.1
        welcomeHeaderView.layer.shadowRadius = 8
        welcomeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(welcomeHeaderView)
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        welcomeHeaderView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Welcome text
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome back,"
        welcomeLabel.font = UIFont.systemFont(ofSize: 18)
        welcomeLabel.textColor = .secondaryLabel
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeaderView.addSubview(welcomeLabel)
        
        let nameLabel = UILabel()
        nameLabel.text = "John"
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeaderView.addSubview(nameLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Ready to continue your learning journey?"
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeaderView.addSubview(messageLabel)
        
        // Time display
        let timeLabel = UILabel()
        timeLabel.text = Date().formatted(date: .omitted, time: .shortened)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeaderView.addSubview(timeLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = Date().formatted(date: .abbreviated, time: .omitted)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeaderView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: welcomeHeaderView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: welcomeHeaderView.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: welcomeHeaderView.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            
            messageLabel.leadingAnchor.constraint(equalTo: welcomeHeaderView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: welcomeHeaderView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: welcomeHeaderView.bottomAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: welcomeHeaderView.topAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: welcomeHeaderView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: welcomeHeaderView.trailingAnchor, constant: -20)
        ])
        
        // Update gradient frame
        DispatchQueue.main.async {
            gradientLayer.frame = self.welcomeHeaderView.bounds
        }
    }
    
    private func setupProgressOverview() {
        progressOverviewView.backgroundColor = UIColor.systemBackground
        progressOverviewView.layer.cornerRadius = 16
        progressOverviewView.layer.shadowColor = UIColor.black.cgColor
        progressOverviewView.layer.shadowOffset = CGSize(width: 0, height: 4)
        progressOverviewView.layer.shadowOpacity = 0.1
        progressOverviewView.layer.shadowRadius = 8
        progressOverviewView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressOverviewView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Your Progress"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressOverviewView.addSubview(titleLabel)
        
        // Progress circle
        let progressCircle = UIView()
        progressCircle.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        progressCircle.layer.cornerRadius = 40
        progressCircle.translatesAutoresizingMaskIntoConstraints = false
        progressOverviewView.addSubview(progressCircle)
        
        let progressLabel = UILabel()
        progressLabel.text = "40%"
        progressLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        progressLabel.textColor = .systemBlue
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressCircle.addSubview(progressLabel)
        
        let completionLabel = UILabel()
        completionLabel.text = "Completion"
        completionLabel.font = UIFont.systemFont(ofSize: 12)
        completionLabel.textColor = .secondaryLabel
        completionLabel.textAlignment = .center
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        progressOverviewView.addSubview(completionLabel)
        
        // Stats
        let statsStackView = UIStackView()
        statsStackView.axis = .vertical
        statsStackView.spacing = 12
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        progressOverviewView.addSubview(statsStackView)
        
        // Streak
        let streakView = createStatView(title: "Current Streak", value: "7 days", icon: "flame.fill", color: .orange)
        statsStackView.addArrangedSubview(streakView)
        
        // Study time
        let studyTimeView = createStatView(title: "Total Study Time", value: "180 min", icon: "clock.fill", color: .green)
        statsStackView.addArrangedSubview(studyTimeView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: progressOverviewView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: progressOverviewView.leadingAnchor, constant: 20),
            
            progressCircle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            progressCircle.leadingAnchor.constraint(equalTo: progressOverviewView.leadingAnchor, constant: 20),
            progressCircle.widthAnchor.constraint(equalToConstant: 80),
            progressCircle.heightAnchor.constraint(equalToConstant: 80),
            
            progressLabel.centerXAnchor.constraint(equalTo: progressCircle.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressCircle.centerYAnchor),
            
            completionLabel.topAnchor.constraint(equalTo: progressCircle.bottomAnchor, constant: 8),
            completionLabel.centerXAnchor.constraint(equalTo: progressCircle.centerXAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statsStackView.leadingAnchor.constraint(equalTo: progressCircle.trailingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: progressOverviewView.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: progressOverviewView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createStatView(title: String, value: String, icon: String, color: UIColor) -> UIView {
        let containerView = UIView()
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = color
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(valueLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            valueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func setupContinueLearning() {
        continueLearningView.backgroundColor = UIColor.systemBackground
        continueLearningView.layer.cornerRadius = 16
        continueLearningView.layer.shadowColor = UIColor.black.cgColor
        continueLearningView.layer.shadowOffset = CGSize(width: 0, height: 4)
        continueLearningView.layer.shadowOpacity = 0.1
        continueLearningView.layer.shadowRadius = 8
        continueLearningView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(continueLearningView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Continue Learning"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        continueLearningView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "No courses in progress"
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        continueLearningView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: continueLearningView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: continueLearningView.leadingAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: continueLearningView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: continueLearningView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: continueLearningView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupFeaturedCourses() {
        featuredCoursesView.backgroundColor = UIColor.systemBackground
        featuredCoursesView.layer.cornerRadius = 16
        featuredCoursesView.layer.shadowColor = UIColor.black.cgColor
        featuredCoursesView.layer.shadowOffset = CGSize(width: 0, height: 4)
        featuredCoursesView.layer.shadowOpacity = 0.1
        featuredCoursesView.layer.shadowRadius = 8
        featuredCoursesView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(featuredCoursesView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Featured Courses"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredCoursesView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Loading featured courses..."
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredCoursesView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: featuredCoursesView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: featuredCoursesView.leadingAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: featuredCoursesView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: featuredCoursesView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: featuredCoursesView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupQuickActions() {
        quickActionsView.backgroundColor = UIColor.systemBackground
        quickActionsView.layer.cornerRadius = 16
        quickActionsView.layer.shadowColor = UIColor.black.cgColor
        quickActionsView.layer.shadowOffset = CGSize(width: 0, height: 4)
        quickActionsView.layer.shadowOpacity = 0.1
        quickActionsView.layer.shadowRadius = 8
        quickActionsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quickActionsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Quick Actions"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        quickActionsView.addSubview(titleLabel)
        
        let actionsStackView = UIStackView()
        actionsStackView.axis = .horizontal
        actionsStackView.distribution = .fillEqually
        actionsStackView.spacing = 12
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        quickActionsView.addSubview(actionsStackView)
        
        // Quick action buttons
        let browseButton = createQuickActionButton(title: "Browse Courses", icon: "book.fill", color: .systemBlue)
        let progressButton = createQuickActionButton(title: "My Progress", icon: "chart.bar.fill", color: .systemGreen)
        let achievementsButton = createQuickActionButton(title: "Achievements", icon: "star.fill", color: .systemOrange)
        let settingsButton = createQuickActionButton(title: "Settings", icon: "gear", color: .systemPurple)
        
        actionsStackView.addArrangedSubview(browseButton)
        actionsStackView.addArrangedSubview(progressButton)
        actionsStackView.addArrangedSubview(achievementsButton)
        actionsStackView.addArrangedSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: quickActionsView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor, constant: 20),
            
            actionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            actionsStackView.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor, constant: 20),
            actionsStackView.trailingAnchor.constraint(equalTo: quickActionsView.trailingAnchor, constant: -20),
            actionsStackView.bottomAnchor.constraint(equalTo: quickActionsView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createQuickActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBackground
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = color
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -12)
        ])
        
        return button
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
            
            // Welcome header
            welcomeHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            welcomeHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            welcomeHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Progress overview
            progressOverviewView.topAnchor.constraint(equalTo: welcomeHeaderView.bottomAnchor, constant: 16),
            progressOverviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressOverviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Continue learning
            continueLearningView.topAnchor.constraint(equalTo: progressOverviewView.bottomAnchor, constant: 16),
            continueLearningView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            continueLearningView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Featured courses
            featuredCoursesView.topAnchor.constraint(equalTo: continueLearningView.bottomAnchor, constant: 16),
            featuredCoursesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            featuredCoursesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Quick actions
            quickActionsView.topAnchor.constraint(equalTo: featuredCoursesView.bottomAnchor, constant: 16),
            quickActionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quickActionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quickActionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onCoursesLoaded = { [weak self] in
            DispatchQueue.main.async {
                // Update featured courses section
                if let featuredLabel = self?.featuredCoursesView.subviews.last as? UILabel {
                    if self?.viewModel.courses.isEmpty == false {
                        featuredLabel.text = "\(self?.viewModel.courses.count ?? 0) courses available"
                    } else {
                        featuredLabel.text = "No featured courses available"
                    }
                }
            }
        }
    }
} 
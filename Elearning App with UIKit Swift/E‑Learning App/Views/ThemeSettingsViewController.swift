//
//  ThemeSettingsViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class ThemeSettingsViewController: UIViewController {
    private let tableView = UITableView()
    private let themeManager = ThemeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "App Theme"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.themeSecondaryBackground
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Register cell
        tableView.register(ThemeTableViewCell.self, forCellReuseIdentifier: "ThemeCell")
        
        // Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ThemeSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return AppTheme.allCases.count
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeTableViewCell
        
        switch indexPath.section {
        case 0:
            let theme = AppTheme.allCases[indexPath.row]
            let isSelected = themeManager.currentTheme == theme
            cell.configure(with: theme, isSelected: isSelected)
        case 1:
            cell.configurePreview()
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Choose Theme"
        case 1: return "Preview"
        default: return nil
        }
    }
}

// MARK: - UITableViewDelegate
extension ThemeSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let selectedTheme = AppTheme.allCases[indexPath.row]
            themeManager.currentTheme = selectedTheme
            
            // Reload table to update selection
            tableView.reloadData()
            
            // Show success message
            showThemeChangedAlert(theme: selectedTheme)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 60
        case 1: return 200
        default: return 44
        }
    }
}

// MARK: - Helper Methods
extension ThemeSettingsViewController {
    private func showThemeChangedAlert(theme: AppTheme) {
        let alert = UIAlertController(
            title: "Theme Changed",
            message: "App theme changed to \(theme.rawValue) mode",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Theme Table View Cell
class ThemeTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private let previewView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = UIColor.themeBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Icon image view
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor.themeLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle label
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.themeSecondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Checkmark image view
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = UIColor.themePrimary
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(checkmarkImageView)
        
        // Preview view
        previewView.backgroundColor = UIColor.themeSecondaryBackground
        previewView.layer.cornerRadius = 12
        previewView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(previewView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Icon image view
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            // Subtitle label
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // Checkmark image view
            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Preview view
            previewView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            previewView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            previewView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            previewView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with theme: AppTheme, isSelected: Bool) {
        iconImageView.image = UIImage(systemName: theme.icon)
        iconImageView.tintColor = theme.color
        titleLabel.text = theme.rawValue
        subtitleLabel.text = getThemeDescription(theme)
        checkmarkImageView.isHidden = !isSelected
        
        // Hide preview view for theme cells
        previewView.isHidden = true
        
        // Show normal cell content
        titleLabel.isHidden = false
        subtitleLabel.isHidden = false
        iconImageView.isHidden = false
        checkmarkImageView.isHidden = !isSelected
    }
    
    func configurePreview() {
        // Hide normal cell content
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        iconImageView.isHidden = true
        checkmarkImageView.isHidden = true
        
        // Show preview view
        previewView.isHidden = false
        
        // Create preview content
        createPreviewContent()
    }
    
    private func createPreviewContent() {
        // Clear existing preview content
        previewView.subviews.forEach { $0.removeFromSuperview() }
        
        // Create sample UI elements for preview
        let sampleLabel = UILabel()
        sampleLabel.text = "Sample Content"
        sampleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        sampleLabel.textColor = UIColor.themeLabel
        sampleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewView.addSubview(sampleLabel)
        
        let sampleButton = UIButton(type: .system)
        sampleButton.setTitle("Sample Button", for: .normal)
        sampleButton.backgroundColor = UIColor.themePrimary
        sampleButton.setTitleColor(.white, for: .normal)
        sampleButton.layer.cornerRadius = 8
        sampleButton.translatesAutoresizingMaskIntoConstraints = false
        previewView.addSubview(sampleButton)
        
        let sampleCard = UIView()
        sampleCard.backgroundColor = UIColor.themeBackground
        sampleCard.layer.cornerRadius = 8
        sampleCard.translatesAutoresizingMaskIntoConstraints = false
        previewView.addSubview(sampleCard)
        
        NSLayoutConstraint.activate([
            sampleLabel.topAnchor.constraint(equalTo: previewView.topAnchor, constant: 16),
            sampleLabel.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: 16),
            
            sampleButton.topAnchor.constraint(equalTo: sampleLabel.bottomAnchor, constant: 12),
            sampleButton.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: 16),
            sampleButton.widthAnchor.constraint(equalToConstant: 120),
            sampleButton.heightAnchor.constraint(equalToConstant: 36),
            
            sampleCard.topAnchor.constraint(equalTo: sampleButton.bottomAnchor, constant: 12),
            sampleCard.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: 16),
            sampleCard.trailingAnchor.constraint(equalTo: previewView.trailingAnchor, constant: -16),
            sampleCard.heightAnchor.constraint(equalToConstant: 60),
            sampleCard.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -16)
        ])
    }
    
    private func getThemeDescription(_ theme: AppTheme) -> String {
        switch theme {
        case .light:
            return "Use light colors throughout the app"
        case .dark:
            return "Use dark colors throughout the app"
        case .system:
            return "Follow system appearance settings"
        }
    }
} 
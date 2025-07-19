//
//  CourseListViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class CourseListViewController: UIViewController {
    private let viewModel = CourseListViewModel()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "My Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Register cell
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "CourseCell")
        
        // Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onCoursesLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: error)
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.refreshCourses()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CourseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseTableViewCell
        let course = viewModel.courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CourseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = viewModel.courses[indexPath.row]
        let lessonListVC = LessonListViewController(course: course)
        navigationController?.pushViewController(lessonListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - Course Table View Cell
class CourseTableViewCell: UITableViewCell {
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lessonsLabel = UILabel()
    private let durationLabel = UILabel()
    private let statusLabel = UILabel()
    private let chevronImageView = UIImageView()
    
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
        
        // Card view
        cardView.backgroundColor = UIColor.systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        // Description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)
        
        // Lessons label
        lessonsLabel.font = UIFont.systemFont(ofSize: 12)
        lessonsLabel.textColor = .secondaryLabel
        lessonsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(lessonsLabel)
        
        // Duration label
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .secondaryLabel
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(durationLabel)
        
        // Status label
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(statusLabel)
        
        // Chevron image
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemBlue
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(chevronImageView)

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Card view
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            // Lessons label
            lessonsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            lessonsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Duration label
            durationLabel.topAnchor.constraint(equalTo: lessonsLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            durationLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            // Status label
            //statusLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            // Chevron image
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with course: Course) {
        titleLabel.text = course.title
        descriptionLabel.text = course.description
        lessonsLabel.text = "📚 \(course.lessons.count) lessons"
        durationLabel.text = "⏱️ ~\(course.estimatedDuration) min"
        
        if course.isCompleted {
            statusLabel.text = "✅ Completed"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "▶️ Ready to start"
            statusLabel.textColor = .systemBlue
        }
    }
}

// MARK: - Lesson List View Controller (Placeholder)
class LessonListViewController: UIViewController {
    private let course: Course
    
    init(course: Course) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        title = course.title
        
        let label = UILabel()
        label.text = "Lesson List for \(course.title)\n(UIKit Implementation)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
} 

//
//  SearchViewController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class SearchViewController: UIViewController {
    private let viewModel = CourseListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var filteredCourses: [Course] = []
    private var selectedCategory: Course.CourseCategory?
    private var selectedDifficulty: Course.CourseDifficulty?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupTableView()
        setupFilterCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Add views to hierarchy first
        view.addSubview(filterCollectionView)
        view.addSubview(tableView)
        
        // Setup constraints after adding to hierarchy
        setupConstraints()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search courses, instructors..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cell
        tableView.register(SearchCourseTableViewCell.self, forCellReuseIdentifier: "SearchCourseCell")
        
        // Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupFilterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        filterCollectionView.setCollectionViewLayout(layout, animated: false)
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cell
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        // Setup delegates
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.onCoursesLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.filterCourses()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Filter collection view
            filterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func filterCourses() {
        var courses = viewModel.courses
        
        // Filter by search text
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            courses = courses.filter { course in
                course.title.localizedCaseInsensitiveContains(searchText) ||
                course.description.localizedCaseInsensitiveContains(searchText) ||
                course.instructor.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by category
        if let category = selectedCategory {
            courses = courses.filter { $0.category == category }
        }
        
        // Filter by difficulty
        if let difficulty = selectedDifficulty {
            courses = courses.filter { $0.difficulty == difficulty }
        }
        
        filteredCourses = courses
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterCourses()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCourseCell", for: indexPath) as! SearchCourseTableViewCell
        let course = filteredCourses[indexPath.row]
        cell.configure(with: course)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = filteredCourses[indexPath.row]
        let lessonListVC = LessonListViewController(course: course)
        navigationController?.pushViewController(lessonListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Course.CourseCategory.allCases.count + Course.CourseDifficulty.allCases.count + 1 // +1 for divider
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCollectionViewCell
        
        let categoryCount = Course.CourseCategory.allCases.count
        
        if indexPath.item < categoryCount {
            let category = Course.CourseCategory.allCases[indexPath.item]
            let isSelected = selectedCategory == category
            cell.configure(title: category.rawValue, icon: category.icon, isSelected: isSelected, color: .systemBlue)
        } else if indexPath.item == categoryCount {
            // Divider
            cell.configureAsDivider()
        } else {
            let difficultyIndex = indexPath.item - categoryCount - 1
            let difficulty = Course.CourseDifficulty.allCases[difficultyIndex]
            let isSelected = selectedDifficulty == difficulty
            let color = UIColor(named: difficulty.color) ?? .systemGreen
            cell.configure(title: difficulty.rawValue, icon: "flag.fill", isSelected: isSelected, color: color)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryCount = Course.CourseCategory.allCases.count
        
        if indexPath.item < categoryCount {
            let category = Course.CourseCategory.allCases[indexPath.item]
            if selectedCategory == category {
                selectedCategory = nil
            } else {
                selectedCategory = category
            }
        } else if indexPath.item > categoryCount {
            let difficultyIndex = indexPath.item - categoryCount - 1
            let difficulty = Course.CourseDifficulty.allCases[difficultyIndex]
            if selectedDifficulty == difficulty {
                selectedDifficulty = nil
            } else {
                selectedDifficulty = difficulty
            }
        }
        
        filterCourses()
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryCount = Course.CourseCategory.allCases.count
        
        if indexPath.item == categoryCount {
            // Divider
            return CGSize(width: 1, height: 30)
        }
        
        return CGSize(width: 100, height: 40)
    }
}

// MARK: - Search Course Table View Cell
class SearchCourseTableViewCell: UITableViewCell {
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let instructorLabel = UILabel()
    private let durationLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let lessonsLabel = UILabel()
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
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        
        // Category label
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .systemBlue
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(categoryLabel)
        
        // Instructor label
        instructorLabel.font = UIFont.systemFont(ofSize: 12)
        instructorLabel.textColor = .secondaryLabel
        instructorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(instructorLabel)
        
        // Duration label
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .secondaryLabel
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(durationLabel)
        
        // Difficulty label
        difficultyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(difficultyLabel)
        
        // Lessons label
        lessonsLabel.font = UIFont.systemFont(ofSize: 12)
        lessonsLabel.textColor = .secondaryLabel
        lessonsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(lessonsLabel)
        
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
            
            // Category label
            categoryLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Instructor label
            instructorLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            instructorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Duration label
            durationLabel.topAnchor.constraint(equalTo: instructorLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            durationLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            // Difficulty label
            difficultyLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            difficultyLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            // Lessons label
            lessonsLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 4),
            lessonsLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
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
        categoryLabel.text = "📱 \(course.category.rawValue)"
        instructorLabel.text = "👤 \(course.instructor)"
        durationLabel.text = "⏱️ \(course.estimatedDuration) min"
        lessonsLabel.text = "📚 \(course.lessons.count) lessons"
        
        difficultyLabel.text = course.difficulty.rawValue
        difficultyLabel.textColor = UIColor(named: course.difficulty.color) ?? .systemGreen
    }
}

// MARK: - Filter Collection View Cell
class FilterCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let dividerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Icon image view
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        // Divider view
        dividerView.backgroundColor = .separator
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12),
            
            dividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dividerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dividerView.widthAnchor.constraint(equalToConstant: 1),
            dividerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    func configure(title: String, icon: String, isSelected: Bool, color: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .white : .label
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = isSelected ? .white : color
        
        backgroundColor = isSelected ? color : UIColor.systemGray6
        layer.cornerRadius = 20
        
        titleLabel.isHidden = false
        iconImageView.isHidden = false
        dividerView.isHidden = true
    }
    
    func configureAsDivider() {
        titleLabel.isHidden = true
        iconImageView.isHidden = true
        dividerView.isHidden = false
        backgroundColor = .clear
        layer.cornerRadius = 0
    }
} 
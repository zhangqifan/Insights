//
//  InsightsCalendarDatePicker.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//
//  NOTE: This is the UIKit implementation (currently in use).
//  For SwiftUI implementation, see: SwiftUIVersion/InsightsCalendarDatePicker+SwiftUI.swift
//

import UIKit

// MARK: - UIKit Date Picker View Controller

/// View controller presenting a popover with a month/year picker for calendar navigation
public class InsightsCalendarDatePickerViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The currently selected date
    private var currentDate: Date
    
    /// The minimum selectable date
    private let minimumDate: Date
    
    /// Callback invoked when the date changes
    private let onDateChanged: ((Date) -> Void)?
    
    // MARK: - UI Components
    
    private let containerStackView = UIStackView()
    private let topBarView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .custom)
    private let datePicker = MonthYearWheelPicker()
    private let actionsStackView = UIStackView()
    private let nowButton = UIButton(type: .custom)
    private let doneButton = UIButton(type: .custom)
    
    // MARK: - Initialization
    
    /// Initializes the date picker view controller
    /// - Parameters:
    ///   - currentDate: The initially selected date
    ///   - minimumDate: The minimum selectable date, defaults to now
    ///   - onDateChanged: Callback invoked when the user confirms a date selection
    public init(currentDate: Date, minimumDate: Date = Date(), onDateChanged: ((Date) -> Void)?) {
        self.currentDate = currentDate
        self.minimumDate = minimumDate
        self.onDateChanged = onDateChanged
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // Cleanup handled automatically
    }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    /// Sets up the entire UI hierarchy
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Container Stack View
        containerStackView.axis = .vertical
        containerStackView.spacing = 0
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerStackView)
        
        // Top Bar
        setupTopBar()
        containerStackView.addArrangedSubview(topBarView)
        
        // Date Picker
        setupDatePicker()
        containerStackView.addArrangedSubview(datePicker)
        
        // Actions
        setupActions()
        containerStackView.addArrangedSubview(actionsStackView)
    }
    
    /// Configures the top bar with title and close button
    private func setupTopBar() {
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        titleLabel.text = "Time travel"
        titleLabel.font = .roundedFont(fontSize: 22, weight: .semibold)
        titleLabel.textColor = .growMain
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(titleLabel)
        
        // Close Button
        closeButton.backgroundColor = .quaternarySystemFill
        closeButton.layer.cornerRadius = 22
        closeButton.setImage(UIImage(systemName: "xmark")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        ), for: .normal)
        closeButton.tintColor = .growMain
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            topBarView.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
    }
    
    /// Configures the month/year picker wheel
    private func setupDatePicker() {
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = .now
        datePicker.rowHeight = 34
        datePicker.intrinsicHeight = 173
        datePicker.intrinsicWidth = datePicker.recommendedIntrinsicWidth()
        datePicker.setDate(currentDate, animated: false)
        datePicker.onDateSelected = { [weak self] month, year in
            guard let self = self,
                  let newDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) else {
                return
            }
            self.currentDate = newDate
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Configures the action buttons (Now and Done)
    private func setupActions() {
        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 14
        actionsStackView.distribution = .fillEqually
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Now Button
        nowButton.setTitle("Now", for: .normal)
        nowButton.titleLabel?.font = .roundedFont(fontSize: 17, weight: .semibold)
        nowButton.setTitleColor(.growBlue, for: .normal)
        nowButton.backgroundColor = .quaternarySystemFill
        nowButton.layer.cornerRadius = 12
        nowButton.layer.cornerCurve = .continuous
        nowButton.addTarget(self, action: #selector(nowButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(nowButton)
        
        // Done Button
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .roundedFont(fontSize: 17, weight: .semibold)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .growBlue
        doneButton.layer.cornerRadius = 12
        doneButton.layer.cornerCurve = .continuous
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        actionsStackView.addArrangedSubview(doneButton)
        
        NSLayoutConstraint.activate([
            actionsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /// Sets up Auto Layout constraints and calculates preferred content size
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14)
        ])
        
        // Calculate preferred content size
        view.layoutIfNeeded()
        let fittingSize = containerStackView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        preferredContentSize = CGSize(
            width: fittingSize.width + 28,
            height: fittingSize.height + 28
        )
    }
    
    // MARK: - Actions
    
    /// Dismisses the picker without making changes
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    /// Selects the current date and dismisses the picker
    @objc private func nowButtonTapped() {
        onDateChanged?(.now)
        dismiss(animated: true)
    }
    
    /// Confirms the selected date and dismisses the picker
    @objc private func doneButtonTapped() {
        onDateChanged?(currentDate)
        dismiss(animated: true)
    }
}


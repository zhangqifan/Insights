//
//  MonthYearWheelPicker.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//
//  NOTE: This is the pure UIKit implementation (currently in use).
//  For SwiftUI wrapper, see: SwiftUIVersion/MonthYearWheelPicker+SwiftUI.swift
//

import UIKit

// MARK: - UIKit Picker

/// Custom UIPickerView for selecting month and year
open class MonthYearWheelPicker: UIPickerView {
    
    // MARK: - Private Properties
    
    /// Calendar instance for date calculations
    private var calendar = Calendar(identifier: .gregorian)
    
    /// Internal maximum date storage
    private var _maximumDate: Date?
    
    /// Internal minimum date storage
    private var _minimumDate: Date?
    
    /// Internal currently selected date storage
    private var _date: Date?
    
    /// Array of localized month names
    private var months = [String]()
    
    /// Array of available years based on min/max dates
    private var years = [Int]()
    
    // MARK: - Style Properties
    
    /// Font used for picker rows
    private let font = UIFont.roundedFont(fontSize: 24, weight: .semibold)
    
    /// Text color for enabled rows
    private let textColor = UIColor.label
    
    /// Text color for disabled rows (dates outside min/max range)
    private let disabledTextColor = UIColor.secondaryLabel
    
    /// Height of each picker row
    open var rowHeight: CGFloat = 34
    
    /// Custom intrinsic width for the picker
    open var intrinsicWidth: CGFloat? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// Custom intrinsic height for the picker
    open var intrinsicHeight: CGFloat? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    // MARK: - Public Properties
    
    /// The maximum selectable date (normalized to first day of month)
    open var maximumDate: Date {
        set {
            _maximumDate = formattedDate(from: newValue)
            updateAvailableYears()
        }
        get {
            return _maximumDate ?? Date()
        }
    }
    
    /// The minimum selectable date (normalized to first day of month)
    open var minimumDate: Date {
        set {
            _minimumDate = formattedDate(from: newValue)
            updateAvailableYears()
        }
        get {
            return _minimumDate ?? Date()
        }
    }
    
    /// The currently selected date (normalized to first day of month)
    open var date: Date {
        set { setDate(newValue, animated: true) }
        get { return _date ?? formattedDate(from: Date()) }
    }
    
    /// Callback invoked when a date is selected
    /// - Parameters:
    ///   - month: The selected month (1-12)
    ///   - year: The selected year
    open var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    // MARK: - Overrides
    
    open override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(
            width: intrinsicWidth ?? defaultSize.width,
            height: intrinsicHeight ?? defaultSize.height
        )
    }
    
    // MARK: - Public Methods
    
    /// Sets the currently selected date
    /// - Parameters:
    ///   - date: The date to select
    ///   - animated: Whether to animate the selection
    public func setDate(_ date: Date, animated: Bool) {
        let date = formattedDate(from: date)
        _date = date
        if date > maximumDate {
            setDate(maximumDate, animated: true)
            return
        }
        if date < minimumDate {
            setDate(minimumDate, animated: true)
            return
        }
        updatePickers(animated: animated)
    }
    
    // MARK: - Private Methods
    
    /// Updates the picker to reflect the current date
    /// - Parameter animated: Whether to animate the update
    private func updatePickers(animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        DispatchQueue.main.async {
            self.selectRow(month - 1, inComponent: 0, animated: animated)
            if let firstYearIndex = self.years.firstIndex(of: year) {
                self.selectRow(firstYearIndex, inComponent: 1, animated: animated)
            }
        }
    }
    
    /// Handles picker selection changes and validates the selected date
    private func pickerViewDidSelectRow() {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        guard let date = DateComponents(calendar: calendar, year: year, month: month, day: 1).date else {
            return
        }
        
        let validDate: Date
        if date < minimumDate {
            validDate = minimumDate
        } else if date > maximumDate {
            validDate = maximumDate
        } else {
            validDate = date
        }
        
        self._date = validDate
        
        if validDate != date {
            DispatchQueue.main.async {
                self.updatePickers(animated: true)
            }
        }
        
        onDateSelected?(calendar.component(.month, from: validDate), calendar.component(.year, from: validDate))
    }
    
    /// Normalizes a date to the first day of its month
    /// - Parameter date: The date to format
    /// - Returns: A new date set to the first day of the month
    private func formattedDate(from date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: DateComponents(year: components.year, month: components.month, day: 1)) ?? Date()
    }
    
    /// Updates the years array based on minimum and maximum dates
    private func updateAvailableYears() {
        var years = [Int]()
        let startYear = calendar.component(.year, from: minimumDate)
        let endYear = calendar.component(.year, from: maximumDate)
        
        for year in startYear...endYear {
            years.append(year)
        }
        self.years = years
        reloadAllComponents()
    }
    
    /// Performs common initialization tasks
    private func commonSetup() {
        delegate = self
        dataSource = self
        
        months = DateFormatter().monthSymbols.map { $0.capitalized }
        updateAvailableYears()
    }
    
    /// Calculates the optimal width for a component based on its content
    /// - Parameter texts: The texts to measure
    /// - Returns: The calculated width including padding
    private func calculateOptimalWidth(for texts: [String]) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        var maxWidth: CGFloat = 0
        
        for text in texts {
            let size = (text as NSString).size(withAttributes: attributes)
            maxWidth = max(maxWidth, ceil(size.width))
        }
        return maxWidth + 32
    }
    
    /// Calculates the recommended intrinsic width for the picker based on content
    /// - Returns: The recommended width
    internal func recommendedIntrinsicWidth() -> CGFloat {
        let monthWidth = calculateOptimalWidth(for: months)
        let yearWidth = calculateOptimalWidth(for: years.map { "\($0)" })
        return monthWidth + yearWidth + 60
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MonthYearWheelPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return months.count
        case 1: return years.count
        default: return 0
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewDidSelectRow()
        if component == 1 {
            pickerView.reloadComponent(0)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = font
        
        switch component {
        case 0:
            label.text = months[row]
            label.textColor = textColor
            
            let month = row + 1
            let year = years[selectedRow(inComponent: 1)]
            if let date = DateComponents(calendar: calendar, year: year, month: month, day: 1).date,
               date < minimumDate || date > maximumDate {
                label.textColor = disabledTextColor
            }
        case 1:
            label.text = "\(years[row])"
            label.textColor = textColor
        default:
            break
        }
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return calculateOptimalWidth(for: months)
        case 1: return calculateOptimalWidth(for: years.map { "\($0)" })
        default: return 100
        }
    }
}


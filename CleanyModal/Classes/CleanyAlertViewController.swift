//
//  CleanyAlertViewController.swift
//  CleanyModal
//
//  Created by Lory Huz on 21/03/2018.
//

import UIKit

private let kFooterMargin: CGFloat = 0
private let kCellReuseIdentifier = "actionCell"
private let kCellDefaultHeight: CGFloat = 60.0

open class CleanyAlertViewController: CleanyModalViewController {
    
    public enum Style: IntegerLiteralType {
        case actionSheet
        case alert
        
        var widthMultiplier: CGFloat {
            switch self {
            case .actionSheet:
                return 0.90
            default:
                return 0.75
            }
        }
    }
    
    @IBOutlet weak private var mainContentView: UIView!
    
    @IBOutlet weak private var actionsTV: UITableView!
    
    @IBOutlet weak private var actionsTVHeight: NSLayoutConstraint!
    @IBOutlet weak private var bottomMarginFromActionsTV: NSLayoutConstraint!
    
    @IBOutlet weak private var actionsSheetCancelButton: UIButton?
    @IBOutlet weak private var actionsSheetCancelButtonHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak private var messageLB: UILabel!
    @IBOutlet weak private var titleLB: UILabel!
    
    @IBOutlet weak public  var contentStackView: UIStackView!
    @IBOutlet weak public  var iconIV: UIImageView!
    
    private var _stackedViews: [(view: UIView, height: CGFloat)]? = nil

    open var textViews: [UITextView]? {
        get { return _stackedViews?.compactMap({ $0.view as? UITextView }) }
    }
    
    open var textFields: [UITextField]? {
        get { return _stackedViews?.compactMap({ $0.view as? UITextField }) }
    }
    
    private var _actions: [CleanyAlertAction]? = nil
    fileprivate var actions: [CleanyAlertAction]? {
        get { return _actions }
    }
    
    public let preferredStyle: Style
    public let styleSettings: CleanyAlertConfig.StyleSettings
    
    let dataSource: AlertModel
    
    public init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert, styleSettings: CleanyAlertConfig.StyleSettings? = nil, customNibName: String? = nil) {
        
        precondition(
            title != nil || message != nil, "NOPE ! Why you would like to show an alert without at least a title OR a message ?!"
        )
        
        self.dataSource = AlertModel(title: title, message: message, iconName: imageName)
        self.styleSettings = styleSettings ?? CleanyAlertConfig.getDefaultStyleSettings()
        self.preferredStyle = preferredStyle
        
        if let nibName = customNibName {
            super.init(nibName: nibName, bundle: nil)
        } else {
            super.init(nibName: "CleanyAlertViewController", bundle: Bundle(for: CleanyAlertViewController.self))
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = UIScreen.main.bounds
        
        if dataSource.title == nil {
            contentStackView.removeArrangedSubview(titleLB)
        } else if dataSource.message == nil {
            contentStackView.removeArrangedSubview(messageLB)
        }
        
        // ***** ActionSheet vs Alert style
        //
        switch preferredStyle {
        case .alert:
            alertViewCenterY = alertViewCenterY.setSafelyPriority(UILayoutPriority.required)
            alertViewBottom = alertViewBottom!.setSafelyPriority(UILayoutPriority.defaultLow)
            actionsSheetCancelButton?.removeFromSuperview()
        case .actionSheet:
            precondition(
                actions?.filter({ $0.style == .cancel }).count ?? 0 <= 1,
                "You can only put one cancel action in Action Sheet"
            )
            
            rearrangeActions()
            
            alertViewCenterY = alertViewCenterY.setSafelyPriority(UILayoutPriority.defaultLow)
            alertViewBottom = alertViewBottom!.setSafelyPriority(UILayoutPriority.required)
            
            if let cancelAction = actions?.first(where: { $0.style == .cancel }) {
                actionsSheetCancelButtonHeightConstraint?.constant = styleSettings[.actionCellHeight] ?? kCellDefaultHeight
                actionsSheetCancelButton?.setTitle(cancelAction.title, for: .normal)
            } else {
                actionsSheetCancelButton?.removeFromSuperview()
            }
        }
        
        alertWidthConstraint = alertWidthConstraint.setSafelyMultiplier(multiplier: preferredStyle.widthMultiplier)
        //
        // ***** End style
        
        titleLB.text = dataSource.title
        messageLB.text = dataSource.message
        if let iconName = dataSource.iconName {
            iconIV.image = UIImage(named: iconName)
        }
        
        if dataSource.iconName == nil || iconIV.image == nil {
            iconIV.removeFromSuperview()
        }
        
        actionsTV.separatorColor = styleSettings[.separatorColor] ?? UIColor.black.withAlphaComponent(0.08)
        
        handleTableViewActions()
        applyStyle()
        
        _stackedViews?.forEach({ viewTuple in
            contentStackView.addArrangedSubview(viewTuple.view)
            contentStackView.addConstraint(NSLayoutConstraint(
                item: viewTuple.view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: viewTuple.height)
            )
        })
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        view.endEditing(true)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
    }
    
    open func addAction(_ action: CleanyAlertAction) {
        if _actions == nil {
            _actions = [CleanyAlertAction]()
        }
        
        _actions?.append(action)
        
        handleTableViewActions()
    }
    
    open func addAction(title: String?, style: CleanyAlertAction.Style, handler: ((CleanyAlertAction) -> ())? = nil) {
        let action = CleanyAlertAction(title: title, style: style, handler: handler)
        addAction(action)
    }
    
    open func replaceAction(_ action: CleanyAlertAction, atIndex index: Int) {
        _actions?[index] = action
        
        actionsTV.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    open func indexPathFor(cell: UITableViewCell) -> IndexPath? {
        return actionsTV.indexPath(for: cell)
    }
    
    open func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        let textField = UITextField(frame: frame)
        textField.borderStyle = .none
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = UIColor(white: 200.0/255.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1
        textField.textAlignment = .center
        textField.tintColor = styleSettings[.tintColor] ?? UIButton.init(type: .system).titleColor(for: .normal) ?? UIColor.blue
        
        addCustomViewInContentStack(textField, height: 40)
        
        configurationHandler?(textField)
    }
    
    open func addTextView(configurationHandler: ((UITextView) -> Swift.Void)? = nil) {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let textView = UITextView(frame: frame)
        
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 7
        textView.layer.borderColor = UIColor(white: 200.0/255.0, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1
        textView.tintColor = styleSettings[.tintColor] ?? UIButton.init(type: .system).titleColor(for: .normal) ?? UIColor.blue
    
        addCustomViewInContentStack(textView, height: 100)
        
        configurationHandler?(textView)
    }
    
    open func addCustomViewInContentStack(_ view: UIView, height: CGFloat) {
        if _stackedViews == nil {
            _stackedViews = [(view: UIView, height: CGFloat)]()
        }
        
        _stackedViews?.append((view: view, height: height))
    }
    
    // MARK: - Private methods (helpers)
    
    private func numberOfRowsInActionsTable() -> Int {
        switch preferredStyle {
        case .actionSheet:
            return max((actions?.count ?? 0) - 1, 0)
        default:
            return actions?.count ?? 0
        }
    }
    
    private func rearrangeActions() {
        // Sort only needed for actionSheet
        guard preferredStyle == .actionSheet else { return }
        
        // Check if cancel action is present
        if let cancelIndex = _actions?.firstIndex(where: { $0.style == .cancel }), let cancelAction = _actions?[cancelIndex] {
            // If cancel action is not last, put at the end of array
            guard cancelIndex != max((_actions?.count ?? 0) - 1, 0) else { return }
            _actions?.remove(at: cancelIndex)
            _actions?.append(cancelAction)
        }
    }
    
    private func applyStyle() {
        if let cornerRadius = styleSettings[.cornerRadius] {
            mainContentView?.layer.cornerRadius = cornerRadius
            actionsSheetCancelButton?.layer.cornerRadius = cornerRadius
        }
        
        if let backgroundColor = styleSettings[.backgroundColor] {
            mainContentView?.backgroundColor = backgroundColor
            actionsSheetCancelButton?.backgroundColor = backgroundColor
            actionsTV?.backgroundColor = backgroundColor
        }
        
        if let tintColor = styleSettings[.tintColor] {
            iconIV.tintColor = tintColor
        }
        
        if let font = styleSettings[.actionsFont] {
            actionsSheetCancelButton?.titleLabel?.font = font
        }

        actionsSheetCancelButton?.setTitleColor(styleSettings[.defaultActionColor] ?? UIColor.black, for: .normal)
        
        titleLB.textColor = styleSettings[.textColor] ?? titleLB.textColor
        titleLB.font = styleSettings[.titleFont] ?? titleLB.font
        
        messageLB.textColor = styleSettings[.textColor] ?? messageLB.textColor
        messageLB.font = styleSettings[.messageFont] ?? messageLB.font
    }
    
    private func handleTableViewActions() {
        if viewIfLoaded != nil {
            if actionsTV.delegate == nil {
                actionsTV.dataSource = self
                actionsTV.delegate = self
                
                let bundle = Bundle(for: CleanyAlertActionTableViewCell.self)
                actionsTV.register(
                    UINib(nibName: "CleanyAlertActionTableViewCell", bundle: bundle),
                    forCellReuseIdentifier: kCellReuseIdentifier
                )
            }
            
            let count = numberOfRowsInActionsTable()
            actionsTV.separatorStyle = _actions != nil && count > 1 ? .singleLine : .none
            
            actionsTVHeight.constant = (styleSettings[.actionCellHeight] ?? kCellDefaultHeight) * CGFloat(count) + kFooterMargin
            
            if actions != nil && count > 1 {
                bottomMarginFromActionsTV.constant = 0
            }
            
            actionsTV.reloadData()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func cancelActionSheet(_ sender: UIButton) {
        guard let cancelAction = actions?.first(where: { $0.style == .cancel }) else { return }
        
        self.onDismissCallback?(self)
        
        dismiss(animated: true) {
            cancelAction.handler?(cancelAction)
        }
    }
    
}

// MARK: - UITableView Delegates

extension CleanyAlertViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInActionsTable()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as? CleanyAlertActionTableViewCell else {
            preconditionFailure()
        }
        
        action?.cell = cell
        
        if let font = styleSettings[.actionsFont] {
            cell.textLabel?.font = font
        }
        
        cell.title = action?.title
        cell.img = action?.image
        cell.backgroundColor = styleSettings[.backgroundColor] ?? .white
        
        let actionColor: UIColor!
        switch action?.style ?? .default {
        case .destructive:
            actionColor = styleSettings[.destructiveColor] ?? UIColor.red
        case .default:
            actionColor = styleSettings[.tintColor] ??
                styleSettings[.defaultActionColor] ??
                styleSettings[.textColor] ??
                UIColor.black
        case .disabled:
            let color = styleSettings[.defaultActionColor] ??
                styleSettings[.textColor] ??
                UIColor.black
            actionColor = color.withAlphaComponent(0.5)
        default:
            actionColor = styleSettings[.defaultActionColor] ?? UIColor.black
        }
        
        cell.textLB?.textColor = actionColor
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = actionColor.withAlphaComponent(0.1)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // flash background
        guard let action = actions?[indexPath.row] else { return }
        if action.style == .disabled || action.shouldDismissAlertOnTap == false {
            action.handler?(action)
        } else {
            self.onDismissCallback?(self)
            
            dismiss(animated: true) {
                action.handler?(action)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return styleSettings[.actionCellHeight] ?? kCellDefaultHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return styleSettings[.actionCellHeight] ?? kCellDefaultHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kFooterMargin
    }
}

// MARK : - Alert action class

open class CleanyAlertAction {
    
    public enum Style: IntegerLiteralType {
        
        case `default`
        
        case cancel
        
        case destructive
        
        case disabled
    }
    
    open var title: String?
    
    open var style: CleanyAlertAction.Style
    
    open var handler: ((CleanyAlertAction) -> Swift.Void)? = nil
    
    open var cell: UITableViewCell?
    
    open var shouldDismissAlertOnTap: Bool = true
    
    open var image: UIImage?
    
    public init(title: String?, style: CleanyAlertAction.Style, handler: ((CleanyAlertAction) -> Swift.Void)? = nil) {
        self.title = title
        self.style = style

        self.handler = handler
    }
}


//
//  Copyright © 2020 Satsuki Hashiba. All rights reserved.
//  GitHub: https://github.com/shiba1014
//

import UIKit

class AlertController: UIView {

    // MARK: Private

    private enum Const {
        static let textFieldHeight: CGFloat = 32
        static let keyboardMargin: CGFloat = 16
        static let textHeight: CGFloat = 80

    }

    private let style: Style
    let alertView: NewYorkAlertViewType
    /// 输入的最大字数
    var textLimit = 0
    /// 当前输入框的内容
    var textStr = ""
    var buttons: [NewYorkButton] = []
    private var tapDismissalGesture: UITapGestureRecognizer!
    var cancelButton: NewYorkButton? {
        didSet {
            if oldValue != nil {
                fatalError("NewYorkAlert can only have one button with a style of NewYorkAlert.ActionStyle.cancel")
            }
        }
    }

    private var image: UIImage? {
        didSet {
            if oldValue != nil {
                fatalError("NewYorkAlert can only have one image")
            }
            else {
                alertView.addImage(image)
            }
        }
    }

    // MARK: Public

    /// Styles indicating the type of NewYorkAlert to display.
    public enum Style {
        /// An action sheet displayed in the context of the view controller that presented it.
        case actionSheet

        /// An alert displayed modally for the app.
        case alert
    }

    /// Indicates if alert can be dismissed via background tap.
    public var isTapDismissalEnabled: Bool = true {
        willSet {
            tapDismissalGesture.isEnabled = newValue
        }
    }
    
    public var messageColor :UIColor? {
        didSet {
            guard let col = messageColor else {
                return
            }
            alertView.changeMessageColor(col)
        }
    }

    /// The array of text fields displayed by the alert.
    public private(set) var textFields: [UITextField] = []
    public private(set) var textView_P:UITextView?

    // MARK: - Initializers

    /// Creates a standard NewYorkAlert with title, message and style.
    ///
    /// - Parameters:
    ///   - title: A title of alert.
    ///   - message: A message of alert.
    ///   - style: A style of alert to display.
    ///
    /// - Returns: A NewYorkAlertController object.
    public init(title: String?, message: String?, style: Style, frame:CGRect, connerNum: CGFloat?) {
        self.style = style
        switch style {
        case .actionSheet:
            alertView = ActionSheetView(title: title, message: message ,cornerNum: connerNum)
        case .alert:
            alertView = AlertView(title: title, message: message, cornerNum: connerNum)
        }
        alertView.setBackColor(.white)
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackColor(_ color: UIColor) {
        alertView.setBackColor(color)
    }
    
    // MARK: - View life cycle

    /// Called when the view is about to made visible.
    /// Buttons and text fields will be actually added to NewYorkAlert here.
    
    // MARK: - Public method

    /// Adds a button to the NewYorkAlert.
    ///
    /// - Note:
    /// If the button's style is `NewYorkButton.Style.cancel`,
    /// the button will always be added to the bottom of the NewYorkAlert.
    /// If the number of buttons added to the NewYorkAlert is two
    /// and the `style` property is set to `NewYorkAlertController.Style.alert`,
    /// buttons will be displayed horizontally and the cancel button will be displayed
    /// on the left.
    ///
    /// - Parameter button: A button to be added to the NewYorkAlert.
    public func addButton(_ button: NewYorkButton) {
        button.addTarget(self, action: #selector(tappedButton(_:)), for: .touchUpInside)

        if button.style == .cancel {
            cancelButton = button
        }
        else {
            buttons.append(button)
        }
    }

    /// Adds buttons to the NewYorkAlert.
    ///
    /// - Note:
    /// If the button's style is `NewYorkButton.Style.cancel`,
    /// the button will always be added to the bottom of the NewYorkAlert.
    /// If the number of buttons added to the NewYorkAlert is two
    /// and the `style` property is set to `NewYorkAlertController.Style.alert`,
    /// buttons will be displayed horizontally and the cancel button will be displayed
    /// on the left.
    ///
    /// - Parameter buttons: An array of buttons to be added to the NewYorkAlert.
    public func addButtons(_ buttons: [NewYorkButton]) {
        buttons.forEach { addButton($0) }
    }

    /// Adds a text field to the NewYorkAlert.
    ///
    /// - Note:
    /// You can add a text field only if the `style` property is set
    /// to `NewYorkAlertController.Style.alert`.
    ///
    /// - Parameter configurationHandler: A block for configuring the text field
    ///                                   prior to displaying the NewYorkAlert.
    // MARK: - 关于TextField
    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = LeftPaddingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.heightAnchor.constraint(equalToConstant: Const.textFieldHeight).isActive = true
        configurationHandler?(textField)
        textField.layer.borderWidth = 0.6;
        textField.layer.borderColor = UIColor(hex: 0xE1E1E1).cgColor
        textField.font = APPFont.regular(size: 12)
        textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        textFields.append(textField)
        
        alertView.addTextFields(textFields)
        
        let notification = NotificationCenter.default
        notification.addObserver(
         self,
         selector: #selector(keyboardWillShow(_:)),
         name: UIResponder.keyboardWillShowNotification,
         object: nil
        )
        notification.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    
    public func addTextView(configurationHandler: ((UITextView) -> Void)? = nil) {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: Const.textHeight).isActive = true
        configurationHandler?(textView)
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = UIColor(hex: 0xE1E1E1).cgColor
        textView.font = APPFont.regular(size: 12)
        alertView.addTextView(textView)
        textView_P = textView
        
        let notification = NotificationCenter.default
        notification.addObserver(
         self,
         selector: #selector(keyboardWillShow(_:)),
         name: UIResponder.keyboardWillShowNotification,
         object: nil
        )
        notification.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    
    @objc func textChange(_ textField:UITextField) {
        textStr = textField.text ?? ""
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboardMinY = self.bounds.height - keyboardSize.height
        let coverd = (alertView.frame.maxY + Const.keyboardMargin) - keyboardMinY
        if coverd > 0 {
            self.frame = CGRect(
                x: 0,
                y: 0 - coverd,
                width: self.bounds.width,
                height: self.bounds.height
            )
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        self.frame = CGRect(
            x: 0,
            y: 0 ,
            width: self.bounds.width,
            height: self.bounds.height
        )
    }

    /// Adds an image to the NewYorkAlert.
    ///
    /// - Note: You can add only one image to the NewYorkAlert.
    ///
    /// - Parameter image: An image to be added to the NewYorkAlert
    public func addImage(_ image: UIImage?) {
        self.image = image
    }

    // MARK: - Private method

    private func setupViews() {
        
        tapDismissalGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        tapDismissalGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapDismissalGesture)

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(alertView)
        switch style {
        case .actionSheet:
            if #available(iOS 11.0, *) {
                NSLayoutConstraint.activate([
                    alertView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    alertView.rightAnchor.constraint(equalTo: self.rightAnchor),
                    alertView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                                 alertView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                 alertView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                 alertView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                             ])

            }

        case .alert:
            NSLayoutConstraint.activate([
                alertView.leftAnchor.constraint(equalTo: self.leftAnchor),
                alertView.rightAnchor.constraint(equalTo: self.rightAnchor),
                alertView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
        animation(alertView,0.4)
    }
    @objc private func tappedView(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: alertView)
        if alertView.isBackgroundTap(point: location) {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.removeFromSuperview()
            })
        }
    }

    @objc private func tappedButton(_ button: NewYorkButton) {
        
        if textLimit > 0 {
            if case 1...textLimit = textStr.count {
                
            }else {
                if button.style != .cancel {
                    DYTHUDTool.showWDToast("请输入正确的字符数")
                    return
                }
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            button.handler?(button)
        }) { _ in
            self.removeFromSuperview()
        }
       
    }
    
    func animation(_ view:UIView, _ duration:CFTimeInterval) {

        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        var values_Arr = [NSValue]()
        values_Arr.append(NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values_Arr.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values_Arr
        
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        animation.timingFunction = CAMediaTimingFunction(name: .default)
        view.layer.add(animation, forKey: nil)
    }

}


// MARK: - NewYorkAlertViewType -- protocol
protocol NewYorkAlertViewType: UIView {
    func addButtons(_ buttons: [NewYorkButton], cancelButton: NewYorkButton?)
    func addTextFields(_  textFields: [UITextField])
    func addImage(_ image: UIImage?)
    func isBackgroundTap(point: CGPoint) -> Bool
    func setBackColor(_ color:UIColor)
    func addTextView(_ textView:UITextView)
    func changeMessageColor(_ color:UIColor)
}

public final class NewYorkButton: UIButton {

    // MARK: Constant

    private enum Const {
        // MARK: - 设置按钮高度 字号
        static let fontSize: CGFloat = 17
        static let buttonHeight: CGFloat = 50
        static let animationDuration: TimeInterval = 0.2
    }

    // MARK: Private / Internal

    let style: Style
    let handler: ((NewYorkButton) -> Void)?

    private var titleColor: UIColor? {
        get {
            titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }

    // MARK: Public

    /// Styles to apply to buttons in the NewYorkAlert.
    public enum Style {
        /// Default style.
        case `default`

        /// Style that indicates the action cancels the operation and leaves things unchanged.
        case cancel

        /// Style that indicates the action might change or delete data.
        case destructive

        /// Style that indicates the preferred action for the user to take.
        case preferred
    }

    /// A Boolean value indicating whether the control draws a highlight.
    /// Highlight animation will be performed here.
    override public var isHighlighted: Bool {
        didSet {
            performHighlight(isHighlighted)
        }
    }

    // MARK: - Initializers

    /// Creates a button that can be added to the NewYorkAlert.
    ///
    /// - Parameters:
    ///   - title: A button title.
    ///   - style: A style that is applied to the button.
    ///   - handler: A block to execute when the user taps the button.
    ///
    /// - Returns: A NewYorkButton object.
    public init(title: String, style: Style, handler: ((NewYorkButton) -> Void)? = nil) {
        self.style = style
        self.handler = handler
        super.init(frame: .zero)
        setup(title: title, style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    /// Set button's title color from `NewYorkDynamicColor`.
    ///
    /// - Parameter color: A color to apply to the button's title
    public func setDynamicColor(_ color: NewYorkDynamicColor) {
        titleColor = color.uiColor
    }

    // MARK: - Private method

    private func setup(title: String, style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Const.buttonHeight).isActive = true

        setTitle(title, for: .normal)

        switch style {
        case .default:
            titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: Const.fontSize)
            titleColor = NewYorkDynamicColor.Button.default

        case .cancel:
            titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: Const.fontSize)
            titleColor = NewYorkDynamicColor.Button.cancel

        case .destructive:
            titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: Const.fontSize)
            titleColor = NewYorkDynamicColor.Button.destructive

        case .preferred:
            titleLabel?.font = UIFont.boldSystemFont(ofSize: Const.fontSize)
            titleColor = NewYorkDynamicColor.Button.default

        }
    }

    private func performHighlight(_ isHighlighted: Bool) {
        UIView.animate(withDuration: Const.animationDuration) { [weak self] in
            self?.backgroundColor = NewYorkDynamicColor.Background.button(isHighlighted)
        }
    }
}

public enum NewYorkDynamicColor {
    /// Light: #f44336, Dark: #e53935
    case red

    /// Light: #ff5722, Dark: #ff8a65
    case orange

    /// Light: #ffc107, Dark: #ffd54f
    case yellow

    /// Light: #4caf50, Dark: #81c784
    case green

    /// Light: #009688, Dark: #4db6ac
    case teal

    /// Light: #2196f3, Dark: #64b5f6
    case blue

    /// Light: #3f51b5, Dark: #7986cb
    case indigo

    /// Light: #9c27b0, Dark: #ba68c8
    case purple

    /// Light: #e91e63, Dark: #f06292
    case pink

    var uiColor: UIColor {
        switch self {
        case .red:      return getDynamicColor(.red)
        case .orange:   return getDynamicColor(.orange)
        case .yellow:   return getDynamicColor(.yellow)
        case .green:    return getDynamicColor(.green)
        case .teal:     return getDynamicColor(.teal)
        case .blue:     return getDynamicColor(.blue)
        case .indigo:   return getDynamicColor(.indigo)
        case .purple:   return getDynamicColor(.purple)
        case .pink:     return getDynamicColor(.pink)
        }
    }

    private func getDynamicColor(_ color: Color) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { trait in
                trait.userInterfaceStyle == .dark ? color.dark : color.light
            }
        }
        else {
            return color.light
        }
    }
}

private enum Color {
    /// #0x2A2827
    static let black = UIColor(hex: 0x2A2827)
    static let msg   = UIColor(hex: 0x494847)
    static let cancel = UIColor(hex: 0x8E8E93)
    static let defaultC = UIColor(hex: 0x007AFF)
    case red
    case orange
    case yellow
    case green
    case teal
    case blue
    case indigo
    case purple
    case pink

    var light: UIColor {
        switch self {
        case .red:      return UIColor(hex: 0xe53935)
        case .orange:   return UIColor(hex: 0xff5722)
        case .yellow:   return UIColor(hex: 0xffc107)
        case .green:    return UIColor(hex: 0x4caf50)
        case .teal:     return UIColor(hex: 0x009688)
        case .blue:     return UIColor(hex: 0x2196f3)
        case .indigo:   return UIColor(hex: 0x3f51b5)
        case .purple:   return UIColor(hex: 0x9c27b0)
        case .pink:     return UIColor(hex: 0xe91e63)
        }
    }

    var dark: UIColor {
        switch self {
        case .red:      return UIColor(hex: 0xf44336)
        case .orange:   return UIColor(hex: 0xff8a65)
        case .yellow:   return UIColor(hex: 0xffd54f)
        case .green:    return UIColor(hex: 0x81c784)
        case .teal:     return UIColor(hex: 0x4db6ac)
        case .blue:     return UIColor(hex: 0x64b5f6)
        case .indigo:   return UIColor(hex: 0x7986cb)
        case .purple:   return UIColor(hex: 0xba68c8)
        case .pink:     return UIColor(hex: 0xf06292)
        }
    }
}


extension NewYorkDynamicColor {
    enum Background {
        static let `default`: UIColor = {
            if #available(iOS 13.0, *) {
                return .white
            }
            else {
                return .white
            }
        }()

        static let sub: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.tertiarySystemBackground
            }
            else {
                return .white
            }
        }()

        static let overlay = UIColor(white: 0, alpha: 0.5)

        static let separator: UIColor = {
            return UIColor(hex: 0xE1E1E1)
        }()

        static let highlighted: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray5
            }
            else {
                return UIColor(white: 0.9, alpha: 1)
            }
        }()

        static func button(_ isHighlighted: Bool) -> UIColor {
            isHighlighted ? Background.highlighted : Background.default
        }
    }
}

extension NewYorkDynamicColor {
    enum Text {
        static let title: UIColor = {
            if #available(iOS 13.0, *) {
                return Color.black 
            }
            else {
                return Color.black 
            }
        }()

        static let message: UIColor = {
            if #available(iOS 13.0, *) {
                return Color.msg 
            }
            else {
                return Color.msg 
            }
        }()
    }
}

extension NewYorkDynamicColor {
    enum Button {
        static let `default`:   UIColor = Color.defaultC 
        static let destructive: UIColor = NewYorkDynamicColor.red.uiColor
        static let cancel:      UIColor = Color.cancel 
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF) >> 0) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
// MARK: - AlertView  警告弹窗---
final class AlertView: UIView, NewYorkAlertViewType {

    // MARK: Constants

    private enum Const {
        enum ContentView {
            static let minMargin: CGFloat = .deviceFit(16)
            static let maxWidth: CGFloat = .deviceFit(270)
        }

        enum FontSize {
            static let title: CGFloat = 16
            static let message: CGFloat = 14
        }

        enum Spacing {
            static let large: CGFloat = .deviceFit(16)
            static let small: CGFloat = .deviceFit(9)
        }

        static let padding: CGFloat = .deviceFit(16)
        static let topPadding: CGFloat = .deviceFit(20)
        static let bottomPadding: CGFloat = .deviceFit(12)
        static let cornerRadius: CGFloat = 2
        static let imageHeight: CGFloat = .deviceFit(150)
    }

    // MARK: Views

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.default
        view.layer.cornerRadius = Const.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Const.Spacing.large
        return stackView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Const.Spacing.small
        stackView.alignment = .center
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = NewYorkDynamicColor.Text.title
        label.font = UIFont(name: "PingFangSC-Medium", size: Const.FontSize.title)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = NewYorkDynamicColor.Text.message
        label.font = UIFont(name: "PingFangSC-Regular", size: Const.FontSize.message)
        
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let textFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.sub
        view.layer.cornerRadius = Const.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let textView_A:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.sub
        view.layer.cornerRadius = Const.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.separator
        return view
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Initializers

    init(title: String?, message: String?, cornerNum: CGFloat?) {
        super.init(frame: .zero)
        setupViews(title: title, message: message, cornerNum:cornerNum)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - NewYorkAlertViewType protocol method
    
    func setBackColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
    func addButtons(_ buttons: [NewYorkButton], cancelButton: NewYorkButton?) {
        var buttonArray: [NewYorkButton] = buttons
        if let cancel = cancelButton {
            if buttons.count == 1 {
                buttonArray.insert(cancel, at: 0)
            }
            else {
                buttonArray.append(cancel)
            }
        }

        if buttonArray.count == 2,
            let left = buttonArray.first,
            let right = buttonArray.last {
            addTwoButtons(left, right)
        }
        else {
            buttonStackView.axis = .vertical
            buttonArray.enumerated().forEach { index, button in
                if index != 0 {
                    buttonStackView.addSeparator()
                }
                buttonStackView.addArrangedSubview(button)
            }
        }
    }

    func addTextFields(_ textFields: [UITextField]) {
        contentStackView.addArrangedSubview(textFieldView)

        textFields.enumerated().forEach { index, tf in
            if index != 0 {
                textFieldStackView.addSeparator()
            }

            textFieldStackView.addArrangedSubview(tf)
        }
    }
    
    func addTextView(_ textView: UITextView) {
        
        contentStackView.addArrangedSubview(textView_A)
        textStackView.addSeparator()
        textStackView.addArrangedSubview(textView)
           
    }
    
    func changeMessageColor(_ color: UIColor) {
        messageLabel.textColor = color
        messageLabel.font = UIFont(name: "PingFangSC-Regular", size: Const.FontSize.title)
    }

    func addImage(_ image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.insertArrangedSubview(imageView, at: 0)

        imageView.heightAnchor.constraint(equalToConstant: Const.imageHeight).isActive = true
    }

    func isBackgroundTap(point: CGPoint) -> Bool {
        !contentView.frame.contains(point)
    }

    // MARK: - Private method

    private func setupViews(title: String?, message: String?, cornerNum: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title
        titleLabel.isHidden = title?.isEmpty ?? true
        messageLabel.text = message
        messageLabel.isHidden = message?.isEmpty ?? true

        textFieldView.addSubview(textFieldStackView)
        textView_A.addSubview(textStackView)
        

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(labelStackView)

        contentView.addSubview(contentStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(buttonStackView)
        addSubview(contentView)
        contentView.layer.cornerRadius = cornerNum ?? 2
        var constraints: [NSLayoutConstraint] = []

        // Constraints for contentView
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: Const.ContentView.minMargin)
        let rightConstraint = rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Const.ContentView.minMargin)
        leftConstraint.priority = .defaultHigh
        rightConstraint.priority = .defaultHigh

        constraints += [
            leftConstraint,
            rightConstraint,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: Const.ContentView.maxWidth)
        ]

        // Constraints for contentStackView
        constraints += [
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Const.topPadding),
            contentStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Const.padding),
            contentView.rightAnchor.constraint(equalTo: contentStackView.rightAnchor, constant: Const.padding)
        ]

        // Constraints for textFieldView
        constraints += [
            textFieldView.topAnchor.constraint(equalTo: textFieldStackView.topAnchor),
            textFieldView.leftAnchor.constraint(equalTo: textFieldStackView.leftAnchor),
            textFieldView.rightAnchor.constraint(equalTo: textFieldStackView.rightAnchor),
            textFieldView.bottomAnchor.constraint(equalTo: textFieldStackView.bottomAnchor)
        ]
        
        constraints += [
            textView_A.topAnchor.constraint(equalTo: textStackView.topAnchor),
            textView_A.leftAnchor.constraint(equalTo: textStackView.leftAnchor),
            textView_A.rightAnchor.constraint(equalTo: textStackView.rightAnchor),
            textView_A.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor)
        ]
        
        
        
        constraints += [
           messageLabel.leftAnchor.constraint(equalTo: labelStackView.leftAnchor, constant:.deviceFit(13)),
           messageLabel.rightAnchor.constraint(equalTo: labelStackView.rightAnchor, constant: -.deviceFit(13))
        ]

        // Constraints for separatorView
        constraints += [
            separatorView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Const.bottomPadding),
            separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ]

        // Constraints for buttonStackView
        constraints += [
            buttonStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func addTwoButtons(_ left: NewYorkButton, _ right: NewYorkButton) {
        buttonStackView.axis = .horizontal
        buttonStackView.addArrangedSubview(left)
        buttonStackView.addSeparator()
        buttonStackView.addArrangedSubview(right)
        left.widthAnchor.constraint(equalTo: right.widthAnchor).isActive = true
    }
}
// MARK: - LeftPaddingTextField
final class LeftPaddingTextField: UITextField {
    private enum Const {
        static let padding: CGFloat = 8
    }

    private let padding = UIEdgeInsets(top: 0, left: Const.padding, bottom: 0, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

// MARK: - UIStackView-extension
extension UIStackView {
    private enum Const {
        static let borderWidth: CGFloat = 0.5
    }

    func addSeparator() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.separator
        addArrangedSubview(view)

        if axis == .horizontal {
            view.widthAnchor.constraint(equalToConstant: Const.borderWidth).isActive = true
        }
        else {
            view.heightAnchor.constraint(equalToConstant: Const.borderWidth).isActive = true
        }
    }
}
// MARK: - ActionSheetView
final class ActionSheetView: UIView, NewYorkAlertViewType {
    func addTextView(_ textView: UITextView) {
        
    }
    func changeMessageColor(_ color: UIColor) {
        messageLabel.textColor = color
    }
    // MARK: Constants

    private enum Const {
        enum FontSize {
            static let title: CGFloat = 16
            static let message: CGFloat = 14
        }

        enum Spacing {
            static let large: CGFloat = 16
            static let small: CGFloat = 8
        }

        static let margin: CGFloat = 8
        static let padding: CGFloat = 16
        static let maxActionSheetWidth: CGFloat = 400
        static let cornerRadius: CGFloat = 5
        static let imageHeight: CGFloat = 150
    }

    // MARK: Views

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.default
        view.layer.cornerRadius = Const.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Const.Spacing.large
        return stackView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Const.Spacing.small
        stackView.alignment = .center
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = NewYorkDynamicColor.Text.title
        label.font = .boldSystemFont(ofSize: Const.FontSize.title)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = NewYorkDynamicColor.Text.message
        label.font = .systemFont(ofSize: Const.FontSize.message)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private let cancelButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NewYorkDynamicColor.Background.default
        view.layer.cornerRadius = Const.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Initializers

    init(title: String?, message: String?, cornerNum: CGFloat?) {
        super.init(frame: .zero)
        setupViews(title: title, message: message, cornerNum: cornerNum)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - NewYorkAlertViewType protocol method
    
    func setBackColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
        
    func addButtons(_ buttons: [NewYorkButton], cancelButton: NewYorkButton?) {
        if let cancelButton = cancelButton {
            addCancelButton(cancelButton)
        }

        buttons.forEach {
            buttonStackView.addSeparator()
            buttonStackView.addArrangedSubview($0)
        }
    }

    func addTextFields(_ textField: [UITextField]) {
        fatalError("Text fields cannot be added to NewYorkAlertController of style NewYorkAlertController.Style.actionSheet")
    }

    func addImage(_ image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.insertArrangedSubview(imageView, at: 0)

        imageView.heightAnchor.constraint(equalToConstant: Const.imageHeight).isActive = true
    }

    func isBackgroundTap(point: CGPoint) -> Bool {
        !contentView.frame.union(cancelButtonView.frame).contains(point)
    }

    // MARK: - Private method

    private func setupViews(title: String?, message: String?, cornerNum: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title
        titleLabel.isHidden = title?.isEmpty ?? true
        messageLabel.text = message
        messageLabel.isHidden = message?.isEmpty ?? true

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(labelStackView)

        contentView.addSubview(contentStackView)
        contentView.addSubview(buttonStackView)
        addSubview(contentView)
        addSubview(cancelButtonView)

        var constraints: [NSLayoutConstraint] = []

        // Constraints for contentView
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: Const.margin)
        let rightConstraint = rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Const.margin)
        leftConstraint.priority = .defaultHigh
        rightConstraint.priority = .defaultHigh

        constraints += [
            leftConstraint,
            rightConstraint,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: Const.maxActionSheetWidth)
        ]

        // Constraints for contentStackView
        constraints += [
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Const.padding),
            contentStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Const.padding),
            contentView.rightAnchor.constraint(equalTo: contentStackView.rightAnchor, constant: Const.padding)
        ]
        
        constraints += [
           messageLabel.leftAnchor.constraint(equalTo: labelStackView.leftAnchor, constant:-13),
           messageLabel.rightAnchor.constraint(equalTo: labelStackView.rightAnchor, constant: 13)
        ]

        // Constraints for buttonStackView
        constraints += [
            buttonStackView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Const.padding),
            buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        // Constraints for cancelButtonView
        constraints += [
            cancelButtonView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Const.margin),
            cancelButtonView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cancelButtonView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomAnchor.constraint(equalTo: cancelButtonView.bottomAnchor, constant: Const.margin)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func addCancelButton(_ button: NewYorkButton) {
        cancelButtonView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: cancelButtonView.topAnchor),
            button.leftAnchor.constraint(equalTo: cancelButtonView.leftAnchor),
            cancelButtonView.rightAnchor.constraint(equalTo: button.rightAnchor),
            cancelButtonView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }
}

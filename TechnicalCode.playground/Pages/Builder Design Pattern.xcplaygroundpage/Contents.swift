/*:
 # Builder Design Pattern
 **Builder** is a creational design pattern that lets you construct complex objects step by step. The pattern allows you to produce different types and representations of an object using the same construction code.
 
 You can find more information about the **builder design patter** [here](https://refactoring.guru/design-patterns/builder), where it will explain what it is and how to implement it.
 
 ### ButtonBuilder
 I decided to implement this design pattern on a UIButton to demostrate its pottential. But what I made would be considered a mere prototype, because I have only covered the basics of a button.
 
 [Previous](@previous)
 [Next](@next)
 */

import UIKit
import PlaygroundSupport

class ButtonBuilder {
    enum ButtonStyle {
        case plain
        case gray
        case tinted
        case filled
        case borderless
        case bordered
        case borderedTinted
        case borderedProminent
    }
    
    
    private var button: UIButton
    
    init(button: UIButton) {
        self.button = button
        configure()
    }
    
    // Basic style configuration
    // so button configuration won't be nil
    private func configure() {
        if self.button.configuration == nil {
            self.button.translatesAutoresizingMaskIntoConstraints = false
            let configuration = UIButton.Configuration.plain().updated(for: self.button)
            self.button.configuration = configuration
        }
    }
    
    func tintColor(_ color: UIColor) -> ButtonBuilder {
        button.tintColor = color
        return self
    }
    
    func title(_ title: String) -> ButtonBuilder {
        if let attributedTitle = button.configuration?.attributedTitle {
            let attributes = attributedTitle.runs.first!.attributes
            return self.title(attributedTitle: AttributedString(title, attributes: attributes))
        }
        return self.title(attributedTitle: AttributedString(title))
    }
    
    func title(attributedTitle: AttributedString?) -> ButtonBuilder {
        button.configuration?.attributedTitle = attributedTitle
        return self
    }
    
    func subtitle(_ subtitle: String) -> ButtonBuilder {
        if let attributedSubtitle = button.configuration?.attributedSubtitle {
            let attributes = attributedSubtitle.runs.first!.attributes
            return self.subtitle(attributedSubtitle: AttributedString(subtitle, attributes: attributes))
        }
        return self.subtitle(attributedSubtitle: AttributedString(subtitle))
    }
    
    func subtitle(attributedSubtitle: AttributedString?) -> ButtonBuilder {
        button.configuration?.attributedSubtitle = attributedSubtitle
        return self
    }
    
    func titleFont(_ font: UIFont) -> ButtonBuilder {
        button.configuration?.attributedTitle?.font = font
        return self
    }
    
    func titleForegroundColor(_ color: UIColor) -> ButtonBuilder {
        button.configuration?.attributedTitle?.foregroundColor = color
        return self
    }
    
    func subtitleFont(_ font: UIFont) -> ButtonBuilder {
        button.configuration?.attributedSubtitle?.font = font
        return self
    }
    
    func image(_ image: UIImage?) -> ButtonBuilder {
        button.configuration?.image = image
        return self
    }
    
    func action(_ action: @escaping (_ button: UIButton?) -> Void, for: UIControl.Event = .touchUpInside) -> ButtonBuilder {
        button.addAction(UIAction(handler: { uiAction in
            action(uiAction.sender as? UIButton)
        }), for: .touchUpInside)
        return self
    }
    
    func style(_ style: ButtonStyle) -> ButtonBuilder {
        var configuration: UIButton.Configuration?
        
        switch style {
        case .plain:
            configuration = UIButton.Configuration.plain().updated(for: button)
        case .gray:
            configuration = UIButton.Configuration.gray().updated(for: button)
        case .tinted:
            configuration = UIButton.Configuration.tinted().updated(for: button)
        case .filled:
            configuration = UIButton.Configuration.filled().updated(for: button)
        case .borderless:
            configuration = UIButton.Configuration.borderless().updated(for: button)
        case .bordered:
            configuration = UIButton.Configuration.bordered().updated(for: button)
        case .borderedTinted:
            configuration = UIButton.Configuration.borderedTinted().updated(for: button)
        case .borderedProminent:
            configuration = UIButton.Configuration.borderedProminent().updated(for: button)
        }
        
        button.configuration = configuration
        return self
    }
    
    func create() -> UIButton {
        return button
    }
}

extension UIButton {
    static func build(buttonType: UIButton.ButtonType = .system) -> ButtonBuilder {
        return ButtonBuilder(button: UIButton(type: buttonType))
    }
    
    func modify() -> ButtonBuilder {
        return ButtonBuilder(button: self)
    }
}

final class MainView: UIViewController {
    
    var button = UIButton
                    .build()
                    .style(.filled)
                    .title("Press me")
                    .titleFont(UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .black))
                    .titleForegroundColor(.orange)
                    .subtitle("0")
                    .image(UIImage(systemName: "arrowshape.right.fill"))
                    .tintColor(.brown)
                    .create()
    
    var count = 0
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        
        button
            .modify()
            .action(buttonAction(button:))
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func buttonAction(button: UIButton?) {
        count += 1
        button?
            .modify()
            .subtitle("\(count)")
    }
}

let master = MainView()
PlaygroundPage.current.liveView = UINavigationController(rootViewController: master)

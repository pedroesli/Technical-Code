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
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        // Basic style configuration
        // so button configuration won't be nil
        if self.button.configuration == nil {
            let configuration = UIButton.Configuration.plain().updated(for: self.button)
            self.button.configuration = configuration
        }
    }
    
    func tintColor(_ color: UIColor) -> ButtonBuilder {
        button.tintColor = color
        return self
    }
    
    func title(_ title: String) -> ButtonBuilder {
        button.configuration?.title = title
        return self
    }
    
    func title(attributedTitle: AttributedString) -> ButtonBuilder {
        button.configuration?.attributedTitle = attributedTitle
        return self
    }
    
    func subtitle(_ subtitle: String) -> ButtonBuilder {
        button.configuration?.subtitle = subtitle
        return self
    }
    
    func image(_ image: UIImage?) -> ButtonBuilder {
        button.configuration?.image = image
        return self
    }
    
    func action(_ action: @escaping (_ button: UIButton?) -> Void ) -> ButtonBuilder {
        button.addAction(UIAction(handler: { uiAction in
            let button = uiAction.sender as? UIButton
            action(button)
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
    static func modify(buttonType: UIButton.ButtonType = .system) -> ButtonBuilder {
        return ButtonBuilder(button: UIButton(type: buttonType))
    }
    
    func modify() -> ButtonBuilder {
        return ButtonBuilder(button: self)
    }
}

final class MainView: UIViewController {
    
    var button = UIButton
        .modify()
        .style(.filled)
        .title("Press me")
        .subtitle("0")
        .image(UIImage(systemName: "arrowshape.right.fill"))
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

/*:
 # Dependency Injection
 
 In software engineering, **dependency injection** is a design pattern in which an object or function receives other objects or functions that it depends on. A form of inversion of control, dependency injection aims to separate the concerns of constructing objects and using them, leading to loosely coupled programs. The pattern ensures that an object or function which wants to use a given service should not have to know how to construct those services. Instead, the receiving 'client' (object or function) is provided with its dependencies by external code (an 'injector'), which it is not aware of. Dependency injection helps by making implicit dependencies explicit and helps solve the following problems:

 - How can a class be independent from the creation of the objects it depends on?
 - How can an application, and the objects it uses support different configurations?
 - How can the behavior of a piece of code be changed without editing it directly?
 
 Wikipedia reference: [https://en.wikipedia.org/wiki/Dependency_injection](https://en.wikipedia.org/wiki/Dependency_injection)
 
 - Note:
    This solution was done by **Antoine Van Der Lee**, and you can read his article explaining his solution here: [Dependency Injection in Swift using latest Swift features](https://www.avanderlee.com/swift/dependency-injection/).
 
 There are many other solutions out there, like using a 3rd party library, like **Swinject**, but each one coming with it's own risks. So with this solution you don't become dependend on them.
 
 The reason I liked this solution was because it removes the need for big initializers, it's inspired by the SwiftUI @Environment property wrapper and it makes it clear which properties are injected, which can increase readability.
 
 [Previous](@previous)
 [Next](@next)
 */

import Foundation

protocol NetworkProviding {
    func requestData()
}

struct NetworkProvider: NetworkProviding {
    func requestData() {
        print("Data requested using the `NetworkProvider`")
    }
}

struct MockedNetworkProvider: NetworkProviding {
    func requestData() {
        print("Data requested using the `MockedNetworkProvider`")
    }
}

// MARK: Dependency Injection

public protocol InjectionKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

private struct NetworkProviderKey: InjectionKey {
    static var currentValue: NetworkProviding = NetworkProvider()
}

/// Provides access to injected dependencies.
struct InjectedValues {
    
    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
    private static var current = InjectedValues()
    
    // A static subscript for updating the `currentValue` of `InjectionKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    /// A static subscript accessor for updating and references dependencies directly.
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

extension InjectedValues {
    var networkProvider: NetworkProviding {
        get { Self[NetworkProviderKey.self] }
        set { Self[NetworkProviderKey.self] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

// MARK: Testing

struct DataController {
    @Injected(\.networkProvider) var networkProvider: NetworkProviding
    
    func performDataRequest() {
        networkProvider.requestData()
    }
}

var dataController = DataController()
print(dataController.networkProvider) // prints: NetworkProvider()

InjectedValues[\.networkProvider] = MockedNetworkProvider()
print(dataController.networkProvider) // prints: MockedNetworkProvider()

dataController.networkProvider = NetworkProvider()
print(dataController.networkProvider) // prints 'NetworkProvider' as we overwritten the property wrapper wrapped value

dataController.performDataRequest() // prints: Data requested using the 'NetworkProvider'

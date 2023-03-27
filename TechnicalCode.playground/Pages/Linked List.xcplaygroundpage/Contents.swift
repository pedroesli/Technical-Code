/*:
 # Linked List
 A **linked list** is a linear collection of data elements whose order is not given by their physical placement in memory. Instead, *each element points to the next*. It is a data structure consisting of a collection of **nodes** which together represent a sequence.

 [A|  ] → [B|  ] → [C|  ] → nil
 
 **Node**: [|  ]
 
 **Data**: A
 
 **Next**: pointer to next head
 
 [Previous](@previous)
 [Next](@next)
 */
import Foundation

class Node<Element> {
    var data: Element
    var next: Node<Element>?
    
    init(data: Element, next: Node<Element>? = nil) {
        self.data = data
        self.next = next
    }
}

class LinkedList<Element> {
    var count = 0
    var first: Element? {
        firstNode?.data
    }
    var last: Element? {
        var tempNode = firstNode
        while tempNode?.next != nil {
            tempNode = tempNode?.next
        }
        return tempNode?.data
    }
    private var firstNode: Node<Element>? = nil

    func append(_ item: Element) {
        defer {
            count += 1
        }

        if firstNode == nil {
            firstNode = Node(data: item)
            return
        }

        var tempNode = firstNode
        while tempNode?.next != nil {
            tempNode = tempNode?.next
        }
        tempNode?.next = Node(data: item)
    }
    
    func removeFirst() -> Element? {
        guard firstNode != nil else { return nil }
        
        var firstElement = firstNode?.data
        firstNode = firstNode?.next
        count -= 1
        return firstElement
    }
    
    func remove(first: (Element) -> Bool) -> Element? {
        guard firstNode != nil else { return nil }
        
        if first(firstNode!.data) {
            let element = firstNode?.data
            firstNode = firstNode?.next
            return element
        }
        
        var tempNode = firstNode?.next
        var prevNode = firstNode
        while tempNode != nil {
            if first(tempNode!.data) {
                let element = tempNode?.data
                prevNode?.next = tempNode?.next
                return element
            }
            prevNode = tempNode
            tempNode = tempNode?.next
        }
        return nil
    }
    
    func forEach(_ body: (Element) -> Void ) {
        guard firstNode != nil else { return }
        
        var tempNode = firstNode
        repeat {
            body(tempNode!.data)
            tempNode = tempNode?.next
        } while tempNode != nil
    }
    
    func first(at: (Element) -> Bool) -> Element? {
        guard firstNode != nil else { return nil }
        
        var tempNode = firstNode
        repeat {
            if at(firstNode!.data) {
                return firstNode?.data
            }
            tempNode = tempNode?.next
        } while tempNode != nil
        
        return nil
    }
}

extension LinkedList where Element: Equatable {
    func remove(first: Element) {
        guard firstNode != nil else { return }
        
        if firstNode?.data == first {
            firstNode = firstNode?.next
            return
        }
        
        var tempNode = firstNode?.next
        var prevNode = firstNode
        while tempNode != nil {
            if tempNode?.data == first {
                prevNode?.next = tempNode?.next
                return
            }
            prevNode = tempNode
            tempNode = tempNode?.next
        }
    }
}

let list = LinkedList<String>()
list.append("Hello")
list.append(", World!")
list.append(" Pedro")

list.remove(first: ", World!")

list.forEach { item in
    print(item, terminator: "")
}

class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let people = LinkedList<Person>()
people.append(Person(name: "Pedro", age: 25))
people.append(Person(name: "Hellen", age: 23))
people.append(Person(name: "Daneil", age: 12))
people.append(Person(name: "Franklin", age: 33))
people.append(Person(name: "Eduardo", age: 19))
people.append(Person(name: "Gabriel", age: 15))

people.remove { $0.age < 20 }

print()
people.forEach { item in
    print(item.name)
}

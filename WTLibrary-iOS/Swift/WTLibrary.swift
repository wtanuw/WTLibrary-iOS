//
//  WTLibrary.swift
//  Pods
//
//  Created by iMac on 12/16/15.
//
//

import Foundation

//MARK:

//swift 2.0 remove String function
//public func print<T>(object: T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
//    Swift.print("\(file.lastPathComponent.stringByDeletingPathExtension).\(function)[\(line)]: \(object)")
//}

#if DEBUG
    func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
    }
#else
    func dLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {}
#endif

func aLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
}

//MARK:

#if DEBUG
    public func WatLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent!):\(line):\(function)] - \(message)")
    }
#else
    public func WatLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {}
#endif

//MARK:

public extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String? {
        return ns.pathExtension
    }
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
}

//MARK:
public func runAfterDelay(delay: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

//MARK:
public extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil)
        
        return boundingBox.height
    }
}

public extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

//MARK :

public func dispatch_after(seconds:Double, closure: @escaping ()->()) -> (() -> ())? {
    var cancelled = false
    let cancel_closure: () -> () = {
        cancelled = true
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
        if !cancelled {
            closure()
        }
    })
    
    return cancel_closure
}

public func cancel_dispatch_after(cancel_closure: (() -> ())?) {
    cancel_closure?()
}

//MARK:
//class MyClass: CustomStringConvertible, CustomDebugStringConvertible {
//    let foo = 42
////    var description: String { get { return "MyClass, foo = \(foo)" } }
////    var debugDescription: String { get { return "MyClass, foo = \(foo)" } }
////    override var description: String { return "MyClass, foo = \(foo)" }
////    override var debugDescription: String  { return "MyClass, foo = \(foo)" }
//    
//    override var description : String {
//        return "**** PageContentViewController\npageIndex equals \(foo) ****\n"
//    }
//    
//    override var debugDescription : String {
//        return "---- PageContentViewController\npageIndex equals \(foo) ----\n"
//    }
//}
//
//extension foo: CustomStringConvertible {
//    var description: String {
//        return bar
//    }
//}
//struct WorldPeace: CustomStringConvertible {
//    let yearStart: Int
//    let yearStop: Int
//    
//    var description: String {
//        return "\(yearStart)-\(yearStop)"
//    }
//}

//extension String {
//    var pathExtension: String? {
//        return NSURL(fileURLWithPath: self).pathExtension
//    }
//    var lastPathComponent: String? {
//        return NSURL(fileURLWithPath: self).lastPathComponent
//    }
//}

//MARK:

//  RACObserve(object, property) is equivalent to [object rac_valuesForKeyPath:@"property" observer:self].
//  RAC(object, property) = signal is equivalent to [signal setKeyPath:@"property" onObject:object].

// AnyProperty init Value <~ SignalProducer // mutableProperty <~ producer
// AnyProperty init Value <~ Signal // mutableProperty <~ signal
// MutablePropertyType <~ Signal
// MutablePropertyType <~ SignalProducer // property <~ producer.startWithSignal
// MutablePropertyType <~ PropertyType // destinationProperty <~ sourceProperty.producer

//MARK:

//        let (signal, observer) = Signal<Int,NoError>.pipe()
//        observer.sendNext(5)
//        let (producer, sink) = SignalProducer<Int, NoError>.buffer()
//        let producerM = producer
//            .map { (a) -> AnyObject? in
//                a
//        }

//        let (signal, observer) = Signal<Int, NoError>.pipe()
//        signal
//            .reduce(1) { $0 * $1 }
//            .observeNext { next in print(next) }
//
//        observer.sendNext(1)     // Not printed
//        observer.sendNext(2)     // Prints 2
//        observer.sendNext(3)     // Not printed
//        observer.sendNext(4)     // prints 4
//
//
//        signal.observe(Signal.Observer { event in
//            switch event {
//            case let .Next(next):
//                print("Next: \(next)")
//            case let .Failed(error):
//                print("Failed: \(error)")
//            case .Completed:
//                print("Completed")
//            case .Interrupted:
//                print("Interrupted")
//            }
//            })

//MARK:
//We distinguish two kinds of events that you can send through signals - terminating and non-terminating. There are three kinds of terminating events: Failed, Interrupted, Completed, and one non-terminating - Next.
//
//Signals and events
//
//You can either create a pipe with Signal.pipe() that will return signal and observer, or you can create a signal with a closure, inside which you will have access to an observer. Signal is controlled by sending events to given observer. You can subscribe to signal multiple times, and each subscription means, that from this moment you are interested in events that will flow down the stream. However, you will not receive events that were sent before you subscribed. When a terminating event is sent to observer, each signal subscriber is informed about it and observer is disposed. From now on, sending events to observer will take no effect, and each new signal subscriber will receive Interrupted event.
//
//Example:
//
//let (signal, observer) = Signal<Int, NoError>.pipe()
//
//observer.sendNext(1)
//observer.sendNext(2)
//
//signal.observeNext({ (next) in
//    print("observer-1  value: \(next)")
//})
//
//signal.observeNext({ (next) in
//    print("observer-2 value: \(next)")
//})
//
//signal.observeCompleted({
//    print("completed")
//})
//
//signal.observeInterrupted({
//    print("interrupted-1")
//})
//
//observer.sendNext(4)
//observer.sendCompleted()
//
//
//signal.observeNext({ (next) in
//    print(next)
//})
//signal.observeCompleted({
//    print("completed")
//})
//
//signal.observeInterrupted({
//    print("interrupted-2")
//})
//
//signal.observeInterrupted({
//    print("interrupted-3")
//})
//
//observer.sendNext(4)
//observer.sendCompleted()
//In this case, the output will be - observer-1 value: 4, observer-2 value: 4, completed, interrupted-2, interrupted-3. You can see here that we don't receive events before we start observing signal - we miss values 1 and 2. Then, after terminating event is received (completed), we stop receiving any further events and sending values to observer doesn't take effect. However, if we start observing for interrupted event after signal was terminated, we will receive it immediately.
//
//Signal producers and events
//
//There are two ways of creating a signal producer that will provide us with a different overall result. You can either create a producer with a closure that will be invoked for each invocation of start(), this is a good method to receive events from tasks (eg. network request).
//
//On the other hand, you can create a producer with a buffered observer. Buffered observer is a special kind of observer that will remember sent values up to given buffer capacity. However, this does not include terminating events, which are stored separately. From now on, you can send values to buffered observer, and each time you start a signal from a producer, you will first receive values stored in a buffer and then terminating event (if such has been sent to observer before). If there was no terminating event, subscriber of created signal will receive events that are sent to buffered observer. If you send a terminating event to a buffered observer, then all signals started from that signal producer will receive this event and will behave like normal signals (They won't receive any further events). Buffered observer can receive terminating events multiple times, each terminating event will override previous one.
//
//Example:
//
//let (producer, observer) = SignalProducer<Int, NoError>.buffer(3)
//
//observer.sendNext(1)
//observer.sendNext(2)
//observer.sendNext(3)
//observer.sendCompleted()
//
//producer.startWithSignal({ (signal, disposable) in
//    signal.observeNext({ (next) in
//        print(next)
//    })
//    signal.observeCompleted({
//        print("completed")
//    })
//    
//    signal.observeInterrupted({
//        print("interrupted")
//    })
//})
//
//observer.sendNext(4)
//observer.sendInterrupted()
//
//producer.startWithSignal({ (signal, disposable) in
//    signal.observeNext({ (next) in
//        print(next)
//    })
//    signal.observeCompleted({
//        print("completed")
//    })
//    
//    signal.observeInterrupted({
//        print("interrupted")
//    })
//})
//In this case, the output will be - 1, 2, 3, completed, 2, 3, 4, interrupted. You can see here that interrupted event overrides completed, and output is different next time that we start a signal from a producer.

//MARK:

prefix operator √
prefix func √ (number: Double) -> Double {
    return sqrt(number)
}

infix operator ± { associativity left precedence 140 }
func ± (left: Double, right: Double) -> (Double, Double) {
    return (left + right, left - right)
}

prefix operator ±
prefix func ± (value: Double) -> (Double, Double) {
    return 0 ± value
}

//MARK:

// Array<Element> -> Dictionary<U:[Element]>
public extension Sequence {
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    func categorise<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
// Dictionary<U:[Element] -> Array<[Element]>
public extension Dictionary {
    func group(_ keyFunc: @escaping (_ value1: Key, _ value2: Key) -> Bool) -> [Value] {
        var array: [Value] = []
        let keys = self.keys
        let sortKey = keys.sorted (by: { (aa, bb) -> Bool in
            return keyFunc(aa, bb)
        })
        for key in sortKey {
            let value = self[key]!
            array += [value]
        }
        return array
    }
}

public extension Dictionary {
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    
}

// Dictionary += Dictionary
public func += <K, V>(left: inout Dictionary<K, V>, right: Dictionary<K, V>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

// Dictionary + Dictionary
public func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

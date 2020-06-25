//
//  Coutelas.swift
//  Coutelas
//
//  Created by Laurent on 24/06/2020.
//  Copyright © 2020 ljeanjean. All rights reserved.
//

import Foundation

public final class Coutelas {
    typealias InstanceContainer = [ObjectIdentifier: Any]
    public typealias BlockLoader<T> = () -> T
    
    private var mainContainer = InstanceContainer()
    private var contextualizedContainers = [String: InstanceContainer]()
    
    public static var shared = { Coutelas() }()
    
    public func load<T>(_ closure: BlockLoader<T>) {
        load(nil, closure)
    }
    
    public func load<T>(_ context: String?, _ closure: BlockLoader<T>) {
        if let context = context {
            contextualizedLoad(context, closure)
        } else {
            mainLoad(closure)
        }
    }
    
    public func unloadAll() {
        mainContainer = InstanceContainer()
        contextualizedContainers = [String: InstanceContainer]()
    }
    
    public func unload(context: String) {
        contextualizedContainers[context] = InstanceContainer()
    }
    
    public func retrieve<T>(_ type: T.Type = T.self, _ context: String? = nil) -> T? {
        let container: InstanceContainer?
        
        if let context = context {
            container = contextualizedContainers[context]
        } else {
            container = mainContainer
        }
        
        return container?[ObjectIdentifier(T.self)] as? T
    }
}

// Class method
extension Coutelas {
    public static func load<T>(_ closure: BlockLoader<T>) {
        shared.load(nil, closure)
    }
    
    public static func load<T>(_ context: String?, _ closure: BlockLoader<T>) {
        shared.load(context, closure)
    }
    
    public static func unloadAll() {
        shared.unloadAll()
    }
    
    public static func unload(context: String) {
        shared.unload(context: context)
    }
    
    public static func retrieve<T>(_ type: T.Type = T.self, _ context: String? = nil) -> T? {
        return shared.retrieve(type, context)
    }
}

private extension Coutelas {
    func contextualizedLoad<T>(_ context: String, _ closure: () -> T) {
        let instance = closure()
        let identifier = ObjectIdentifier(T.self)
        
        var container = contextualizedContainers[context] ?? InstanceContainer()
        container[identifier] = instance
        contextualizedContainers[context] = container
    }
    
    func mainLoad<T>(_ closure: BlockLoader<T>) {
        let instance = closure()
        let identifier = ObjectIdentifier(T.self)
        
        mainContainer[identifier] = instance
    }
}

@propertyWrapper
public struct Inject<T> {
    private var instance: T

    public init(context: String? = nil, coutelas: Coutelas? = nil) {
        guard let coutelas = coutelas else {
            instance = Coutelas.retrieve(T.self, context)!
            return
        }
        
        instance = coutelas.retrieve(T.self, context)!
    }
    
    public var wrappedValue: T {
        get { return instance }
        mutating set { instance = newValue }
    }
}

@propertyWrapper
public struct InjectOptional<T> {
    private var instance: T?

    public init(context: String? = nil, coutelas: Coutelas? = nil) {
        guard let coutelas = coutelas else {
            instance = Coutelas.retrieve(T.self, context)
            return
        }
        
        instance = coutelas.retrieve(T.self, context)
    }
    
    public var wrappedValue: T? {
        get { return instance }
        mutating set { instance = newValue }
    }
}

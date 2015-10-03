//
//  Balsa.swift
//  Balsa
//
//  Created by jacob berkman on 2015-10-02.
//  Copyright © 2015 jacob berkman. All rights reserved.
//

import CoreData
import Foundation

public let errorDomain = "Balsa.errorDomain"

public let entityNotFoundError = 1

public protocol ModelNaming {
    static var modelName: String { get }
}

public protocol ModelControlling {
    typealias Model
    var model: Model? { get }
}

public protocol MutableModelControlling: ModelControlling {
    typealias Model
    var model: Model? { get set }
}

public protocol ModelSelecting {
    typealias Model
    var selectedModel: Model? { get }
}

public protocol MutableModelSelecting: ModelSelecting {
    var selectedModel: Model? { get set }
}

public protocol ModelMultipleSelecting {
    typealias Model: Hashable
    var maximumSelectionCount: Int { get }
    var selectedModels: Set<Model> { get }
}

public protocol MutableModelMultipleSelecting: ModelMultipleSelecting {
    var maximumSelectionCount: Int { get set }
    var selectedModels: Set<Model> { get set }
}

public protocol Predicating {
    var predicate: NSPredicate? { get set }
}

public protocol MutablePredicating: Predicating {
    var predicate: NSPredicate? { get set }
}

extension ModelNaming {
    public var modelName: String { return self.dynamicType.modelName }
}

extension ModelNaming where Self: NSManagedObject {

    public init(insertIntoManagedObjectContext managedObjectContext: NSManagedObjectContext) throws {
        guard let entity = NSEntityDescription.entityForName(Self.modelName, inManagedObjectContext: managedObjectContext) else {
            throw NSError(domain: errorDomain, code: entityNotFoundError, userInfo: nil)
        }
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    public static func countInContext(managedObjectContext: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
        let fetchRequest = NSFetchRequest(entityName: modelName)
        fetchRequest.predicate = predicate
        let result = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        return result == NSNotFound ? 0 : result
    }

    public static func existsInContext(managedObjectContext: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Bool {
        return countInContext(managedObjectContext, predicate: predicate) > 1
    }
    
}

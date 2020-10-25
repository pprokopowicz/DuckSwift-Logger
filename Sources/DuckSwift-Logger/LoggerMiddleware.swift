//
//  LoggerMiddleware.swift
//
//
//  Created by Piotr Prokopowicz on 02/10/2020.
//

import Foundation
import DuckSwift

/// Middleware that logs information about  incoming actions.
public struct LoggerMiddleware: Middleware {
    
    /// Enum that gives `LoggerMiddleware` information on what user wants to log.
    public enum Element {
        /// Responsible for logging date of an event. Example "2020-10-02 17:44:37 +0000".
        case date
        /// Responsible for logging name of this library. Can be used to filter logs in the console.
        case libraryName
        /// Responsible for logging current application state. Example "- State: AppState(counter: 0)".
        case state
        /// Responsible for logging incoming actions. Example "- Action: IncrementAction()".
        case action
        /// Added to give the ability to log actions and state in a custom way. Just provide a closure that will return a `String` with log.
        case custom(log: (_ action: Action, _ state: StateProtocol?) -> String)
        
        fileprivate func logValue(action: Action, state: StateProtocol?) -> String {
            switch self {
            case .date:
                return "\(Date())"
            case .libraryName:
                return "DucksSwift"
            case .state:
                if let state = state {
                    return "- State: \(state)"
                } else {
                    return "- State: nil"
                }
            case .action:
                return "- Action: \(action)"
            case .custom(let log):
                return log(action, state)
            }
        }
    }
    
    private let logElements: [Element]
    
    /// Initializes the middleware with information on what the user wants to log to console.
    ///
    /// - Parameter elements: Array of `Element` enum. Based on values in this array information is being logged. Order and duplication of values does matter.
    public init(elements: [Element] = [.date, .libraryName, .state, .action]) {
        logElements = elements
    }
    
    public func body(dispatch: @escaping DispatchFunction, state: @escaping GetState) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                let log = logElements
                    .compactMap {
                        $0.logValue(action: action, state: state())
                    }
                    .joined(separator: " ")
                #if DEBUG
                print(log)
                #endif
                next(action)
            }
        }
    }
    
}

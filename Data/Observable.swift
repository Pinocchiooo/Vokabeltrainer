//
//  Observable.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import Foundation

class ObservationToken: Equatable, Hashable {
    static func == (lhs: ObservationToken, rhs: ObservationToken) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var hashValue: Int {
        return self.uuid.hashValue
    }

    private var _valid = true
    var valid: Bool {
        return _valid
    }

    var queue = DispatchQueue.main

    private var uuid = UUID()

    /// Invalidate this token to stop observation and enable memory cleanup.
    func invalidate() {
        _valid = false
        validationChanged?(false)
    }

    fileprivate var validationChanged: ((Bool) -> Void)?
}

protocol Observable: AnyObject {
    associatedtype Observed

    var observers: [ObservationToken: (Observed) -> Void] { get set}
}

extension Observable {
    /// Method to call when any changes should communicated to observers
    ///
    /// - Parameter value: The new value
    func informObservers(_ value: Observed) {
        invalidateObservers()
        observers.forEach { token, obs in
            token.queue.async {
                obs(value)
            }
        }
    }

    /// Start observing this object for any changes
    ///
    /// - Parameter callback: Callback that gets called on any given change
    /// - Returns: Token to invalidate when observation should stop.
    ///            In any case it should at least be called in `deinit`
    func observe(
        do callback: @escaping (Observed) -> Void,
        on queue: DispatchQueue = DispatchQueue.main) -> ObservationToken {
        let token = ObservationToken()
        token.queue = queue
        token.validationChanged = { [weak self] _ in
            self?.invalidateObservers()
        }
        self.observers[token] = callback
        return token
    }

    private func invalidateObservers() {
        observers = observers.filter { token, _ in token.valid }
    }
}

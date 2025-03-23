//
//  Injection.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import Foundation

protocol DIContainerProtocol {
    func register<Service>(type: Service.Type, component: Any)
    func inject<Service>(type: Service.Type) -> Service
}

final class DIContainer: DIContainerProtocol {
    
    static let shared = DIContainer()
    
    private init() {}
    
    var services: [String: Any] = [:]
    
    func register<Service>(type: Service.Type, component service: Any) {
        services["\(type)"] = service
    }
    
    func inject<Service>(type: Service.Type) -> Service {
        guard let service = services["\(type)"] as? Service else { fatalError("Invalid Injection")}
        return service
    }
}

extension DIContainer {
    func registration() {
        register(type: MusicRemoteProtocol.self, component: MusicRemote())
        register(type: MusicUseCaseProtocol.self, component: MusicUseCase())
    }
}

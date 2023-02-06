//
//  IntentHandler.swift
//  ConfigurationWidgetIntent
//
//  Created by Fadey Notchenko on 06.02.2023.
//

import Intents

class IntentHandler: INExtension, ConfigurationWidgetIntentHandling {
    
    func provideParameterOptionsCollection(for intent: ConfigurationWidgetIntent, with completion: @escaping (INObjectCollection<TargetWidget>?, Error?) -> Void) {
        
        guard let ud = UserDefaults(suiteName: Constants.appGroup) else { return }
        
        guard let data = ud.object(forKey: "targets") as? Data else { return }
        
        if let arr = arrayOfTargetWidgetsFromData(data: data) {
            let objects = arr.map { TargetWidget(identifier: $0.id, display: $0.name) }
            
            completion(INObjectCollection(items: objects), nil)
        }
        
        completion(nil, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

//
//  Human.swift
//  vk
//
//  Created by Al Stark on 10.05.2023.
//

import Foundation

final class Human {
   
    
    let globalBackgroundSyncronizeDataQueue = DispatchQueue(label: "fdfd")
    var sick = false
    var isSick: Bool {
        set(newValue){
            globalBackgroundSyncronizeDataQueue.sync(){
                self.sick = newValue
            }
        }
        get{
            return globalBackgroundSyncronizeDataQueue.sync{
                sick
            }
        }
    }
}

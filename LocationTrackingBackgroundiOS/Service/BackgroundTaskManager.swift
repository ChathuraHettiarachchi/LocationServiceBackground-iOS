//
//  BackgroundTaskManager.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/5/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import Foundation

class BackgroundTaskManager:NSObject{
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    override init(){
        super.init()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
}

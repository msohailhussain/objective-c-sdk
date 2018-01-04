//
//  OPTLYActivateNotification.h
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPTLYExperiment, OPTLYVariation;

@protocol OPTLYNotificationListener <NSObject>
/**
 * This is the method of notification.  Implementation classes such as {@link com.optimizely.ab.notification.ActivateNotification}
 * will implement this call and provide another method with the correct parameters
 * Notify called when a notification is triggered via the {@link com.optimizely.ab.notification.NotificationCenter}
 * @param args - variable argument list based on the type of notification.
 */
- (void)notify:(id)firstArg, ...;
@end

@interface OPTLYActivateNotification : NSObject <OPTLYNotificationListener>
/**
 * onActivate called when an activate was triggered
 * @param experiment - The experiment object being activated.
 * @param userId - The userId passed into activate.
 * @param attributes - The filtered attribute list passed into activate
 * @param variation - The variation that was returned from activate.
 * @param event - The impression event that was triggered.
 */
- (void)onActivate:(OPTLYExperiment *)experiment
            userId:(NSString *)userId
        attributes:(NSDictionary<NSString *,NSString *> *)attributes
         variation:(OPTLYVariation *)variation
             event:(NSDictionary<NSString *,NSString *> *)event;

@end



//
//  OPTLYNotificationListener.h
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OPTLYNotificationListener <NSObject>
/**
 * This is the method of notification.  Implementation classes such as OPTLYActivateNotification
 * will implement this call and provide another method with the correct parameters
 * Notify called when a notification is triggered via the OPTLYNotificationCenter
 * @param firstArg - variable argument list based on the type of notification.
 */
- (void)notify:(id)firstArg otherArgs:(va_list)args;
@end

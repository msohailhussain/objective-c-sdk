//
//  OPTLYNotificationCenter.h
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 02/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Enum representing notification types.
typedef NS_ENUM(NSUInteger, OPTLYNotificationType) {
    OPTLYNotificationTypeActivate,
    OPTLYNotificationTypeTrack
};

@interface OPTLYNotificationCenter : NSObject

/// <summary>
/// Fire notifications of specified notification type when the event gets triggered.
/// </summary>
/// <param name="notificationType">The notification type</param>
/// <param name="args">Arguments to pass in notification callbacks</param>
//- (void)sendNotifications:(OPTLYNotificationType)notificationType params object[] args)
//{
//    foreach (var notification in Notifications[notificationType])
//    {
//        try
//        {
//            Delegate d = notification.Value as Delegate;
//            d.DynamicInvoke(args);
//        }
//        catch (Exception exception)
//        {
//            Logger.Log(LogLevel.ERROR, "Problem calling notify callback. Error: " + exception.Message);
//        }
//    }
//}

@end

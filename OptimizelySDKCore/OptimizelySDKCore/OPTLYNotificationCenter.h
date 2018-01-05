//
//  OPTLYNotificationCenter.h
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 02/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPTLYActivateNotification, OPTLYTrackNotification;
@protocol OPTLYNotificationListener;

/// Enum representing notification types.
typedef NS_ENUM(NSUInteger, OPTLYNotificationType) {
    OPTLYNotificationTypeActivate,
    OPTLYNotificationTypeTrack
};

typedef NSMutableDictionary<NSNumber *, id<OPTLYNotificationListener> > OPTLYNotificationHolder;

@interface OPTLYNotificationCenter : NSObject

// Notification Id represeting id of notification.
@property (nonatomic, readonly) NSUInteger notificationId;
// notification Count represeting total number of notifications.
@property (nonatomic, readonly) NSUInteger notificationsCount;

/**
 * Add an activate notification listener to the notification center.
 *
 * @param type - enum OPTLYNotificationType to add.
 * @param activateListener - Notification to add.
 * @return the notification id used to remove the notification. It is greater than 0 on success.
 */
- (NSInteger)addNotification:(OPTLYNotificationType)type activateListener:(OPTLYActivateNotification *)activateListener;

/**
 * Add a track notification listener to the notification center.
 *
 * @param type - enum OPTLYNotificationType to add.
 * @param trackListener - Notification to add.
 * @return the notification id used to remove the notification. It is greater than 0 on success.
 */
- (NSInteger)addNotification:(OPTLYNotificationType)type trackListener:(OPTLYTrackNotification *)trackListener;

/**
 * Remove the notification listener based on the notificationId passed back from addNotification.
 * @param notificationId the id passed back from add notification.
 * @return true if removed otherwise false (if the notification is already removed, it returns false).
 */
- (BOOL)removeNotification:(NSUInteger)notificationId;

/**
 * Clear notification listeners by notification type.
 * @param type type of OPTLYNotificationType to remove.
 */
- (void)clearNotifications:(OPTLYNotificationType)type;

/**
 * Clear out all the notification listeners.
 */
- (void)clearAllNotifications;

//
/**
 * fire notificaitons of a certain type.
 * @param type type of OPTLYNotificationType to fire.
 * @param firstArg The arg list changes depending on the type of notification sent.
 */
- (void)sendNotifications:(OPTLYNotificationType)type args:(id)firstArg, ...;
@end

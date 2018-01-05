//
//  OPTLYTrackNotification.h
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPTLYNotificationListener.h"

@interface OPTLYTrackNotification : NSObject <OPTLYNotificationListener>
/**
 * onTrack is called when a track event is triggered
 * @param eventKey - The event key that was triggered.
 * @param userId - user id passed into track.
 * @param attributes - filtered attributes list after passed into track
 * @param eventTags - event tags if any were passed in.
 * @param event - The event being recorded.
 */
- (void)onTrack:(NSString *)eventKey
         userId:(NSString *)userId
     attributes:(NSDictionary<NSString *,NSString *> *)attributes
      eventTags:(NSDictionary *)eventTags
          event:(NSDictionary<NSString *,NSString *> *)event;

@end

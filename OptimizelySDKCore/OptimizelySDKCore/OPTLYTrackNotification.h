/****************************************************************************
 * Copyright 2018, Optimizely, Inc. and contributors                        *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 *    http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 ***************************************************************************/

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

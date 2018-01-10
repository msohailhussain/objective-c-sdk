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

#import "OPTLYTrackNotification.h"

@implementation OPTLYTrackNotification

- (void)notify:(id)firstArg otherArgs:(va_list)args {
    
    NSString *eventKey = (NSString *)firstArg;
    assert(eventKey);
    assert([eventKey isKindOfClass:[NSString class]]);
    
    NSString *userId = va_arg(args, NSString *);
    assert(userId);
    assert([userId isKindOfClass:[NSString class]]);
    
    NSDictionary *attributes = va_arg(args, NSDictionary *);
    assert(attributes);
    assert([attributes isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *eventTags = va_arg(args, NSDictionary *);
    assert(eventTags);
    assert([eventTags isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *logEvent = va_arg(args, NSDictionary *);
    assert(logEvent);
    assert([logEvent isKindOfClass:[NSDictionary class]]);
    
    va_end(args);
    
    [self onTrack:eventKey userId:userId attributes:attributes eventTags:eventTags event:logEvent];
}

-(void)onTrack:(NSString *)eventKey userId:(NSString *)userId attributes:(NSDictionary<NSString *,NSString *> *)attributes eventTags:(NSDictionary *)eventTags event:(NSDictionary<NSString *,NSString *> *)event {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end

//
//  OPTLYTrackNotification.m
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

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

//
//  OPTLYTrackNotification.m
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

#import "OPTLYTrackNotification.h"

@implementation OPTLYTrackNotification

- (void)notify:(id)firstArg, ... {
    
    va_list args;
    va_start(args, firstArg);
    
    id arg = firstArg;
    assert([arg isMemberOfClass:[NSString class]]);
    NSString *eventKey = (__bridge NSString *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[NSString class]]);
    NSString *userId = (__bridge NSString *)args;
    
    arg = va_arg(args, id);
    NSDictionary<NSString *,NSString *> *strToStrMap;
    assert([arg isMemberOfClass:[strToStrMap class]]);
    NSDictionary<NSString *,NSString *> *attributes = (__bridge NSDictionary<NSString *,NSString *> *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[NSDictionary class]]);
    NSDictionary *eventTags = (__bridge NSDictionary *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[strToStrMap class]]);
    NSDictionary<NSString *,NSString *> *logEvent = (__bridge NSDictionary<NSString *,NSString *> *)args;
    
    va_end(args);
    
    [self onTrack:eventKey userId:userId attributes:attributes eventTags:eventTags event:logEvent];
}

-(void)onTrack:(NSString *)eventKey userId:(NSString *)userId attributes:(NSDictionary<NSString *,NSString *> *)attributes eventTags:(NSDictionary *)eventTags event:(NSDictionary<NSString *,NSString *> *)event {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end

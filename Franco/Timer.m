//
//  Timer.m
//  Franco
//
//  Created by Katherine Owens on 4/17/17.
//  Copyright © 2017 Katherine Owens. All rights reserved.
//

#import "Timer.h"

@implementation Timer : UIApplication


- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *) [allTouches anyObject]).phase;
        
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
            [self resetTimer];
        }
    }
}
- (void)resetTimer {
    if (self.idleTimer) {
        [self.idleTimer invalidate];
       // [self.idleTimer release];
    }
    
    
    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    
}

- (void)idleTimerExceeded {
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"appInactiveNotification" object:nil];
}


@end

//
//  BackgroundTask.m
//  Copyright (c) 2014 Lee Crossley - http://ilee.co.uk
//

#import "Cordova/CDV.h"
#import "Cordova/CDVViewController.h"
#import "BackgroundTask.h"

static UIBackgroundTaskIdentifier backgroundTaskId;

@implementation BackgroundTask

+ (void) initialize {
    backgroundTaskId = UIBackgroundTaskInvalid;
}

- (void) start:(CDVInvokedUrlCommand*)command {

	[self.commandDelegate runInBackground:^{
        backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
            backgroundTaskId = UIBackgroundTaskInvalid;
        }];
        // Double should be large enough to accomodate UIBackgroundTaskIdentifier
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:backgroundTaskId];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}

- (void) finish:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
        NSNumber* task = [command argumentAtIndex:0];
        CDVPluginResult* pluginResult;
        
        if([task isKindOfClass:NSNumber.class]) {
            UIBackgroundTaskIdentifier taskId = task.unsignedIntegerValue;
            [[UIApplication sharedApplication] endBackgroundTask:taskId];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid argument, integer expected."];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


@end

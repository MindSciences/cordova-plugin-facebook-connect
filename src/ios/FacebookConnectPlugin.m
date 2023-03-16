//
//  FacebookConnectPlugin.m
//  GapFacebookConnect
//
//  Created by Jesse MacFadyen on 11-04-22.
//  Updated by Mathijs de Bruin on 11-08-25.
//  Updated by Christine Abernathy on 13-01-22
//  Updated by Jeduan Cornejo on 15-07-04
//  Updated by Eds Keizer on 16-06-13
//  Copyright 2011 Nitobi, Mathijs de Bruin. All rights reserved.
//

#import "FacebookConnectPlugin.h"
#import <objc/runtime.h>

@interface FacebookConnectPlugin ()

@property (strong, nonatomic) NSString* dialogCallbackId;
@property (strong, nonatomic) FBSDKLoginManager *loginManager;
@property (nonatomic, assign) FBSDKLoginTracking *loginTracking;
@property (strong, nonatomic) NSString* gameRequestDialogCallbackId;
@property (nonatomic, assign) BOOL applicationWasActivated;

- (void)enableHybridAppEvents;
@end

@implementation FacebookConnectPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Facebook Connect plugin");

    // Add notification listener for tracking app activity with FB Events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(handleOpenURLWithAppSourceAndAnnotation:)
                                             name:CDVPluginHandleOpenURLWithAppSourceAndAnnotationNotification object:nil];
}

- (void) applicationDidFinishLaunching:(NSNotification *) notification {
    NSDictionary* launchOptions = notification.userInfo;
    if (launchOptions == nil) {
        //launchOptions is nil when not start because of notification or url open
        launchOptions = [NSDictionary dictionary];
    }

    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void) applicationDidBecomeActive:(NSNotification *) notification {
    if (FBSDKSettings.sharedSettings.isAutoLogAppEventsEnabled) {
        [FBSDKAppEvents.shared activateApp];
    }
    if (self.applicationWasActivated == NO) {
        self.applicationWasActivated = YES;
        [self enableHybridAppEvents];
    }
}

- (void) handleOpenURLWithAppSourceAndAnnotation:(NSNotification *) notification {
    NSMutableDictionary * options = [notification object];
    NSURL* url = options[@"url"];

    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] openURL:url options:options];
}

#pragma mark - Cordova commands

- (void)setAdvertiserTrackingEnabled:(CDVInvokedUrlCommand *)command {
    BOOL enabled = [[command argumentAtIndex:0] boolValue];
    [FBSDKSettings.sharedSettings setAdvertiserTrackingEnabled:enabled];
    [self returnGenericSuccess:command.callbackId];
}

- (void)logEvent:(CDVInvokedUrlCommand *)command {
    if ([command.arguments count] == 0) {
        // Not enough arguments
        [self returnInvalidArgsError:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        // For more verbose output on logging uncomment the following:
        [FBSDKSettings.sharedSettings setLoggingBehaviors:[NSSet setWithObject:FBSDKLoggingBehaviorAppEvents]];
        NSString *eventName = [command.arguments objectAtIndex:0];
        NSDictionary *params;
        double value;

        if ([command.arguments count] == 1) {
            [FBSDKAppEvents.shared logEvent:eventName];

        } else {
            // argument count is not 0 or 1, must be 2 or more
            params = [command.arguments objectAtIndex:1];
            if ([command.arguments count] == 2) {
                // If count is 2 we will just send params
                [FBSDKAppEvents.shared logEvent:eventName parameters:params];
            }

            if ([command.arguments count] >= 3) {
                // If count is 3 we will send params and a value to sum
                value = [[command.arguments objectAtIndex:2] doubleValue];
                [FBSDKAppEvents.shared logEvent:eventName valueToSum:value parameters:params];
            }
        }
        [self returnGenericSuccess:command.callbackId];
    }];
}

#pragma mark - Utility methods

- (void) returnGenericSuccess:(NSString *)callbackId {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void) returnInvalidArgsError:(NSString *)callbackId {
    CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid arguments"];
    [self.commandDelegate sendPluginResult:res callbackId:callbackId];
}

/*
 * Enable the hybrid app events for the webview.
 */
- (void)enableHybridAppEvents {
    if ([self.webView isMemberOfClass:[WKWebView class]]){
        NSString *is_enabled = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookHybridAppEvents"];
        if([is_enabled isEqualToString:@"true"]){
            [FBSDKAppEvents.shared augmentHybridWebView:(WKWebView*)self.webView];
            NSLog(@"FB Hybrid app events are enabled");
        } else {
            NSLog(@"FB Hybrid app events are not enabled");
        }
    } else {
        NSLog(@"FB Hybrid app events cannot be enabled, this feature requires WKWebView");
    }
}

# pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (!self.dialogCallbackId) {
        return;
    }

    CDVPluginResult *pluginResult;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsDictionary:results];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dialogCallbackId];
    self.dialogCallbackId = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (!self.dialogCallbackId) {
        return;
    }

    CDVPluginResult *pluginResult;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                     messageAsString:[NSString stringWithFormat:@"Error: %@", error.description]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dialogCallbackId];
    self.dialogCallbackId = nil;
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (!self.dialogCallbackId) {
        return;
    }

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                      messageAsString:@"User cancelled."];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dialogCallbackId];
    self.dialogCallbackId = nil;
}

@end


#pragma mark - AppDelegate Overrides

@implementation AppDelegate (FacebookConnectPlugin)

void FBMethodSwizzle(Class c, SEL originalSelector) {
    NSString *selectorString = NSStringFromSelector(originalSelector);
    SEL newSelector = NSSelectorFromString([@"swizzled_" stringByAppendingString:selectorString]);
    SEL noopSelector = NSSelectorFromString([@"noop_" stringByAppendingString:selectorString]);
    Method originalMethod, newMethod, noop;
    originalMethod = class_getInstanceMethod(c, originalSelector);
    newMethod = class_getInstanceMethod(c, newSelector);
    noop = class_getInstanceMethod(c, noopSelector);
    if (class_addMethod(c, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSelector, method_getImplementation(originalMethod) ?: method_getImplementation(noop), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)load
{
    FBMethodSwizzle([self class], @selector(application:openURL:options:));
}

- (BOOL)swizzled_application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (!url) {
        return NO;
    }
    // Required by FBSDKCoreKit for deep linking/to complete login
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:[options valueForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] annotation:0x0];

    // NOTE: Cordova will run a JavaScript method here named handleOpenURL. This functionality is deprecated
    // but will cause you to see JavaScript errors if you do not have window.handleOpenURL defined:
    // https://github.com/Wizcorp/phonegap-facebook-plugin/issues/703#issuecomment-63748816
    NSLog(@"FB handle url using application:openURL:options: %@", url);

    // Call existing method
    return [self swizzled_application:application openURL:url options:options];
}

- (BOOL)noop_application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return NO;
}
@end

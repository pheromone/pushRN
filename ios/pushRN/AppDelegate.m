/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "RNUMConfigure.h"
#import <UMPush/UMessage.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  /*------------------友盟-----------------------*/
  [UMConfigure setLogEnabled:YES];
  [RNUMConfigure initWithAppkey:@"XXXXXXXXXXXXXXXXXX1" channel:@"App Store"];
  
  //友盟推送
  UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
  //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
  entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
  [UNUserNotificationCenter currentNotificationCenter].delegate=self;
  [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
    }else{
    }
  }];
  
  if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  }
  else {
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
  }
  
  
  /*------------------友盟-----------------------*/
  
  
  NSURL *jsCodeLocation;
  
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"pushRN"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

// iOS 10以上
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
  NSDictionary * userInfo = notification.request.content.userInfo;
  NSLog(@"iOS 10以上%@",userInfo);
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //应用处于前台时的远程推送接受
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    
  }else{
    //应用处于前台时的本地推送接受
  }
  //当应用处于前台时提示设置，需要哪个可以设置哪一个
  if (@available(iOS 10.0, *)) {
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
  } else {
    // Fallback on earlier versions
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveNotification" object:userInfo];
}
// 收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  NSLog(@"iOS外部 %@",userInfo);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveNotification" object:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
  NSLog(@"iOS 10以下%@",userInfo);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveNotification" object:userInfo];
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSLog(@"deviceToken==%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""]);
  [UMessage registerDeviceToken:deviceToken];
}

@end

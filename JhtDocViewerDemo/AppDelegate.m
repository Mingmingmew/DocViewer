//
//  AppDelegate.m
//  JhtDocViewerDemo
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/24.
//  Copyright © 2016年 Jht. All rights reserved.
//

#import "AppDelegate.h"
#import "DocListViewController.h"
#import "JhtNetworkCheckTools.h"

@interface AppDelegate () {
    UINavigationController *_nav;
}

@end


#define OpenFileName0 @"2.pptx"
#define OpenFileName1 @"1.xlsx"
#define OpenFileName2 @"CIImage.docx"
#define OpenFileName3 @"信鸽推送说明书.pdf"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 开启网络监听
    [[JhtNetworkCheckTools sharedInstance] netStartNetworkNotifyWithPollingInterval:3.0];
    
    // 模拟将 本地文件 的保存到 内存中
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"first"]) {
        // 模拟将 本地文件 的保存到 内存中
        [self copyLocalFile:OpenFileName0];
        [self copyLocalFile:OpenFileName1];
        [self copyLocalFile:OpenFileName2];
        [self copyLocalFile:OpenFileName3];
        [def setObject:@"1" forKey:@"first"];
        [def synchronize];
    }
    DocListViewController *vc = [[DocListViewController alloc] init];
    _nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = _nav;
    
    // 三方跳转
    if (launchOptions) {
        NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
        //返回的url， 转换成nsstring
        NSString *appfilePath =[[[url description] componentsSeparatedByString:@"file:///private"] lastObject];
        appfilePath = [appfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DocListViewController *doc = [[DocListViewController alloc] init];
        doc.appFilePath = appfilePath;
        [_nav pushViewController:doc animated:YES];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
//        NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
        // 返回的url， 例如这样；
//    	@"file:///private/var/mobile/Containers/Data/Application/A2E0485F-1341-48A3-BD40-6D09CB8559F5/Documents/Inbox/2-6.pptx"
        // 返回的url， 转换成nsstring;
        NSString *appfilePath = [[[url description] componentsSeparatedByString:@"file:///private"] lastObject];
        appfilePath = [appfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"appfilePath:%@", appfilePath);
        DocListViewController *doc = [[DocListViewController alloc] init];
        doc.appFilePath = appfilePath;
        [_nav pushViewController:doc animated:YES];
    }
    return YES;
}


#pragma mark - 模拟将 本地文件 的保存到 内存中
/** 模拟将 本地文件 的保存到 内存中 （如果以后是网络就可以将网络请求下来的保存到 内存中，然后从内存中读取） */
- (void)copyLocalFile:(NSString *)fileName {
    NSError *error;
    // 储存方式
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/JhtDoc/%@", fileName]];
//    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:self.fileName];
    NSLog(@"path:%@", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        // 创建目录
        [fileManager createDirectoryAtPath:[path componentsSeparatedByString:[NSString stringWithFormat:@"/%@",fileName]][0]  withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSString *filename = [fileName componentsSeparatedByString:@"."][0];
        NSString *type = [fileName componentsSeparatedByString:@"."][1];
        
        NSString *bundle = [[NSBundle mainBundle] pathForResource:filename ofType:type];
        
        // 用nsdata保存到内存
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:bundle];
        [fileData writeToFile:path atomically:YES];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end


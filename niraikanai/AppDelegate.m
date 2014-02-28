//
//  AppDelegate.m
//  niraikanai
//
//  Created by SMARTTECNO. on 2014/02/23.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "AppDelegate.h"
#import "SqlManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //データベース前処理
    [SqlManager InitialSql];
    
    // 通知のリセット
    application.applicationIconBadgeNumber = 0;
    
    // push通知呼び出し用
    [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|
                                                      UIRemoteNotificationTypeSound|
                                                      UIRemoteNotificationTypeAlert)];
    //トピック初期化
    [Configuration synchronize];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        // iOS7移行の設定
        //ナビゲーションのバック画像設定
        [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
        UIImage *image = [UIImage imageNamed:@"navibar_320x64.png"];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
    }else{
        // iOS7以下の設定
        //ナビゲーションのバック画像設定
        UIImage *image = [UIImage imageNamed:@"navibar_320x44.png"];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    //起動方法振り分け（初期起動・パスワード有り起動・パスワード無し起動）
    if([Configuration getFirstStart]){
        //初期起動の場合
        UIViewController *mainViewController = (UIViewController *)self.window.rootViewController;
        UIViewController *GaidViewController = [mainViewController.storyboard instantiateViewControllerWithIdentifier:@"FirstGaidView"];
        self.window.rootViewController = GaidViewController;
        [self.window makeKeyAndVisible];
        return YES;
    }else{
        //起動View変更
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 終了処理
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 通知のリセット
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// デバイストークン取得成功
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // デバイストークンの両端の「<>」を取り除く
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    // デバイストークン中の半角スペースを除去する
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sendProviderDeviceToken:deviceTokenString];
}

// デバイストークン取得失敗
- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError*)err
{
    NSLog(@"Error in registration: %@", err);
    
    // デバイストークン取得確認
    if([[Configuration getDeviceTokenKey] isEqualToString:@""]){
        // デバイストークン取得エラー表示
#if DEBUG
#else
/*
        errAlert_exit = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_API_NotConnectTitleMsg",@"")
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Dialog_API_NotConnectMsg",@"")
                                         otherButtonTitles:nil];
        [errAlert_exit show];
*/
#endif
    }else{
        // デバイストークンからユーザー情報取得
        NSString *str_URL = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_UserGetURL",@""), [Configuration getDeviceTokenKey]];
        NSURL *URL_STRING = [NSURL URLWithString:str_URL];
        NSMutableURLRequest *dev_request = [NSMutableURLRequest requestWithURL:URL_STRING];
        [NSURLConnection connectionWithRequest:dev_request delegate:self];
    }
}

- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"didRegisterForRemoteNotificationsWithError; error: %@", err);
}

// デバイストークンの登録
- (void)sendProviderDeviceToken:(NSString *)deviceToken
{
    // デバイストークン保存(アプリ用)
    [Configuration setDeviceTokenKey:deviceToken];
    
    NSLog(@"取得デバイストークンキー＿%@",deviceToken);
    
    // デバイストークン保存(サーバー用)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), @"/apns_devices"]]];
    NSString *requestBody = [@"apns_device[token]=" stringByAppendingString:deviceToken];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

///////////////////////// ↓　通信用メソッド　↓　//////////////////////////////
//通信開始時に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //初期化
    self.mData = [NSMutableData data];
}

//通信中常に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //通信したデータを入れていきます
    [self.mData appendData:data];
}

//通信終了時に呼ばれる
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
/*
    // 通信エラーメッセージ表示
    errAlert_exit = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_API_NotConnectTitleMsg",@"")
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Dialog_API_NotConnectMsg",@"")
                                     otherButtonTitles:nil];
    [errAlert_exit show];
*/
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
/*
    if(alertView == errAlert_exit){
        switch (buttonIndex) {
            case 0:
                exit(0);
                break;
        }
    }
*/
}
///////////////////////// ↑　通信用メソッド　↑　//////////////////////////////

// フォアグラウンドかスタンバイのプッシュ通知からの起動
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive){
        if([Configuration getPushNotifications]){
            // 通信エラーメッセージ表示
            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_SiteReupMsg",@"")
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                     otherButtonTitles:nil];
            [errAlert show];
        }
    }
}

@end

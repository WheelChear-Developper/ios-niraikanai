//
//  Main_UITabBarController.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Main_UITabBarController.h"

@interface Main_UITabBarController ()
@end

@implementation Main_UITabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初期起動フラグ設定
    [Configuration setFirstStart:NO];
    
    //タブバー設定
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = NSLocalizedString(@"Tab_TitleName1",@"");
    tabBarItem2.title = NSLocalizedString(@"Tab_TitleName2",@"");
    tabBarItem3.title = NSLocalizedString(@"Tab_TitleName3",@"");
    tabBarItem4.title = NSLocalizedString(@"Tab_TitleName4",@"");
    
    tabBarItem1.image = [[UIImage imageNamed:@"news_30x30_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"news_30x30_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"menu_30x30_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"menu_30x30_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@"shop_30x30_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"shop_30x30_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image = [[UIImage imageNamed:@"recommend_30x30_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"recommend_30x30_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //タブ背景・選択背景設定
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select.png"]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000]];
    
    //タブのテキスト位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    //TabBarに表示されるテキストのフォントとサイズを指定
    //タブバーの文字色と文字サイズを設定(選択前)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.584 green:0.310 blue:0.039 alpha:1.000], UITextAttributeTextColor,[UIFont systemFontOfSize:9.000], UITextAttributeFont,nil] forState:UIControlStateNormal];
    //タブバーの文字色と文字サイズを設定(選択中)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.176 green:0.271 blue:0.220 alpha:1.000], UITextAttributeTextColor,[UIFont systemFontOfSize:9.000], UITextAttributeFont,nil] forState:UIControlStateSelected];
    
    //初期表示タブページ設定
    NSUInteger sc = [Configuration getStartScreen];
    [self setSelectedIndex:sc];
}

- (void)viewDidAppear:(BOOL)animated
{
    // ユーザー情報取得確認
    NSString *str_URL = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_UserGetURL",@""), [Configuration getDeviceTokenKey]];
    NSURL *URL_STRING = [NSURL URLWithString:str_URL];
    NSMutableURLRequest *dev_request = [NSMutableURLRequest requestWithURL:URL_STRING];
    [NSURLConnection connectionWithRequest:dev_request delegate:self];
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
    NSError *error = nil;
    //値の取得
    id json = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *jsonParser = (NSMutableArray*)json;
    
    if([[jsonParser valueForKey:@"id"] longValue]>0){
        NSLog(@"ユーザー情報取得 = %@",jsonParser);
        // プロファイルID設定
        [Configuration setProfileID:[jsonParser valueForKeyPath:@"id"]];
        // プロファイル名設定
        [Configuration setProfileName:[jsonParser valueForKeyPath:@"name"]];
    }else{
/*
        errAlert_exit = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_API_NotConnectTitleMsg",@"")
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Dialog_API_NotConnectMsg",@"")
                                         otherButtonTitles:nil];
        [errAlert_exit show];
 */
    }
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

@end

//
//  AppDelegate.h
//  niraikanai
//
//  Created by SMARTTECNO. on 2014/02/23.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // ナビゲーションコントローラー制御用
    UINavigationController *naviController;
    UIAlertView *errAlert_exit;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain)NSMutableData *mData;
@end

//
//  News_ViewController.h
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsView_ListDataModel.h"
#import "VerticallyAlignedLabel.h"

@interface News_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIWebViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;
}
@property (nonatomic,retain)NSMutableData *mData;
@end

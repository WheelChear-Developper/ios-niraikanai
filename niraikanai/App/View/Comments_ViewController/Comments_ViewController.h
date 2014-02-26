//
//  Comments_ViewController.h
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments_ListDataModel.h"
#import "VerticallyAlignedLabel.h"

@interface Comments_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIWebViewDelegate, UITextViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;
    __weak IBOutlet UILabel *lbl_commentCount;
    __weak IBOutlet UILabel *lbl_comment_hint;
    __weak IBOutlet UITextView *txt_comments;
}
- (IBAction)btn_comments:(id)sender;
@property (nonatomic,retain)NSMutableData *mData;
@end

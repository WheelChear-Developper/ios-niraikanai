//
//  Comments_Cell.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/02/04.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "Comments_Cell.h"
#import "UILabel+EstimatedHeight.h"

@implementation Comments_Cell
{
    VerticallyAlignedLabel *Comment;
    AsyncImageView *ai;
}

@synthesize str_comment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    int int_PosisonHeight = 0;
    
    // ラベルの高さ取得
    CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                text:self.str_comment size:CGSizeMake(255, MAXFLOAT)];
    flt_height += 10;
    
    // コメント（５０文字）
    if(self.str_comment.length >0){
        [Comment removeFromSuperview];
        Comment = [[VerticallyAlignedLabel alloc] init];
        Comment.frame = CGRectMake(35, 35  , 255, flt_height);
        Comment.verticalAlignment = VerticalAlignmentTop;
        Comment.numberOfLines = 50;
        [Comment setFont:[UIFont systemFontOfSize:13]];
        Comment.textColor = [UIColor darkGrayColor];
        Comment.text = self.str_comment;
        [self addSubview:Comment];
    }
    int_PosisonHeight = 35 + flt_height;
}

@end

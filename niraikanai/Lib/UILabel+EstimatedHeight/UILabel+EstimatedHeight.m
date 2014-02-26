//
//  UILabel+EstimatedHeight.m
//  inui
//
//  Created by SMARTTECNO. on 2014/02/04.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "UILabel+EstimatedHeight.m"

@implementation UILabel (EstimatedHeight)

+ (CGFloat)xx_estimatedHeight:(UIFont *)font text:(NSString *)text size:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    if(text == nil){
        text = @"";
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return rect.size.height;
}
@end

//
//  VerticallyAlignedLabel.h
//  LunaNote_iPhone
//
//  Created by Developper_Masashi on 2013/01/16.
//  Copyright (c) 2013年 SmartTecno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum VerticalAlignment
{
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel
{
    @private VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
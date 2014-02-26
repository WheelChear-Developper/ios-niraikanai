//
//  NewsView_ListDataModel.h
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/10.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsView_ListDataModel : NSObject

@property(nonatomic) long service_id;
@property(nonatomic) long service_time;
@property(nonatomic, copy) NSString *service_retime;
@property(nonatomic, copy) NSString *service_imageUrl;
@property(nonatomic, copy) UIImage *service_image;
@property(nonatomic, copy) NSString *service_title;
@property(nonatomic, copy) NSString *service_body;
@end

//
//  AsyncImageView.h
//  inui
//
//  Created by SMARTTECNO. on 2014/02/04.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageView : UIImageView {
@private
    NSURLConnection *conn;
    NSMutableData *data;
}
-(void)loadImage:(NSString *)url;
-(void)abort;
@end
//
//  Shop_ViewController.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/15.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Shop_ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface Shop_ViewController ()

@end

@implementation Shop_ViewController

@synthesize map_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    //BackColor
    self.view.backgroundColor = [SetColor setBackGroundColor];

    CLLocationCoordinate2D co;
    co.latitude = 34.066642;
    co.longitude = 134.548290;
    MKCoordinateRegion cr = map_view.region;
    cr.center = co;
    cr.span.latitudeDelta = 0.004;
    cr.span.longitudeDelta = 0.004;
    [map_view setRegion:cr animated:YES];
    
    MyAnnotation *annotation;
    CLLocationCoordinate2D location;
    location.latitude  = 34.066642;
    location.longitude = 134.548290;
    annotation =[[MyAnnotation alloc] initWithCoordinate:location];
    annotation.title = @"琉球空間 にらいかない";
//    annotation.subtitle = @"";
    [map_view addAnnotation:annotation];
}

- (void)dealloc {
    btn_tel = nil;
    btn_web = nil;
    map_view = nil;
    self.tableView = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section){
        case 1:{
            return 44;
        }
        case 2:{
            return 44;
        }
        case 3:{
            return 44;
        }
        default:{
            return 0;
            break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 320.0f, 44)];
    UIImage *headerImage = [UIImage imageNamed:@"waku_set1.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    headerImageView.frame = CGRectMake(10.0f, 0.0f, 300.0f, 44);
    
    UILabel *title = [[UILabel alloc] init];
    title = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 12.0f, 270.0f, 21)];
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    
    switch(section){
        case 1:{
            [headerView addSubview:headerImageView];
            title.text = @"店舗情報";
            [headerView addSubview:title];
            break;
        }
        case 2:{
            [headerView addSubview:headerImageView];
            title.text = @"琉球空間の雰囲気";
            [headerView addSubview:title];
            break;
        }
        case 3:{
            [headerView addSubview:headerImageView];
            title.text = @"その他協賛店舗";
            [headerView addSubview:title];
            break;
        }
        default:{
            break;
        }
    }
    
    return headerView;
}

- (IBAction)btn_tel:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0886230044"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_web:(id)sender
{
    [Configuration setWebURL:@"http://www.just.st/?in=311134&amp;qr=1004471"];
}

- (IBAction)btn_set1:(id)sender
{
    [Configuration setWebURL:@"http://magokoro-sejutsuin.akafune.com/"];
}

- (IBAction)btn_set2:(id)sender
{
    [Configuration setWebURL:@"http://mari-anju.akafune.com/"];
}

- (IBAction)btn_set3:(id)sender
{
    [Configuration setWebURL:@"http://sunny.akafune.com/"];
}

- (IBAction)btn_set4:(id)sender
{
    [Configuration setWebURL:@"http://masamasa.akafune.com/"];
}

- (IBAction)btn_set5:(id)sender
{
    [Configuration setWebURL:@"http://inui.akafune.com/"];
}

- (IBAction)btn_set6:(id)sender
{
    [Configuration setWebURL:@"http://beruami.akafune.com/"];
}

- (IBAction)btn_set7:(id)sender
{
    [Configuration setWebURL:@"http://kujira.akafune.com/"];
}

- (IBAction)btn_set8:(id)sender
{
    [Configuration setWebURL:@"http://kaatsu-club-group.akafune.com/"];
}

- (IBAction)btn_set9:(id)sender
{
    [Configuration setWebURL:@"http://frees-for-hair.akafune.com/"];
}

- (IBAction)btn_set10:(id)sender
{
    [Configuration setWebURL:@"http://skip.akafune.com/"];
}

@end


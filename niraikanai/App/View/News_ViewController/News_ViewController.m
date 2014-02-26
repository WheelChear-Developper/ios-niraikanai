//
//  News_ViewController.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "News_ViewController.h"
#import "SVProgressHUD.h"
#import "SqlManager.h"
#import "News_Cell.h"
#import "UILabel+EstimatedHeight.h"

@interface News_ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_TotalDataBox;
    // スクロールダウンの再読み込みフラグ
    BOOL bln_TableReLoad;
}
@end

@implementation News_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 初期起動メソッド
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //BackColor
    Table_View.backgroundColor = [SetColor setBackGroundColor];
    
    // スクロールダウンの再読み込みフラグ(Table用)
    bln_TableReLoad = NO;
    
    UINib *nib = [UINib nibWithNibName:@"News_Cell" bundle:nil];
    News_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"News_Cell"];
}

// 終了処理
- (void)viewDidUnload
{
    Table_View = nil;
    _TotalDataBox = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

// 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    // リストデータの読み込み
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
    [self readWebData];
    
    [super viewWillAppear:animated];
}

// 画面の表示の時に起動するメソッド
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// 画面変更時の終了メソッド
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Table_View = nil;
    _TotalDataBox = nil;
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_TotalDataBox count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルごとの大きさ調整
    if(_TotalDataBox.count > 0){
        NSUInteger row = (NSUInteger)indexPath.row;
        NewsView_ListDataModel *listDataModel = _TotalDataBox[row];
        
        // ラベルの高さ取得
        CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                    text:listDataModel.service_body size:CGSizeMake(255, MAXFLOAT)];
        flt_height += 15 * 2;
        
        // 行数によるポジションセット
        CGFloat photo_potision = [listDataModel.service_body lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]/19;
        if(photo_potision > 6){
            photo_potision = 6;
        }
        
        if([listDataModel.service_imageUrl isEqual:@"<null>"]){
            return 55 + flt_height + 15 + 33;
        }else if([listDataModel.service_imageUrl isEqual:[NSNull null]]){
            return 55 + flt_height + 15 + 33;
        }else{
            return 55 + flt_height + 200 + 15 + 33 + 5;
        }
    }
    return 0;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    News_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"News_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    NewsView_ListDataModel *listDataModel = _TotalDataBox[row];
    cell.int_commentCount = listDataModel.service_id;
    cell.lbl_hyoudai.text = listDataModel.service_title;
    cell.lbl_date.text = listDataModel.service_retime;
    cell.str_comment = listDataModel.service_body;
    cell.str_imageurl = listDataModel.service_imageUrl;
    
    return cell;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//セルの選択時イベントメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsView_ListDataModel *listDataModel = _TotalDataBox[indexPath.row];
    // 選択リスト設定
    [Configuration setListID:listDataModel.service_id];
    // 画面遷移
    UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
    [self.navigationController pushViewController:initialViewController animated:YES];
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // テーブルビュー用
    if(Table_View){
        CGFloat table_positionY = [Table_View contentOffset].y;
        if(table_positionY < -100){
            bln_TableReLoad = YES;
        }else if(table_positionY == 0){
            if(bln_TableReLoad == YES){
                // リストデータの読み込み
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_ReReading",@"")];
                [self readWebData];
                
                bln_TableReLoad = NO;
            }
        }
    }
}
/////////////// ↑　テーブル用メソッド　↑ ////////////////////

/////////////// ↓　通信用メソッド　↓　////////////////////
// Webからのリストデータ取得
- (void)readWebData
{
    // リストデータの初期化
    _TotalDataBox = [[NSMutableArray alloc] init];
    
    // ニュース取得
    NSString *str_URL = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_NewsURL",@"")];
    NSURL *URL_STRING = [NSURL URLWithString:str_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

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
    
    //    NSLog(@"ニュース一覧取得用 = %@",jsonParser);
    
    ///////////////// テストデータ スタート ///////////////////////
    /*
     jsonParser = [NSMutableArray array];
     for(long i=1;i<=20;i++){
     NSDictionary *jsonParser1 = @{@"id": [NSNumber numberWithLong:i],
     @"title": @"１２３４５６７８９０１２３４５",
     @"body": @"１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
     @"image": @"http://www.smarttecno.net/_src/sc2951/sign.png",
     @"created_at": [NSNumber numberWithLong:0]};
     [jsonParser addObject:jsonParser1];
     }
     //     NSLog(@"%@",jsonParser);
     */
    ///////////////// テストデータ エンド ///////////////////////
    
    NSMutableArray *RecordDataBox = [SqlManager Get_ServiceList];
    if(RecordDataBox.count>0){
        long chk_dt1 = [[RecordDataBox[0] valueForKeyPath:@"service_time"] longValue];
        long chk_dt2 = [[[jsonParser valueForKeyPath:@"created_at"] objectAtIndex:0] longValue];
        if(chk_dt1 == chk_dt2){
            NSLog(@"ニュースデータ変更なし");
            _TotalDataBox = RecordDataBox;
        }else{
            [SqlManager AllDel_ServiceList_listid];
            
            // データ格納(Webからの再取得)
            for(int i=0;i<jsonParser.count;i+=1){
                NewsView_ListDataModel *listDataModel = [[NewsView_ListDataModel alloc] init];
                listDataModel.service_id = [[[jsonParser valueForKeyPath:@"id"] objectAtIndex:i] longValue];
                listDataModel.service_title = [[jsonParser valueForKeyPath:@"title"] objectAtIndex:i];
                listDataModel.service_body = [[jsonParser valueForKeyPath:@"body"] objectAtIndex:i];
                listDataModel.service_imageUrl = [[jsonParser valueForKeyPath:@"image"] objectAtIndex:i];
                
                // 時間の再定義
                NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
                [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
                // 基本時間からの加算
                NSDate* setDate = [rootDate initWithTimeInterval:[[[jsonParser valueForKeyPath:@"created_at"] objectAtIndex:i] longValue] sinceDate:rootDate];
                // 時間のフォーマット変更
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM月dd日 HH時"];
                NSString* str_time = [formatter stringFromDate:setDate];
                listDataModel.service_retime = str_time;
                
                [_TotalDataBox addObject:listDataModel];
                
                [SqlManager Set_ServiceList_Insert_listid:listDataModel.service_id
                                                 listtime:[[[jsonParser valueForKeyPath:@"created_at"] objectAtIndex:i] longValue]
                                               listretime:listDataModel.service_retime
                                                    title:listDataModel.service_title
                                                 imageUrl:listDataModel.service_imageUrl
                                                     body:listDataModel.service_body];
            }
        }
    }else{
        [SqlManager AllDel_ServiceList_listid];
        
        // データ格納(Webからの再取得)
        for(int i=0;i<jsonParser.count;i+=1){
            NewsView_ListDataModel *listDataModel = [[NewsView_ListDataModel alloc] init];
            listDataModel.service_id = [[[jsonParser valueForKeyPath:@"id"] objectAtIndex:i] longValue];
            listDataModel.service_title = [[jsonParser valueForKeyPath:@"title"] objectAtIndex:i];
            listDataModel.service_body = [[jsonParser valueForKeyPath:@"body"] objectAtIndex:i];
            listDataModel.service_imageUrl = [[jsonParser valueForKeyPath:@"image"] objectAtIndex:i];
            
            // 時間の再定義
            NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
            [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
            // 基本時間からの加算
            NSDate* setDate = [rootDate initWithTimeInterval:[[[jsonParser valueForKeyPath:@"created_at"] objectAtIndex:i] longValue] sinceDate:rootDate];
            // 時間のフォーマット変更
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日 HH時"];
            NSString* str_time = [formatter stringFromDate:setDate];
            listDataModel.service_retime = str_time;
            
            [_TotalDataBox addObject:listDataModel];
            
            [SqlManager Set_ServiceList_Insert_listid:listDataModel.service_id
                                             listtime:[[[jsonParser valueForKeyPath:@"created_at"] objectAtIndex:i] longValue]
                                           listretime:listDataModel.service_retime
                                                title:listDataModel.service_title
                                             imageUrl:listDataModel.service_imageUrl
                                                 body:listDataModel.service_body];
        }
    }
    
    //テーブルデータの再構築
    [Table_View reloadData];
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    // 通信エラーメッセージ表示
    UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                       message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                             otherButtonTitles:nil];
    [errAlert show];
}
/////////////// ↑　通信用メソッド　↑　////////////////////

// アラートのボタンが押された時に呼ばれるメソッド
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
    }
}

@end

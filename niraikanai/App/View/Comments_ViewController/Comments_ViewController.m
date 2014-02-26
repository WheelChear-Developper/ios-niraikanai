//
//  Comments_ViewController.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Comments_ViewController.h"
#import "SVProgressHUD.h"
#import "SqlManager.h"
#import "Comments_Cell.h"
#import "UILabel+EstimatedHeight.h"

@interface Comments_ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_TotalDataBox;
    // スクロールダウンの再読み込みフラグ
    BOOL bln_TableReLoad;
}
@end

@implementation Comments_ViewController

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
    
    // 戻るボタン設定
    UIButton *Left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Left_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [Left_Button setTitle:NSLocalizedString(@"Button_Back",@"") forState:UIControlStateNormal];
    [Left_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Left_Button addTarget:self action:@selector(btn_Return:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Left_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Left_Button];
    self.navigationItem.leftBarButtonItem = Left_buttonItem;
    
    //BackColor
    Table_View.backgroundColor = [SetColor setBackGroundColor];
    self.view.backgroundColor = [SetColor setBackGroundColor];
    
    // スクロールダウンの再読み込みフラグ(Table用)
    bln_TableReLoad = NO;
    
    UINib *nib = [UINib nibWithNibName:@"Comments_Cell" bundle:nil];
    Comments_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"Comments_Cell"];
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
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
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
        Comments_ListDataModel *commentDataModel = _TotalDataBox[row];
        
        // ラベルの高さ取得
        CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                    text:commentDataModel.comments_body size:CGSizeMake(255, MAXFLOAT)];
        flt_height += 10;
        
        // 行数によるポジションセット
        CGFloat photo_potision = [commentDataModel.comments_body lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]/19;
        if(photo_potision > 6){
            photo_potision = 6;
        }
        
        return 35 + flt_height + 25;
    }
    return 0;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    Comments_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comments_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    Comments_ListDataModel *commentDataModel = _TotalDataBox[row];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@(%ld)",commentDataModel.comments_name,commentDataModel.comments_iosUserId];
    cell.str_comment = commentDataModel.comments_body;
    cell.lbl_date.text = commentDataModel.comments_retime;
    
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
    
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
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
    
    // コメント取得
    NSString *URL = [NSString stringWithFormat:@"%@%@%ld%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_CommentGet1URL",@""), (long)[Configuration getListID], NSLocalizedString(@"Service_CommentGet2URL",@"")];
    NSURL *URL_STRING = [NSURL URLWithString:URL];
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
    
//    NSLog(@"コメント取得 = %@",jsonParser);
    
    // コメントカウント設定
    lbl_commentCount.text = [NSString stringWithFormat:@"コメント( %ld 件)",(long)jsonParser.count];
    
    // データ格納(Webからの再取得)
    for(int i=0;i<jsonParser.count;i+=1){
        Comments_ListDataModel *commentDataModel = [[Comments_ListDataModel alloc] init];
        commentDataModel.comments_id = [[[jsonParser valueForKeyPath:@"id"] objectAtIndex:(jsonParser.count-1)-i] longValue];
        commentDataModel.comments_newsId = [[[jsonParser valueForKeyPath:@"newsId"] objectAtIndex:(jsonParser.count-1)-i] longValue];
        commentDataModel.comments_iosUserId = [[[jsonParser valueForKeyPath:@"iosUserId"] objectAtIndex:(jsonParser.count-1)-i] longValue];
        commentDataModel.comments_name = [[jsonParser valueForKeyPath:@"iosUserName"] objectAtIndex:(jsonParser.count-1)-i];
        commentDataModel.comments_body = [[jsonParser valueForKeyPath:@"body"] objectAtIndex:(jsonParser.count-1)-i];
        
        // 時間の再定義
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
        // 基本時間からの加算
        NSDate* setDate = [rootDate initWithTimeInterval:[[[jsonParser valueForKeyPath:@"createdAt"] objectAtIndex:(jsonParser.count-1)-i] longValue] sinceDate:rootDate];
        // 時間のフォーマット変更
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日 HH時"];
        NSString* str_time = [formatter stringFromDate:setDate];
        commentDataModel.comments_retime = str_time;
            
        [_TotalDataBox addObject:commentDataModel];
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

/////////////// ↓　入力系用メソッド　↓ ////////////////////
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    // ホント表示を消す
    lbl_comment_hint.hidden = YES;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if(txt_comments.text.length == 0){
        // ヒント表示表示
        lbl_comment_hint.hidden = NO;
    }
    // キーボード隠す
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int maxInputLength = 50;
    
    // 入力済みのテキストを取得
    NSMutableString *str = [textView.text mutableCopy];
    
    // 入力済みのテキストと入力が行われたテキストを結合
    [str replaceCharactersInRange:range withString:text];
    
    if ([str length] > maxInputLength) {
        return NO;
    }
    
    return YES;
}
/////////////// ↑　入力系用メソッド　↑ ////////////////////

// 全画面に戻るメソッド
- (void)btn_Return:(id)sender
{
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

// コメント投稿メソッド
- (IBAction)btn_comments:(id)sender
{
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
    // トリム処理
    txt_comments.text = [txt_comments.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([txt_comments.text isEqualToString:@""])
    {
        // ヒント表示表示
        lbl_comment_hint.hidden = NO;
    }
    
    if(![txt_comments.text isEqualToString:@""]){
        // リストデータの読み込み
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Writeing",@"")];
        
        // コメント保存(サーバー用)
        NSString *URL = [NSString stringWithFormat:@"%@%@%ld%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_CommentSet1URL",@""),(long)[Configuration getListID] ,NSLocalizedString(@"Service_CommentSet2URL",@""),[Configuration getDeviceTokenKey]];
        NSURL *URL_STRING = [NSURL URLWithString:URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
        NSString *requestBody = [@"body=" stringByAppendingString:txt_comments.text];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (connection) {
            // start loading
        }else{
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
        
        // 前画面に戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

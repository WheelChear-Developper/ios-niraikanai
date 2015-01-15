//
//  Menu_ViewController.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Menu_ViewController.h"
#import "SVProgressHUD.h"

@interface Menu_ViewController ()
{
    // 戻るボタンインスタンス
    UIButton *Right_Button;
    // 読み込み中フラグ
    BOOL bln_download;
}
@end

@implementation Menu_ViewController

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
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 戻るボタン設定
    Right_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Right_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [Right_Button setTitle:NSLocalizedString(@"Button_Back",@"") forState:UIControlStateNormal];
    [Right_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Right_Button addTarget:self action:@selector(btn_Return:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Right_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Right_Button];
    Right_Button.hidden = true;
    self.navigationItem.rightBarButtonItem = Right_buttonItem;
    //BackColor
    Web_View.backgroundColor = [SetColor setRollUpBackGroundColor];
    // webview用スクロールデリゲート追加
    Web_View.scrollView.delegate = self;
    // リンクタグ解析をしないようにする
    Web_View.dataDetectorTypes = UIDataDetectorTypeNone;
    
    // スナップアクション再読み込みフラグ
    bln_download = NO;
}

// 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 本体データ取得
    Web_View.scalesPageToFit = YES;
    NSString *str_URL = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_MenuURL",@"")];
    NSURL *URL_STRING = [NSURL URLWithString:str_URL];
    NSURLRequest *req = [NSURLRequest requestWithURL:URL_STRING cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [Web_View loadRequest:req];
}

// 画面の表示の時に起動するメソッド
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Right_Button = nil;
    [Web_View setDelegate:nil];
    [Web_View stopLoading];
    Web_View =nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 読み込み中の表示
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    bln_download = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Errcode_%ld",(long)error.code);
    if(error.code == NSURLErrorCancelled){
    }else{
        // 読み込み中の表示削除
        [SVProgressHUD dismiss];
        bln_download = NO;
        // 通信エラーメッセージ表示
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                           message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                 otherButtonTitles:nil];
        [errAlert show];
    }
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat positionY = Web_View.scrollView.contentOffset.y;
    NSLog(@"%.1f",positionY);
    
    if(positionY < -100){
        if(bln_download == NO){
            bln_download = YES;
            [Web_View reload];
        }
    }
}

-(void)btn_Return:(id)sender
{
    if([Web_View canGoBack]){
        // ページを戻す
        [Web_View goBack];
    }
}

@end

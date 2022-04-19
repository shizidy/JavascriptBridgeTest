//
//  ViewController.m
//  JavascriptBridgeTest
//
//  Created by wdyzmx on 2022/4/19.
//

#import "ViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WKWebView.h>

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

@interface ViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initWKWebView];
    [self setUI];
    [self loadNativeHTML];
    [self initJavascriptBridge];
    
    // Do any additional setup after loading the view.
}

- (void)initWKWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 40;
    self.wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
    [self.view addSubview:self.wkwebView];
}

- (void)loadNativeHTML {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"BrigeAPI" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]];
    [self.wkwebView loadRequest:request];
}

- (void)setUI {
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(50, 500, 300, 300)];
    btnView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btnView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 30)];
    titleLabel.text = @"非web控件区域";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:titleLabel];
    
    UIButton *callJSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callJSBtn setFrame:CGRectMake(0, 50, 300, 30)];
    [callJSBtn setTitle:@"调用JS函数" forState:UIControlStateNormal];
    [callJSBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [callJSBtn addTarget:self action:@selector(callJS:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:callJSBtn];
}

- (void)initJavascriptBridge {
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkwebView];
    [self.bridge setWebViewDelegate:self];
    // 注册js调用函数，并设定回调，js中可以调用jsCallOC的函数
    [self.bridge registerHandler:@"JSCallOC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"JSCallOC data==%@", data);
        responseCallback(@"Response from OC_CallBack");
    }];
}

- (void)callJS:(UIButton *)btn {
    //callHandler有几种形式
    //- (void)callHandler:(NSString *)handlerName 只调用函数
    //- (void)callHandler:(NSString *)handlerName data:(id)data 调用的同时携带数据
    //- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback 不但调用和携带数据，而且设置回调函数处理所需的数据(如果需要处理结果数据)
//    [self.bridge callHandler:@"objcCallJS" data:@{@"key":@"value"} responseCallback:^(id responseData){
//        NSLog(@"%@",responseData);
//    }];
//    [self.bridge callHandler:@"objcCallJS"];
    NSLog(@"调用JS函数");
    [self.bridge callHandler:@"OCCallJS" data:@{@"key": @"value", @"name": @"wdyzmx"} responseCallback:^(id responseData) {
        NSLog(@"OCCallJS responseData==%@", responseData);
    }];
}

#pragma mark - 懒加载

@end

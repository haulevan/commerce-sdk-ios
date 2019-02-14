#import "BidaliWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface BidaliWebViewController ()
@property WebViewJavascriptBridge* bridge;
@property WKWebView* loadingWebView;
@property WKWebView* webView;
//@property UIActivityIndicatorView *spinner;
@property UIButton *closeButton;
@property NSDictionary* options;
@end

@implementation BidaliWebViewController

-(id)initWithOptions:(NSDictionary*)options
{
    self = [super init];

    if(self)
    {
        self.options = options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.988 alpha:1];
    self.view.backgroundColor = backgroundColor;

    //Creating a WKWebView with our configuration
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = backgroundColor;
    self.webView.navigationDelegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];

    NSString *loadingString = @"<html><head><style type='text/css'>html, body {height: 100%;background: #f8f8fc;left: 0;margin: 0;overflow: hidden;text-align: center;top: 0;width: 100%;}.spinner { height: 120px;max-height: 60vmin;max-width: 60vmin;left: 50%;position: absolute;top: 50%;transform: translateX(-50%) translateY(-50%);width: 120px;z-index: 10;} .spinner .loader { animation: rotation .7s infinite linear;border: 6px solid rgba(0, 0, 0, .15);border-top-color: #4B4DF1;border-radius: 100%;box-sizing: border-box;height: 100%;width: 100%;}@keyframes rotation {from { transform: rotate(0deg); }to { transform: rotate(359deg); }}</style></head><body><div class=\"spinner\"><div class=\"loader\"></div></div></html>";

    self.loadingWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.loadingWebView.backgroundColor = backgroundColor;
    self.loadingWebView.hidden = NO;
    [self.loadingWebView loadHTMLString:loadingString baseURL:nil];
    [self.view addSubview:self.loadingWebView];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"x" forState:UIControlStateNormal];
    [self.closeButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
    [self.closeButton setFrame:CGRectMake(self.view.frame.size.width - 40, 40, 40, 40)];
    [self.view addSubview:self.closeButton];

//    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:self.spinner];
//    CGFloat size = self.spinner.frame.size.width;
//    [self.spinner startAnimating];
//    [self.spinner setFrame:CGRectMake((self.view.frame.size.width-size)/2,(self.view.frame.size.height-size)/2,size,size)];

    [WebViewJavascriptBridge enableLogging];

    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];

    NSDictionary *urls = @{
       @"local" : @"http://localhost:3009/embed",
       @"staging" : @"https://commerce.staging.bidali.com/embed",
       @"production" : @"https://commerce.bidali.com/embed"
    };

    NSDictionary *handlers = @{
                          @"onOrderCreated" : ^(id data) {
                        NSLog(@"onOrderCreated called in webview: %@", data);
    }};

    [_bridge registerHandler:@"onOrderCreated" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"onOrderCreated called in webview: %@", data);
        if(self.options[@"onOrderCreated"]) {
            void(^block)(void) = self.options[@"onOrderCreated"];
            if(block)
            {
                block();
            }
        }
        responseCallback(data);
    }];

    [_bridge registerHandler:@"onPaymentRequest" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"onPaymentRequest called in webview: %@", data);
        NSLog(@"%@", self.options);
        if(self.options[@"onPaymentRequest"]) {
            NSLog(@"%@", self.options[@"onPaymentRequest"]);
            void(^block)(id) = self.options[@"onPaymentRequest"];
            if(block)
            {
                block(data);
            }
        }
        responseCallback(data);
    }];

    [_bridge registerHandler:@"onClose" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"onClose called: %@", data);
        [self closePressed];
        responseCallback(@"Response from onOrderCreated");
    }];

    [_bridge registerHandler:@"log" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"log called: %@", data);
    }];

    NSMutableDictionary *opts = [NSMutableDictionary dictionary];
    NSString *defaultEnv = @"production";
    NSDictionary *propDefinitions = @{
      @"env": @{
              @"type": @"string",
              @"required": @NO
              },
      @"apiKey": @{
              @"type": @"string",
              @"required": @NO
              },
      @"email": @{
              @"type": @"string",
              @"required": @NO
              },
      @"paymentType": @{
              @"type": @"string",
              @"required": @NO
              },
      @"paymentCurrencies": @{
              @"type": @"object",
              @"required": @NO
              }
    };

    for(id key in propDefinitions) {
        if(self.options[key]) {
            opts[key] = self.options[key];
        }
    }

    NSString *widgetUrl = urls[defaultEnv];
    if(self.options[@"url"]) {
        widgetUrl = self.options[@"url"];
    } else if(opts[@"env"] && urls[opts[@"env"]]) {
        widgetUrl = urls[opts[@"env"]];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:widgetUrl]]];
    NSLog(@"setting up with: %@ - %@", widgetUrl, opts);
    [_bridge callHandler:@"setupBridge" data:opts];
}

- (void) closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
//    [self.view sendSubviewToBack: self.spinner];
    self.webView.hidden = NO;
    self.loadingWebView.hidden = YES;
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    NSLog(@"webViewDidFinishLoad");
    NSLog(@"%@", error);
}

@end

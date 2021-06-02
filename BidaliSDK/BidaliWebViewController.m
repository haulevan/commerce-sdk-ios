#import "BidaliWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "BidaliPaymentRequest.h"

@interface BidaliWebViewController ()
@property WebViewJavascriptBridge* bridge;
@property WKWebView* loadingWebView;
@property WKWebView* webView;
@property UIButton *closeButton;
@property NSDictionary* options;
@property NSString* url;
@property BidaliOnPaymentRequestCallback onPaymentRequest;
@end

@implementation BidaliWebViewController

-(id)initWithOptions:(NSDictionary*)options url:(NSString *)url onPaymentRequest:(BidaliOnPaymentRequestCallback)onPaymentRequest
{
    self = [super init];

    if(self)
    {
        self.options = options;
        self.url = url;
        self.onPaymentRequest = onPaymentRequest;
    }
    return self;
}

- (void)setupLoadingWebview {
    NSString *loadingString = @"<html><head><style type='text/css'>html, body {height: 100%;background: #f8f8fc;left: 0;margin: 0;overflow: hidden;text-align: center;top: 0;width: 100%;}.spinner { height: 120px;max-height: 60vmin;max-width: 60vmin;left: 50%;position: absolute;top: 50%;transform: translateX(-50%) translateY(-50%);width: 120px;z-index: 10;} .spinner .loader { animation: rotation .7s infinite linear;border: 6px solid rgba(0, 0, 0, .15);border-top-color: #4B4DF1;border-radius: 100%;box-sizing: border-box;height: 100%;width: 100%;}@keyframes rotation {from { transform: rotate(0deg); }to { transform: rotate(359deg); }}</style></head><body><div class=\"spinner\"><div class=\"loader\"></div></div></html>";
    
    self.loadingWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.loadingWebView.backgroundColor = self.view.backgroundColor;
    self.loadingWebView.hidden = NO;
    [self.loadingWebView loadHTMLString:loadingString baseURL:nil];
    [self.view addSubview:self.loadingWebView];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeNow) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];

    if (@available(iOS 8.2, *)) {
        [self.closeButton.titleLabel setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightBold]];
    } else {
        // Fallback on earlier versions
        [self.closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    }
    [self.closeButton setFrame:CGRectMake(4, 44, 40, 40)];
    [self.view addSubview:self.closeButton];
}

- (void)setupBridge {
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    if(self.onPaymentRequest) {
        [_bridge registerHandler:@"onPaymentRequest" handler:^(id data, WVJBResponseCallback responseCallback) {
            BidaliPaymentRequest *paymentRequest = [BidaliPaymentRequest requestWithDictionary:(NSDictionary*)data];
            [self close:^{
                self.onPaymentRequest(paymentRequest);
            }];
            responseCallback(data);
        }];
    }
    [_bridge registerHandler:@"onClose" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self close:nil];
        responseCallback(@"Response from onClose");
    }];
    
    [_bridge registerHandler:@"log" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"log called: %@", data);
    }];
    
    [_bridge registerHandler:@"openUrl" handler:^(NSString* urlString, WVJBResponseCallback responseCallback) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:urlString];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{}
                   completionHandler:^(BOOL success) {
                       
                   }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [application openURL:url];
        }
    }];
    
    [_bridge registerHandler:@"readyForSetup" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.bridge callHandler:@"setupBridge" data:self.options];
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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

    [self setupLoadingWebview];
    [self setupCloseButton];
    [self setupBridge];
}

- (void) close:(void (^ __nullable)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.webView.hidden = NO;
    self.loadingWebView.hidden = YES;
    self.closeButton.hidden = YES;
    [self.view sendSubviewToBack:self.closeButton];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self close:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSHTTPURLResponse* response = (NSHTTPURLResponse *)navigationResponse.response;
    if(!response.statusCode) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
    
    if (response.statusCode >= 400) {
        [self close:nil];
        return;
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)closeNow {
    [self close:nil];
}

@end

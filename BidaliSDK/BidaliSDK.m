#import "BidaliSDK.h"
#import "BidaliWebViewController.h"
#import "BidaliConfig.h"

@implementation BidaliSDK
+ (BidaliSDK *)getInstance {
    static BidaliSDK *bidali_sdk = 0;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        bidali_sdk = [[BidaliSDK alloc] init];
    });
    return bidali_sdk;
}

- (void)show:(UIViewController *)controller options:(BidaliSDKOptions *)options {
    NSDictionary *paymentTypeStrings = @{
      @(BidaliPaymentTypeApi) : @"api",
      @(BidaliPaymentTypeManual) : @"manual",
      @(BidaliPaymentTypePrefill) : @"prefill",
    };
    NSDictionary *urls = @{
                           @"local" : @"http://localhost:3009/embed",
                           @"staging" : @"https://commerce.staging.bidali.com/embed",
                           @"production" : @"https://commerce.bidali.com/embed"
                           };
    NSMutableDictionary *opts = [NSMutableDictionary dictionary];
    NSString *defaultEnv = @"production";

    if(options.apiKey != nil) {
        opts[@"apiKey"] = options.apiKey;
    }
    
    if(options.env != nil) {
        opts[@"env"] = options.env;
    }
    
    if(options.email != nil) {
        opts[@"email"] = options.email;
    }
    
    if(options.paymentCurrencies != nil) {
        opts[@"paymentCurrencies"] = options.paymentCurrencies;
    }
    
    opts[@"platform"] = @{
        @"appName": [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey],
        @"appId": [[NSBundle mainBundle] bundleIdentifier],
        @"appVersion": [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],
        @"osName" : @"ios",
        @"osVersion":  [[UIDevice currentDevice] systemVersion],
        @"locale": [[NSLocale currentLocale] localeIdentifier],
        @"sdkVersion": BIDALI_SDK_VERSION,
    };

    NSString *widgetUrl = urls[defaultEnv];
    if(options.url != nil) {
        widgetUrl = options.url;
    } else if(opts[@"env"] && urls[opts[@"env"]]) {
        widgetUrl = urls[opts[@"env"]];
    }
    
    if(options.paymentType) {
        NSString *paymentTypeAsString = [paymentTypeStrings objectForKey:@(options.paymentType)];
        opts[@"paymentType"] = paymentTypeAsString;
        NSLog(@"%@", paymentTypeAsString);
    } else {
        opts[@"paymentType"] = [paymentTypeStrings objectForKey:@(BidaliPaymentTypePrefill)];
    }

    BidaliWebViewController *webViewController = [[BidaliWebViewController alloc] initWithOptions:opts url:widgetUrl onPaymentRequest:options.onPaymentRequest];
    [controller presentViewController:webViewController animated:true completion:nil];
}

- (void)close {
    
}

@end

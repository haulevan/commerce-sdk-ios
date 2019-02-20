#import "BidaliSDK.h"
#import "BidaliWebViewController.h"

@implementation BidaliSDK
+ (BidaliSDK *)getInstance {
    static BidaliSDK *bidali_sdk = 0;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        bidali_sdk = [[BidaliSDK alloc] init];
    });
    return bidali_sdk;
}

- (void)show:(UIViewController *)controller options:(NSDictionary *)options onPaymentRequest:(nonnull BidaliOnPaymentRequestCallback)onPaymentRequest {
    NSDictionary *urls = @{
                           @"local" : @"http://localhost:3009/embed",
                           @"staging" : @"https://commerce.staging.bidali.com/embed",
                           @"production" : @"https://commerce.bidali.com/embed"
                           };
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
        if(options[key]) {
            opts[key] = options[key];
        }
    }
    
    opts[@"platform"] = @{
        @"appName": [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey],
        @"appId": [[NSBundle mainBundle] bundleIdentifier],
        @"osName" : @"ios",
        @"osVersion":  [[UIDevice currentDevice] systemVersion],
        @"appVersion": [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],
        @"locale": [[NSLocale currentLocale] localeIdentifier],
    };

    NSString *widgetUrl = urls[defaultEnv];
    if(options[@"url"]) {
        widgetUrl = options[@"url"];
    } else if(opts[@"env"] && urls[opts[@"env"]]) {
        widgetUrl = urls[opts[@"env"]];
    }

    BidaliWebViewController *webViewController = [[BidaliWebViewController alloc] initWithOptions:opts url:widgetUrl onPaymentRequest:onPaymentRequest];
    [controller presentViewController:webViewController animated:true completion:nil];
}

- (void)close {
    
}

@end

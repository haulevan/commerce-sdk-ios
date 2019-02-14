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

- (void)show:(UIViewController *)controller options:(NSDictionary *)options {
    BidaliWebViewController *webViewController = [[BidaliWebViewController alloc] initWithOptions:options];
    [controller presentViewController:webViewController animated:true completion:^{
        
    }];
}

- (void)close {
    
}

@end

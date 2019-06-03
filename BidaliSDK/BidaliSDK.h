#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BidaliPaymentRequest.h"
#import "BidaliWebViewController.h"
#import "BidaliSDKOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class BidaliSDKOptions;

@interface BidaliSDK : NSObject
+ (BidaliSDK *)getInstance;
- (void)show:(UIViewController *)controller options:(BidaliSDKOptions *)options;
- (void)close;
@property (retain, nonatomic) BidaliWebViewController*_Nullable webViewController;
@end

NS_ASSUME_NONNULL_END

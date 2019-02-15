#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BidaliOnPaymentRequestCallback)(id responseData);

@interface BidaliSDK : NSObject
+ (BidaliSDK *)getInstance;
- (void)show:(UIViewController *)controller options:(NSDictionary *)options onPaymentRequest:(BidaliOnPaymentRequestCallback)onPaymentRequest;
@end

NS_ASSUME_NONNULL_END

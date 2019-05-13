#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Bidali-iOS-SDK/BidaliPaymentRequest.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum { BidaliPaymentTypeApi, BidaliPaymentTypeManual, BidaliPaymentTypePrefill  } BidaliPaymentType;
typedef void (^BidaliOnPaymentRequestCallback)(BidaliPaymentRequest *paymentRequest);

@interface BidaliSDK : NSObject
+ (BidaliSDK *)getInstance;
- (void)show:(UIViewController *)controller options:(NSDictionary *)options onPaymentRequest:(BidaliOnPaymentRequestCallback)onPaymentRequest;
@end

NS_ASSUME_NONNULL_END

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "BidaliSDK.h"

@interface BidaliWebViewController : UIViewController <WKNavigationDelegate>
-(id)initWithOptions:(NSDictionary*)options url:(NSString*)url onPaymentRequest:(BidaliOnPaymentRequestCallback)onPaymentRequest;
@end


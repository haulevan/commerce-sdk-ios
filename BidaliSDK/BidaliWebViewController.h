#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BidaliSDKOptions.h"

@interface BidaliWebViewController : UIViewController <WKNavigationDelegate>
-(id)initWithOptions:(NSDictionary*)options url:(NSString*)url onPaymentRequest:(BidaliOnPaymentRequestCallback)onPaymentRequest;
-(void)close:(void (^ __nullable)(void))completion;
@end


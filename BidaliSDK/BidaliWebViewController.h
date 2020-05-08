#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BidaliSDKOptions.h"

@interface BidaliWebViewController : UIViewController <WKNavigationDelegate>
-(id _Nonnull )initWithOptions:(NSDictionary*_Nonnull)options url:(NSString*_Nonnull)url onPaymentRequest:(BidaliOnPaymentRequestCallback _Nullable)onPaymentRequest;
-(void)close:(void (^ __nullable)(void))completion;
@end


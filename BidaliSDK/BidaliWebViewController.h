#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface BidaliWebViewController : UIViewController <WKNavigationDelegate>
-(id)initWithOptions:(NSDictionary*)options;
@end


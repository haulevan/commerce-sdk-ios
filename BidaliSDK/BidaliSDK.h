#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BidaliSDK : NSObject
+ (BidaliSDK *)getInstance;
- (void)show:(UIViewController *)controller options:(NSDictionary *)options;
@end

NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>
#import "BidaliSDK.h"

typedef enum { BidaliPaymentTypeApi, BidaliPaymentTypeManual, BidaliPaymentTypePrefill  } BidaliPaymentType;
typedef void (^BidaliOnPaymentRequestCallback)(BidaliPaymentRequest *paymentRequest);

@interface BidaliSDKOptions : NSObject

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* env;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* email;
@property (assign, nonatomic) BidaliPaymentType paymentType;
@property (strong, nonatomic) NSArray* paymentCurrencies;
@property (strong, nonatomic) BidaliOnPaymentRequestCallback onPaymentRequest;
+ (instancetype)optionsWithApiKey:(NSString*)apiKey;
@end

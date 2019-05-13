#import <Foundation/Foundation.h>

@interface BidaliPaymentRequest : NSObject
@property (strong, nonatomic) NSString* amount;
@property (strong, nonatomic) NSString* currency;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* chargeId;
@property (strong, nonatomic) NSString* chargeDescription;
@property (strong, nonatomic) NSString* extraId;
@property (strong, nonatomic) NSString* extraIdName;

+ (BidaliPaymentRequest *)requestWithDictionary:(NSDictionary*)dictionary;
@end

#include "BidaliPaymentRequest.h"

@implementation BidaliPaymentRequest {
   
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.amount = dictionary[@"amount"];
        self.currency = dictionary[@"currency"];
        self.address = dictionary[@"address"];
        self.chargeId = dictionary[@"chargeId"];
        self.chargeDescription = dictionary[@"description"];
        self.extraId = dictionary[@"extraId"];
        self.extraIdName = dictionary[@"extraIdName"];
    }
    return self;
}

- (void)dealloc {
    self.amount = nil;
    self.currency = nil;
    self.address = nil;
    self.chargeId = nil;
    self.chargeDescription = nil;
    self.extraId = nil;
    self.extraIdName = nil;
}

+ (instancetype)requestWithDictionary:(NSDictionary *)dictionary {
    BidaliPaymentRequest *paymentRequest = [[BidaliPaymentRequest alloc] initWithDictionary:dictionary];
    return paymentRequest;
}


@end

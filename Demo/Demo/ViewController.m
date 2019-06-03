//
//  ViewController.m
//  Demo
//
//  Created by Cory Smith on 2019-01-18.
//  Copyright © 2019 Bidali Inc. All rights reserved.
//

#import "ViewController.h"
#import <Bidali-iOS-SDK/BidaliSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width - 44;
    CGFloat height = 60;
    CGFloat x = 22;
    CGFloat y = 400;
    CGFloat spacing = 22;
    
    NSArray *buttons = @[
        [self buttonWithTitle:@"Buy Giftcards" selector:@selector(defaultOptions)],
        [self buttonWithTitle:@"Bitcoin Only" selector:@selector(btcOnly)],
    ];

    for(UIButton *button in buttons) {
        [button setFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:button];
        y = y + height + spacing;
    }
}

- (void)defaultOptions {
    BidaliSDKOptions *options = [BidaliSDKOptions optionsWithApiKey:@"12345"];
    options.env = @"staging";
    options.onPaymentRequest = ^(BidaliPaymentRequest *paymentRequest){
        [self showAlertForPaymentRequest:paymentRequest];
    };
    [[BidaliSDK getInstance] show:self options:options];
}

- (void)btcOnly {
    BidaliSDKOptions *options = [BidaliSDKOptions optionsWithApiKey:@"12345"];
    options.env = @"staging";
    options.paymentCurrencies = @[@"BTC"];
    options.paymentType = BidaliPaymentTypeManual;
    options.onPaymentRequest = ^(BidaliPaymentRequest *paymentRequest){
        [self showAlertForPaymentRequest:paymentRequest];
    };
    
    [[BidaliSDK getInstance] show:self options:options];
}

- (UIButton *)buttonWithTitle:(NSString *)title selector:(SEL)selector {
    UIColor *bgColor = [UIColor whiteColor];
    UIColor *textColor = [UIColor colorWithRed:0.404 green:0.475 blue:0.859 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.layer.cornerRadius = 30;
    [button setBackgroundColor:textColor];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:bgColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (bool)shouldAutorotate {
    return false;
}

- (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)showAlertForPaymentRequest:(BidaliPaymentRequest *)paymentRequest {
    NSLog(@"Received onPaymentRequest from BidaliSDK\n%@", paymentRequest);
    NSString* message = [NSString stringWithFormat:@"Send %@ %@ to %@ for chargeId: %@", paymentRequest.amount, paymentRequest.currency, paymentRequest.address, paymentRequest.chargeId];
    if(paymentRequest.extraId != nil) {
        message = [NSString stringWithFormat:@"%@ with %@:%@", message, paymentRequest.extraIdName, paymentRequest.extraId];
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:paymentRequest.chargeDescription
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [[BidaliSDK getInstance] close];
                                                          }];
    [alert addAction:defaultAction];
    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

@end

//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"
#import "MKStoreManager.h"

@implementation MKStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self restoreTransaction:transaction];
				break;
            default:
                break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSString* strMessage;
    switch (transaction.error.code) {
        case SKErrorClientInvalid:
            strMessage = @"Client is not allowed to issue the request.";
            break;
        case SKErrorPaymentCancelled:
            [[MKStoreManager sharedManager] Failed];
            return;
        case SKErrorPaymentInvalid:
            strMessage = @"Purchase identifier was invalid.";
            break;
        case SKErrorPaymentNotAllowed:
            strMessage = @"This device is not allowed to make the payment.";
            break;
        case SKErrorStoreProductNotAvailable:
            strMessage = @"Product is not available.";
            break;
        default:
            strMessage = @"Please check your Internet connection and your App Store account information.";
            break;
    }
    
    [[[[UIAlertView alloc] initWithTitle:@"The upgrade procedure failed"
                                    message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
    [[MKStoreManager sharedManager] Failed];
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{		
    [[MKStoreManager sharedManager] SuccessfullyPurchased:transaction.payment.productIdentifier];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[MKStoreManager sharedManager] Restored:transaction.originalTransaction.payment.productIdentifier];
}

@end

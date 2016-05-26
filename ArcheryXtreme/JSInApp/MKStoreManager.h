

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

@interface MKStoreManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	MKStoreObserver *storeObserver;
    BOOL isRestored;
@public
    id      delegate;
}
@property (nonatomic, retain) MKStoreObserver *storeObserver;

+ (MKStoreManager*)sharedManager;
-(void)restoreFunc;
-(void)SuccessfullyPurchased:(NSString*)productIdentifier;
-(void)Restored:(NSString*)productIdentifier;
-(void)Failed;

- (void)BuyCoint:(int)idx;
@end

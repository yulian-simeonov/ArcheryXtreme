

#import "MKStoreManager.h"
#import "JSWaiter.h"

@implementation MKStoreManager

@synthesize storeObserver;
// all your features should be managed one and only by StoreManager

static NSString *coin1 = @"8LCCXHVDF7.com.conceptdesign.FruitExtreme.fruitcoins500";
static NSString *coin2 = @"8LCCXHVDF7.com.conceptdesign.FruitExtreme.fruitcoins2200";
static NSString *coin3 = @"8LCCXHVDF7.com.conceptdesign.FruitExtreme.fruitcoins4000";
static NSString *coin4 = @"8LCCXHVDF7.com.conceptdesign.FruitExtreme.fruitcoins10000";

BOOL featureAPurchased = NO;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc
{
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) featureAPurchased {
	return featureAPurchased;
}

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [[self alloc] init]; // assignment not done here
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    
    return _sharedStoreManager;
}

- (void) buyFeature:(NSString*)featureId
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		[[[[UIAlertView alloc] initWithTitle:@"MessageWiper." message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
	}
}

- (void)BuyCoint:(int)idx
{
    switch (idx) {
        case 1:
            [self buyFeature:coin1];
            break;
        case 2:
            [self buyFeature:coin2];
            break;
        case 3:
            [self buyFeature:coin3];
            break;
        case 4:
            [self buyFeature:coin4];
            break;
        default:
            break;
    }
}

-(void)restoreFunc
{
    isRestored = false;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
}

-(void)SuccessfullyPurchased:(NSString*)productIdentifier
{
    int coinAmount = 0;
    if ([productIdentifier isEqualToString:coin1])
        coinAmount = 500;
    else if ([productIdentifier isEqualToString:coin2])
        coinAmount = 2200;
    else if ([productIdentifier isEqualToString:coin3])
        coinAmount = 4000;
    else if ([productIdentifier isEqualToString:coin4])
        coinAmount = 10000;
    [delegate SuccessfullyPurchased:coinAmount];
    [JSWaiter HideWaiter];
    [[[[UIAlertView alloc] initWithTitle:@"In-App Purchase" message:@"Successfully Purchased" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease] show];
}

-(void)Restored:(NSString*)productIdentifier
{
    [JSWaiter HideWaiter];
}

-(void)Failed
{
    [JSWaiter HideWaiter];
}

@end

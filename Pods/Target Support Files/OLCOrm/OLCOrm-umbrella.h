#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+KJSerializer.h"
#import "OLCDBHelper.h"
#import "OLCMigrator.h"
#import "OLCModel.h"
#import "OLCObjectParser.h"
#import "OLCOrm.h"
#import "OLCOrmNotification.h"
#import "OLCTableHandler.h"

FOUNDATION_EXPORT double OLCOrmVersionNumber;
FOUNDATION_EXPORT const unsigned char OLCOrmVersionString[];


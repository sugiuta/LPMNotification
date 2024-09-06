#import <UIKit/UIKit.h>
#import <dlfcn.h>

@interface BBAction : NSObject
+ (id)actionWithCallblock:(id)arg1;
@end

@interface BBSectionIcon : NSObject
- (void)addVariant:(id)arg1;
@end

@interface BBSectionIconVariant : NSObject
+ (id)variantWithFormat:(long long)arg1 imageData:(id)arg2;
@end

@interface BBBulletin : NSObject
@property (nonatomic, retain) BBSectionIcon *icon;
@property (nonatomic, copy) NSString* sectionID;
@property (nonatomic, copy) NSString* recordID;
@property (nonatomic, copy) NSString* publisherBulletinID;
@property (nonatomic, copy) NSString* title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, retain) NSDate* date;
@property (assign, nonatomic) BOOL clearable;
@property (nonatomic) BOOL showsMessagePreview;
@property (nonatomic, copy) BBAction* defaultAction;
@property (nonatomic, copy) NSString* bulletinID;
@property (nonatomic, retain) NSDate* lastInterruptDate;
@property (nonatomic, retain) NSDate* publicationDate;
@end

@interface BBServer : NSObject
- (void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
@end

@interface _PMLowPowerMode : NSObject
+ (id)sharedInstance;
- (long long)getPowerMode;
- (bool)setPowerMode:(long long)arg1 fromSource:(id)arg2;
@end
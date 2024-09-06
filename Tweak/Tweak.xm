#import "Tweak.h"

// var
static BBServer *bbServer = nil;

static dispatch_queue_t getBBServerQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
    void *handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) queue = *pointer;
            dlclose(handle);
        }
    });
    return queue;
}

static void fakeNotification(NSString *sectionID, NSDate *date, NSString *title, NSString *subtitle, NSString *message, UIImage *image) {
    BBBulletin *bulletin = [[%c(BBBulletin) alloc] init];
    BBSectionIcon *sectionIcon = [[BBSectionIcon alloc] init];
    [sectionIcon addVariant:[BBSectionIconVariant variantWithFormat:0 imageData:UIImagePNGRepresentation(image)]];

    bulletin.title = title;
    bulletin.subtitle = subtitle;
    bulletin.message = message;
    bulletin.sectionID = sectionID;
    bulletin.icon = sectionIcon;
    bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.date = date;
    bulletin.defaultAction = [%c(BBAction) actionWithCallblock:^(BBAction *action){
        if ([[_PMLowPowerMode sharedInstance] getPowerMode] != 1)
            [[%c(_PMLowPowerMode) sharedInstance] setPowerMode:1 fromSource:@"SpringBoard"];
    }];
    bulletin.clearable = YES;
    bulletin.showsMessagePreview = YES;
    bulletin.publicationDate = date;
    bulletin.lastInterruptDate = date;

    dispatch_sync(getBBServerQueue(), ^{
        [bbServer publishBulletin:bulletin destinations:15];
    });
}

%hook BBServer
- (id)initWithQueue:(id)arg1 {
    bbServer = %orig;
    return bbServer;
}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 conduitListener:(id)arg6 settingsListener:(id)arg7 {
    bbServer = %orig;
    return bbServer;
}

- (void)dealloc {
    if (bbServer == self) bbServer = nil;
    %orig;
}
%end

%hook SBAlertItemsController
- (void)activateAlertItem:(id)item animated:(BOOL)animated {
    NSString *itemClassName = NSStringFromClass([item class]);
    if ([itemClassName isEqualToString:@"SBLowPowerAlertItem"]) {
        // バッテリー残量の取得
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        float batteryLevel = [UIDevice currentDevice].batteryLevel;

        // 通知の送信
        fakeNotification(@"com.apple.Preferences", [NSDate date], @"Low Battery", nil, [NSString stringWithFormat:@"%.f%% of battery remaining", batteryLevel*100], nil);
        return;
    }
    return %orig;
}
%end

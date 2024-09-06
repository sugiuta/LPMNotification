TWEAK_NAME = LPMNotification
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
# $(TWEAK_NAME)_LIBRARIES =
$(TWEAK_NAME)_FRAMEWORKS += UIKit Foundation UserNotifications
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = BulletinBoard LowPowerMode
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
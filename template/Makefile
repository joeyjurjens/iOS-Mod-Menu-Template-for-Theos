ARCHS = arm64 #fuck armv7 btw

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = @@PROJECTNAME@@

@@PROJECTNAME@@_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
CFLAGS = -fobjc-arc #-w #-Wno-deprecated -Wno-deprecated-declarations
@@PROJECTNAME@@_FILES = Tweak.xm Menu.mm SwitchesTemplate.mm $(wildcard KittyMemory/*.cpp) $(wildcard SCLAlertView/*.m)

@@PROJECTNAME@@_LIBRARIES += substrate
# GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk

# We need this for the menu icon etc
BUNDLE_NAME = @@PROJECTNAME@@_BUNDLE
@@PROJECTNAME@@_BUNDLE_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 @@BINARYNAME@@ || :"

include $(THEOS_MAKE_PATH)/aggregate.mk

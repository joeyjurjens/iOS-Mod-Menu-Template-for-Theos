# If you want to compile for arm64e, you'll need a macOS device or a arm64e device that's able to compile for arm64e.
# Also, you'll have to remove '#import "KittyMemory/initializer_list"' from Menu.h for it being able to compile this menu.
# Once done that, uncomment the "#arm64e" by removing the "#"

ARCHS = arm64 #arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = @@PROJECTNAME@@

@@PROJECTNAME@@_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
CFLAGS = -fobjc-arc #-w #-Wno-deprecated -Wno-deprecated-declarations
@@PROJECTNAME@@_FILES = Tweak.xm Menu.mm SwitchesTemplate.mm $(wildcard KittyMemory/*.cpp) $(wildcard SCLAlertView/*.m)

@@PROJECTNAME@@_LIBRARIES += substrate
# GO_EASY_ON_ME = 1

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

# We need this for the menu icon etc
BUNDLE_NAME = @@PROJECTNAME@@_BUNDLE
@@PROJECTNAME@@_BUNDLE_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 @@BINARYNAME@@ || :"

include $(THEOS_MAKE_PATH)/aggregate.mk

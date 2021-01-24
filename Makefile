ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
# sdk
export SYSROOT = $(THEOS)/sdks/iPhoneOS.sdk
# never debug build
export FINALPACKAGE = 1
export THEOS_LEAN_AND_MEAN = 1
export OPTFLAG = ""


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = croutons13

croutons13_FILES = src/Tweak/Tweak.xm
croutons13_CFLAGS = -fobjc-arc -Wno-gcc-compat

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += src/Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

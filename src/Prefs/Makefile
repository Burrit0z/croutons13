ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = croutons13prefs

croutons13prefs_FILES = $(wildcard *.m)
croutons13prefs_FRAMEWORKS = UIKit
croutons13prefs_PRIVATE_FRAMEWORKS = Preferences
croutons13prefs_INSTALL_PATH = /Library/PreferenceBundles
croutons13prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

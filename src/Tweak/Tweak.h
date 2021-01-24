#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct SBIconImageInfo {

	struct CGSize size;
	double scale;
	double continuousCornerRadius;

};

@interface _UIStatusBarStringView : UILabel
- (void)addCrumbImage;
- (UIImage *)getCrumbImage;
- (void)updateCrumbImage;
@end

@interface SBBreadcrumbActionContext : NSObject
// ivar: NSString _breadcrumbAppBundleID
// ivar: NSString _primaryTitle
// ivar: BOOL _wasFromSpotlight
// ivar: BOOL _wasFromAssistant
@end

@interface SBIcon : NSObject
@property (nonatomic,readonly) long long badgeValue;
- (id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1 ;
@end

@interface SBIconModel : NSObject
- (SBIcon *)applicationIconForBundleIdentifier:(id)arg1;
- (id)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (SBIconModel *)model;
@end

// function to get icon
static UIImage *getIconImageByBundleID(NSString *identifier) {
    if(!identifier) return nil;

    SBIconController *iconController = ((SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance]);
	SBIcon *icon = [iconController.model expectedIconForDisplayIdentifier:identifier];

	struct CGSize imageSize;
	imageSize.height = 60;
	imageSize.width = 60;
	struct SBIconImageInfo imageInfo;
	imageInfo.size = imageSize;
	imageInfo.scale = [UIScreen mainScreen].scale;
	imageInfo.continuousCornerRadius = 12;

	return [icon generateIconImageWithInfo:imageInfo];
}

// globals :uhh:
BOOL enabled;
double iconSize;

// i was too lazy to create a runtime manager class LOL
__weak SBBreadcrumbActionContext *currentCrumbContext = nil;
UIImageView *crumbImageView = nil;

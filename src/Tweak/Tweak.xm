#import "Tweak.h"

%hook SBBreadcrumbActionContext

// store action context weakly so we can get info from it
- (id)init {
    currentCrumbContext = self;
    return %orig;
}

%end


// string view hook
// UIStatusBarBreadcrumbItemView doesn't seem to be used, unfortunately
// I checked _UIStatusBar items method and still couldn't find any
// good way to get the breadcrumb. please, someone who has time,
// tell me how to get the breadcrumb without this crap. Thanks
%hook _UIStatusBarStringView


// this allows us to override frame, basically. otherwise, the icon image
// ends up overlapping status bar icons
- (CGSize)intrinsicContentSize {
    CGSize orig = %orig;
    if([self.subviews containsObject:crumbImageView]) {
        return CGSizeMake(orig.width + iconSize + 5, orig.height);
    }
    return orig;
}

// this is the part where we detect if we are a breadcrumb
- (void)setText:(NSString *)text {

    // verify we have valid crumb. if not, don't even try to check the rest
    if(currentCrumbContext) {

        // if the crumb has a title
        if(NSString *crumbApp = [currentCrumbContext valueForKey:@"_primaryTitle"]) {
            // most likely this is the crumb text view :nfr:
            if([text containsString:crumbApp]) {
                // remove app title from crumb
                text = [text stringByReplacingOccurrencesOfString:crumbApp withString:@""];

                // if we don't have the image view yet, add it
                if(!crumbImageView) [self addCrumbImage];

                // update crumb image
                [self updateCrumbImage];
            }
        }

    }
    %orig(text);
}

%new
- (UIImage *)getCrumbImage {
    // get app icon bundle id
    UIImage *iconImage = getIconImageByBundleID([currentCrumbContext valueForKey:@"_breadcrumbAppBundleID"]);

    // if its nil, try the other options
    if(!iconImage) {
        NSString *imageName;
        if([[currentCrumbContext valueForKey:@"_wasFromSpotlight"] boolValue]) {
            // spotlight
            imageName = @"magnifyingglass";
        } else if([[currentCrumbContext valueForKey:@"_wasFromAssistant"] boolValue]) {
            // assistant/siri
            imageName = @"person.circle";
        }

        if(@available(iOS 13, *)) {
            iconImage = [UIImage systemImageNamed:imageName];
        }

        // so we can color it white, return template render
        return [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    }

    return iconImage;

}

%new
- (void)addCrumbImage {
    if(crumbImageView) return;

    UIImage *iconImage = [self getCrumbImage];

    if(iconImage) {
        // add image
        crumbImageView = [[UIImageView alloc] initWithImage:iconImage];
        crumbImageView.tintColor = UIColor.labelColor;
        [self addSubview:crumbImageView];

        // layout
        crumbImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [crumbImageView.heightAnchor constraintEqualToConstant:iconSize],
            [crumbImageView.widthAnchor constraintEqualToConstant:iconSize],
            [crumbImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
            [crumbImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];

    }
}

%new
- (void)updateCrumbImage {
    if(crumbImageView) crumbImageView.image = [self getCrumbImage];
}

%end


static void loadTweak(int __unused argc, char __unused **argv, char __unused **envp) __attribute__((constructor)) {
    NSUserDefaults *tpf = [[NSUserDefaults alloc] initWithSuiteName:@"com.burritoz.croutonprefs"];
    enabled = [tpf objectForKey:@"enabled"] ? [[tpf objectForKey:@"enabled"] boolValue] : YES;
    iconSize = [tpf objectForKey:@"iconSize"] ? [[tpf objectForKey:@"iconSize"] doubleValue] : 15;

    if(enabled) {
        %init();
        NSLog(@"[croutons13]: Loaded");
    }

}

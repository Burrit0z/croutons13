#import "CRTHeaderCell.h"

// thanks renai
static inline NSString *getPackageVersion() {
    NSString *packageVersion = [NSString stringWithFormat:@"${%@}", @"Version"];
    int status;

    NSMutableArray<NSString *> *argsv0 = [NSMutableArray array];
    for (NSString *string in @[ @"/usr/bin/dpkg-query", @"-Wf", packageVersion, @"com.burritoz.croutons13" ]) {
        [argsv0 addObject:[NSString stringWithFormat:@"'%@'", [string stringByReplacingOccurrencesOfString:@"'" withString:@"\\'" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)]]];
    }

    NSString *argsv1 = [argsv0 componentsJoinedByString:@" "];
    FILE *file = popen(argsv1.UTF8String, "r");
    if (!file) {
        return nil;
    }

    char data[1024];
    NSMutableString *output = [NSMutableString string];

    while (fgets(data, 1024, file) != NULL) {
        [output appendString:[NSString stringWithUTF8String:data]];
    }

    int result = pclose(file);
    status = result;

    // wtf why bro this is free
    if (status == 0) {
        return output ?: @"🏴‍☠️ Pirated";
    }

    return @"🏴‍☠️ Pirated";
}

@implementation CRTHeaderCell // Header Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
	    UILabel *tweakLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.contentView.bounds.size.width + 30, 50)];
	    [tweakLabel setTextAlignment:NSTextAlignmentLeft];
	    [tweakLabel setFont:[UIFont systemFontOfSize:50 weight:UIFontWeightRegular]];
	    tweakLabel.text = @"Croutons13";

	    UILabel *devLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.contentView.bounds.size.width + 30, 50)];
	    [devLabel setTextAlignment:NSTextAlignmentLeft];
	    [devLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium]];
	    devLabel.alpha = 0.8;
	    devLabel.text = getPackageVersion();

	    UIImage *logo = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/croutons13prefs.bundle/iconFullSize.png"];
	    UIImageView *icon = [[UIImageView alloc] initWithImage:logo];
	    icon.translatesAutoresizingMaskIntoConstraints = NO;
        icon.userInteractionEnabled = YES;

	    [self addSubview:tweakLabel];
	    [self addSubview:devLabel];
	    [self addSubview:icon];

	    [icon.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
	    [icon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
	    [icon.widthAnchor constraintEqualToConstant:70].active = YES;
	    [icon.heightAnchor constraintEqualToConstant:70].active = YES;

	    icon.layer.masksToBounds = YES;
	    icon.layer.cornerRadius = 15;
    }

    return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRTHeaderCell" specifier:specifier];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 140.0f;
}

@end

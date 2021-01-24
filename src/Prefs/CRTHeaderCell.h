#import <Preferences/PSTableCell.h>

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;
@end

@interface CRTHeaderCell : PSTableCell <PreferencesTableCustomView> {
    UIView *bgView;
    UILabel *packageNameLabel;
    UILabel *developerLabel;
    UILabel *versionLabel;
}
@end

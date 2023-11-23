
import SwiftUI

extension View {
    
    func applyHeaderTitleStyle() -> some View {
        self.modifier(HeaderTitleStyleModifier())
    }
    
    func applySubHeaderTitleStyle() -> some View {
        self.modifier(SubHeaderTitleStyleModifier())
    }
    
    func applySectionHeaderTitleStyle() -> some View {
        self.modifier(SectionHeaderTitleStyleModifier())
    }
    
    func applyTitleStyle() -> some View {
        self.modifier(TitleStyleModifier())
    }
    
    func applyBodyStyle() -> some View {
        self.modifier(BodyStyleModifier())
    }
    
    func applyCalloutStyle() -> some View {
        self.modifier(CalloutStyleModifier())
    }
    
    func applyButtonTitleStyle() -> some View {
        self.modifier(ButtonTitleStyleModifier())
    }
    
    func applyBlurredStyle() -> some View {
        self.modifier(BlurredStyleModifier())
    }
    
    func applyRoundedBorderStyle() -> some View {
        self.modifier(RoundedBorderStyleModifier())
    }
    
    func applyHiddenStyle(isHidden: Bool) -> some View {
        self.modifier(ViewHideModifier(flag: isHidden))
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

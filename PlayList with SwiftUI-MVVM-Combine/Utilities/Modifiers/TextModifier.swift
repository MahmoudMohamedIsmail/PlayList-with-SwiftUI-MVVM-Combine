
import SwiftUI

struct HeaderTitleStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.semiBold, size: 22))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct SubHeaderTitleStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.regular, size: 12))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct SectionHeaderTitleStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.semiBold, size: 15))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct TitleStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.semiBold, size: 12))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct BodyStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.regular, size: 10))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct CalloutStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.light, size: 8))
            .multilineTextAlignment(TextAlignment.leading)
    }
}

struct ButtonTitleStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(AppFont.medium, size: 15))
    }
}

struct BlurredStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.black.opacity(0.12))
    }
}

struct RoundedBorderStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(AppColors.border, lineWidth: 1)
                    .foregroundColor(.clear)
            )
    }
}


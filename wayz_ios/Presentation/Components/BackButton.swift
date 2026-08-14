//
//  BackButton.swift
//  wayz_ios
//
//  Created by Macbook on 13/8/26.
//

import SwiftUI

struct BackButton: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        Button {
            router.pop()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .medium))
        }
    }
}

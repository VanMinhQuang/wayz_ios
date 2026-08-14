//
//  ChatRowView.swift
//  wayz_ios
//
//  Created by Macbook on 12/8/26.
//

import SwiftUI

struct ChatRowView: View {
    let chat: UserChat
 
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: chat.avatar)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
                    .padding(14)
                    .frame(width: 56, height: 56)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
 
                if chat.isOnline {
                    Circle()
                        .fill(.green)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }
 
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.system(size: 16, weight: chat.unReadCount > 0 ? .semibold : .regular))
 
                Text(chat.lastMessage)
                    .font(.system(size: 14, weight: chat.unReadCount > 0 ? .medium : .regular))
                    .foregroundStyle(chat.unReadCount > 0 ? .primary : .secondary)
                    .lineLimit(1)
            }
 
            Spacer()
 
            VStack(alignment: .trailing, spacing: 6) {
                Text(chat.time)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
 
                if chat.unReadCount > 0 {
                    Text("\(chat.unReadCount)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(Circle().fill(.blue))
                } else {
                    // giữ chỗ để các dòng thẳng hàng
                    Color.clear.frame(width: 18, height: 18)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

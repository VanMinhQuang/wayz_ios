//
//  PlaceDetailSheet.swift
//  wayz_ios
//

import SkeletonUI
import SwiftUI
import PhotosUI

/// Full detail sheet for a place: photo gallery, rating, description,
/// tags, and quick actions. Presented from the map's selected-place card.
struct PlaceDetailSheet: View {
    let place: Places
    let onNavigate: () -> Void
    let placesRepository: PlacesRepositoryProtocol
    @Environment(\.appTheme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailTab = .about

    /// Local, session-only copy of the place's comments so new comments and
    /// replies posted from the composer can be appended without mutating `place`.
    /// Seeded from `place.comments` (usually empty — list/detail responses
    /// don't inline comments) and refreshed from the network in `.task`.
    @State private var comments: [Comment]
    @State private var isLoadingComments = true

    @State private var draftText: String = ""
    @State private var draftImages: [Data] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var replyingToID: String?
    @State private var showEmojiPicker = false
    @State private var viewerContext: ImageViewerContext?

    init(place: Places, onNavigate: @escaping () -> Void, placesRepository: PlacesRepositoryProtocol) {
        self.place = place
        self.onNavigate = onNavigate
        self.placesRepository = placesRepository
        _comments = State(initialValue: place.comments)
    }

    private func loadComments() async {
        // Best-effort: on failure, keep whatever `comments` already has.
        if let fetched = try? await placesRepository.fetchComments(placeId: place.id) {
            comments = fetched
        }
        isLoadingComments = false
    }

    private enum DetailTab: String, CaseIterable {
        case about = "About"
        case comments = "Comments"
        case images = "Images"
    }

    private struct ImageViewerContext: Identifiable {
        let id = UUID()
        let images: [CommentImage]
        let startIndex: Int
    }

    private var typeStyle: (color: UIColor, symbolName: String) {
        PlaceTypeStyle.style(for: place.type)
    }

    /// All images for the place: its own gallery plus every photo attached to a
    /// comment or reply (both seeded and freshly composed).
    private var allDisplayImages: [CommentImage] {
        place.images.map(CommentImage.remote) + flattenImages(comments)
    }

    private func flattenImages(_ comments: [Comment]) -> [CommentImage] {
        comments.flatMap { comment in
            comment.allImages + flattenImages(comment.replies)
        }
    }

    private var canSend: Bool {
        !draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !draftImages.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                gallery

                VStack(alignment: .leading, spacing: 16) {
                    header
                    infoRow
                }
                .padding(.horizontal, 20)

                tabBar

                tabContent
                    .padding(.horizontal, 20)

                Spacer(minLength: 8)
            }
            .padding(.bottom, 12)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if selectedTab == .comments {
                commentComposer
            } else {
                actionBar
            }
        }
        .background(theme.colors.background)
        .task { await loadComments() }
        .fullScreenCover(item: $viewerContext) { context in
            ImageViewerSheet(images: context.images, startIndex: context.startIndex)
        }
    }

    // MARK: Gallery

    private var gallery: some View {
        TabView {
            ForEach(place.images.isEmpty ? [""] : place.images, id: \.self) { url in
                AsyncImage(url: URL(string: url)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        Color(UIColor.systemGray5)
                    }
                }
                .clipped()
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(height: 260)
        .overlay(alignment: .topLeading) {
            closeButton
                .padding(.top, 16)
                .padding(.leading, 16)
        }
    }

    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .background(.regularMaterial, in: Circle())
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(place.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(theme.colors.textPrimary)

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < place.rating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundStyle(.yellow)
                    }
                    Text("\(place.participants) visited")
                        .font(.system(size: 13))
                        .foregroundStyle(theme.colors.textSecondary)
                        .padding(.leading, 4)
                }
            }

            Spacer()

            Image(systemName: typeStyle.symbolName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(typeStyle.color))
                .frame(width: 40, height: 40)
                .background(Color(typeStyle.color).opacity(0.14), in: Circle())
        }
    }

    // MARK: Info row (address + hours)

    private var infoRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            infoLine(icon: "mappin.and.ellipse", text: place.address)
            infoLine(icon: "clock", text: place.timeOpen)
        }
        .padding(14)
        .background(theme.colors.surface, in: RoundedRectangle(cornerRadius: 14))
    }

    private func infoLine(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(theme.colors.primary)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(theme.colors.textPrimary)
                .lineLimit(2)
        }
    }

    // MARK: Tab bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                tabBarItem(tab)
            }
        }
        .padding(.horizontal, 20)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private func tabBarItem(_ tab: DetailTab) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack(spacing: 8) {
                Text(tab.rawValue)
                    .font(.system(size: 14, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundStyle(selectedTab == tab ? theme.colors.textPrimary : theme.colors.textSecondary)

                Rectangle()
                    .fill(selectedTab == tab ? theme.colors.primary : .clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .about:
            aboutContent
        case .comments:
            commentsContent
        case .images:
            imagesContent
        }
    }

    // MARK: About tab

    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !place.description.isEmpty {
                description
            }
            if !place.suitedFor.isEmpty {
                tagSection(title: "Suited for", items: place.suitedFor, tint: theme.colors.primary)
            }
            if !place.utilities.isEmpty {
                tagSection(title: "Amenities", items: place.utilities, tint: theme.colors.secondary)
            }
        }
        .padding(.top, 16)
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("About")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(theme.colors.textPrimary)
            Text(place.description)
                .font(.system(size: 14))
                .foregroundStyle(theme.colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Comments tab

    /// Stands in for a real comment while `isLoadingComments`, so the real
    /// `commentRow` view itself can be skeletonized instead of duplicating
    /// its layout in a separate placeholder view.
    private static let placeholderComment = Comment(
        id: "placeholder",
        authorName: "Loading name",
        authorAvatarURL: "",
        date: "",
        text: "Loading comment text that spans a couple of lines."
    )

    private var commentsContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            if isLoadingComments {
                ForEach(0..<3, id: \.self) { _ in
                    commentRow(Self.placeholderComment, isReply: false, replyTargetID: "")
                        .skeleton(active: true)
                        .disabled(true)
                }
            } else if comments.isEmpty {
                Text("No comments yet.")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.colors.textSecondary)
                    .padding(.top, 16)
            } else {
                ForEach(comments) { comment in
                    VStack(alignment: .leading, spacing: 10) {
                        commentRow(comment, isReply: false, replyTargetID: comment.id)

                        if !comment.replies.isEmpty {
                            repliesThread(comment.replies, parentID: comment.id)
                        }
                    }
                }
            }
        }
        .padding(.top, 16)
    }

    /// A reply thread indented under its parent, with a thin connecting rail
    /// on the leading edge — the classic Facebook/thread-reply look.
    private func repliesThread(_ replies: [Comment], parentID: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(replies) { reply in
                commentRow(reply, isReply: true, replyTargetID: parentID)
            }
        }
        .padding(.leading, 18)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(theme.colors.textSecondary.opacity(0.2))
                .frame(width: 2)
        }
        .padding(.leading, 28)
    }

    /// Renders both top-level comments and replies as a chat-style bubble:
    /// name + rating + text hug their own width, with the timestamp and
    /// "Reply" action underneath — outside the bubble, Facebook-style.
    private func commentRow(_ comment: Comment, isReply: Bool, replyTargetID: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: comment.authorAvatarURL)) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Color(UIColor.systemGray5)
                }
            }
            .frame(width: isReply ? 28 : 36, height: isReply ? 28 : 36)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(comment.authorName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)

                    if comment.rating > 0 {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < comment.rating ? "star.fill" : "star")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }

                    Text(comment.text)
                        .font(.system(size: 14))
                        .foregroundStyle(theme.colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(theme.colors.surface, in: RoundedRectangle(cornerRadius: 16))

                if !comment.allImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(comment.allImages.enumerated()), id: \.element.id) { index, image in
                                commentImageThumbnail(image)
                                    .frame(width: 84, height: 84)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .clipped()
                                    .onTapGesture {
                                        viewerContext = ImageViewerContext(images: comment.allImages, startIndex: index)
                                    }
                            }
                        }
                    }
                }

                HStack(spacing: 14) {
                    Text(comment.date)
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)

                    Button(action: {
                        startReplying(to: replyTargetID, mentioning: isReply ? comment.authorName : nil)
                    }) {
                        Text("Reply")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                }
                .padding(.leading, 12)
            }
        }
    }

    @ViewBuilder
    private func commentImageThumbnail(_ image: CommentImage) -> some View {
        switch image {
        case .remote(let url):
            AsyncImage(url: URL(string: url)) { phase in
                if let img = phase.image {
                    img.resizable().scaledToFill()
                } else {
                    Color(UIColor.systemGray5)
                }
            }
        case .local(let data):
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().scaledToFill()
            } else {
                Color(UIColor.systemGray5)
            }
        }
    }

    /// Replying to a reply still posts into the same thread (one level deep) —
    /// like Facebook, it just mentions the reply's author in the draft.
    private func startReplying(to commentID: String, mentioning name: String? = nil) {
        replyingToID = commentID
        if let name {
            draftText = "@\(name) "
        }
        showEmojiPicker = false
    }

    // MARK: Images tab

    private let imagesColumnSpacing: CGFloat = 8
    private let imagesHorizontalPadding: CGFloat = 20

    /// Deterministic height cycle used to give the masonry grid a staggered
    /// look even though the underlying photos share the same aspect ratio.
    private static let staggerHeights: [CGFloat] = [150, 210, 180, 230, 160, 200]

    private func staggerHeight(forIndex index: Int) -> CGFloat {
        Self.staggerHeights[index % Self.staggerHeights.count]
    }

    /// A sheet spans the full device width regardless of its presentation
    /// detent, so the screen width is a safe basis for the column width.
    /// Without an explicit width, `scaledToFill()` derives one from each
    /// photo's own aspect ratio, and landscape photos then overflow the
    /// column and force the whole sheet wider.
    private var imagesColumnWidth: CGFloat {
        (UIScreen.width - imagesHorizontalPadding * 2 - imagesColumnSpacing) / 2
    }

    private var imagesContent: some View {
        let images = allDisplayImages
        return Group {
            if images.isEmpty {
                Text("No images yet.")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.colors.textSecondary)
                    .padding(.top, 16)
            } else {
                let indexed = Array(images.enumerated())
                HStack(alignment: .top, spacing: imagesColumnSpacing) {
                    staggerColumn(images: indexed.filter { $0.offset % 2 == 0 }, allImages: images)
                    staggerColumn(images: indexed.filter { $0.offset % 2 == 1 }, allImages: images)
                }
                .padding(.top, 16)
            }
        }
    }

    private func staggerColumn(images: [(offset: Int, element: CommentImage)], allImages: [CommentImage]) -> some View {
        VStack(spacing: 8) {
            ForEach(images, id: \.element.id) { index, image in
                commentImageThumbnail(image)
                    .frame(width: imagesColumnWidth, height: staggerHeight(forIndex: index))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .onTapGesture {
                        viewerContext = ImageViewerContext(images: allImages, startIndex: index)
                    }
            }
        }
    }

    // MARK: Tags

    private func tagSection(title: String, items: [String], tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(theme.colors.textPrimary)

            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(tint)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(tint.opacity(0.12), in: Capsule())
                }
            }
        }
    }

    // MARK: Action bar

    private var actionBar: some View {
        Button(action: {
            onNavigate()
            dismiss()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "location.north.fill")
                    .font(.system(size: 14, weight: .semibold))
                Text("Directions")
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(theme.colors.primary, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(alignment: .top) {
            theme.colors.background
                .overlay(alignment: .top) {
                    Divider()
                }
        }
    }

    // MARK: Comment composer

    private var commentComposer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()

            if let replyingToID, let target = comments.first(where: { $0.id == replyingToID }) {
                HStack {
                    Text("Replying to \(target.authorName)")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)
                    Spacer()
                    Button(action: { self.replyingToID = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }

            if !draftImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(draftImages.enumerated()), id: \.offset) { index, data in
                            draftImageThumbnail(data, index: index)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 8)
            }

            if showEmojiPicker {
                emojiPicker
            }

            HStack(spacing: 10) {
                Button(action: { showEmojiPicker.toggle() }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 20))
                        .foregroundStyle(theme.colors.textSecondary)
                }

                PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 4, matching: .images) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 20))
                        .foregroundStyle(theme.colors.textSecondary)
                }

                TextField("Add a comment...", text: $draftText, axis: .vertical)
                    .font(.system(size: 14))
                    .foregroundStyle(theme.colors.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(theme.colors.surface, in: Capsule())

                Button(action: sendComment) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(canSend ? theme.colors.primary : theme.colors.textSecondary.opacity(0.4))
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(theme.colors.background)
        .onChange(of: selectedPhotoItems) { _, items in
            guard !items.isEmpty else { return }
            Task {
                var datas: [Data] = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        datas.append(data)
                    }
                }
                draftImages.append(contentsOf: datas)
                selectedPhotoItems = []
            }
        }
    }

    private func draftImageThumbnail(_ data: Data, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
            }
            Button(action: { draftImages.remove(at: index) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.white, .black.opacity(0.6))
            }
            .offset(x: 6, y: -6)
        }
    }

    private var emojiPicker: some View {
        let emojis = ["😀", "😂", "😍", "👍", "🙌", "🔥", "❤️", "🎉", "😢", "😮", "🙏", "👏"]
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: { draftText += emoji }) {
                        Text(emoji)
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    private func sendComment() {
        guard canSend else { return }

        let newComment = Comment(
            id: UUID().uuidString,
            authorName: "You",
            authorAvatarURL: "https://picsum.photos/seed/currentuser/100/100",
            date: "Just now",
            text: draftText.trimmingCharacters(in: .whitespacesAndNewlines),
            localImages: draftImages
        )

        if let replyingToID, let index = comments.firstIndex(where: { $0.id == replyingToID }) {
            comments[index].replies.append(newComment)
        } else {
            comments.append(newComment)
        }

        draftText = ""
        draftImages = []
        replyingToID = nil
        showEmojiPicker = false
    }
}

/// Full-screen, swipeable viewer for a place's photos — opened by tapping any
/// thumbnail in the Images tab or a comment's photo strip.
private struct ImageViewerSheet: View {
    let images: [CommentImage]
    let startIndex: Int
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int

    init(images: [CommentImage], startIndex: Int) {
        self.images = images
        self.startIndex = startIndex
        _currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.element.id) { index, image in
                    displayImage(image)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(.black.opacity(0.4), in: Circle())
            }
            .padding(.top, 56)
            .padding(.leading, 16)
        }
    }

    @ViewBuilder
    private func displayImage(_ image: CommentImage) -> some View {
        switch image {
        case .remote(let url):
            AsyncImage(url: URL(string: url)) { phase in
                if let img = phase.image {
                    img.resizable().scaledToFit()
                } else {
                    ProgressView().tint(.white)
                }
            }
        case .local(let data):
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().scaledToFit()
            }
        }
    }
}

/// Simple wrapping layout for tag chips, since `HStack` doesn't wrap.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var origin = CGPoint.zero
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if origin.x + size.width > width, origin.x > 0 {
                origin.x = 0
                origin.y += rowHeight + spacing
                rowHeight = 0
            }
            origin.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxWidth = max(maxWidth, origin.x - spacing)
        }

        return CGSize(width: maxWidth, height: origin.y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if origin.x + size.width > bounds.maxX, origin.x > bounds.minX {
                origin.x = bounds.minX
                origin.y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: origin, proposal: .unspecified)
            origin.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

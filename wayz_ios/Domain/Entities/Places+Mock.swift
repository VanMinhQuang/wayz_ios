//
//  Places+Mock.swift
//  wayz_ios
//
//  Dummy data for previews, mock data sources, and UI development.
//  Gate usage behind `AppConfig.current.isMockDataEnabled` where appropriate.
//

extension Places {
    static let mockData: [Places] = [
        Places(
            id: "place_001",
            name: "Nhà Hàng Cơm Tấm Sài Gòn",
            type: .RESTAURANT,
            description: "Quán cơm tấm gia truyền hơn 20 năm, nổi tiếng với sườn nướng mật ong và không gian sân vườn thoáng mát.",
            participants: 128,
            rating: 4,
            images: [
                "https://picsum.photos/seed/place001a/800/600",
                "https://picsum.photos/seed/place001b/800/600"
            ],
            address: "12 Lê Lợi, Quận 1, TP. Hồ Chí Minh",
            timeOpen: "10:00 - 22:00",
            suitedFor: ["Gia đình", "Bạn bè", "Đồng nghiệp"],
            utilities: ["Wifi miễn phí", "Bãi đỗ xe", "Giao hàng"],
            latitude: 10.7729,
            longitude: 106.7009,
            comments: [
                Comment(
                    id: "cmt_001_1",
                    authorName: "Minh Anh",
                    authorAvatarURL: "https://picsum.photos/seed/avatar001/100/100",
                    rating: 5,
                    date: "2 ngày trước",
                    text: "Sườn nướng mật ong ngon xuất sắc, không gian sân vườn rất thoáng và mát mẻ.",
                    images: [
                        "https://picsum.photos/seed/cmt001a/600/800",
                        "https://picsum.photos/seed/cmt001b/600/450"
                    ],
                    replies: [
                        Comment(
                            id: "cmt_001_1_r1",
                            authorName: "Nhà Hàng Cơm Tấm Sài Gòn",
                            authorAvatarURL: "https://picsum.photos/seed/place001owner/100/100",
                            date: "1 ngày trước",
                            text: "Cảm ơn bạn đã ghé quán, hẹn gặp lại lần sau nhé! 🙏"
                        ),
                        Comment(
                            id: "cmt_001_1_r2",
                            authorName: "Quốc Huy",
                            authorAvatarURL: "https://picsum.photos/seed/avatar015/100/100",
                            date: "20 giờ trước",
                            text: "Đồng ý, mình cũng mê món này 😍"
                        )
                    ]
                ),
                Comment(
                    id: "cmt_001_2",
                    authorName: "Trần Bảo",
                    authorAvatarURL: "https://picsum.photos/seed/avatar002/100/100",
                    rating: 4,
                    date: "1 tuần trước",
                    text: "Giá cả hợp lý, phục vụ nhanh. Cuối tuần khá đông nên nên đặt bàn trước.",
                    images: []
                )
            ]
        ),
        Places(
            id: "place_002",
            name: "The Workshop Coffee",
            type: .COFFEE,
            description: "Quán cà phê phong cách công nghiệp, chuyên pha chế specialty coffee, phù hợp làm việc và học tập.",
            participants: 342,
            rating: 5,
            images: [
                "https://picsum.photos/seed/place002a/800/600",
                "https://picsum.photos/seed/place002b/800/600",
                "https://picsum.photos/seed/place002c/800/600"
            ],
            address: "27 Ngô Đức Kế, Quận 1, TP. Hồ Chí Minh",
            timeOpen: "07:00 - 21:00",
            suitedFor: ["Làm việc", "Học tập", "Hẹn gặp"],
            utilities: ["Wifi miễn phí", "Ổ cắm điện", "Điều hòa", "Đồ uống mang đi"],
            latitude: 10.7745,
            longitude: 106.7048,
            comments: [
                Comment(
                    id: "cmt_002_1",
                    authorName: "Ngọc Hà",
                    authorAvatarURL: "https://picsum.photos/seed/avatar003/100/100",
                    rating: 5,
                    date: "3 ngày trước",
                    text: "Cà phê specialty rất chuẩn vị, bàn ghế thoải mái để ngồi làm việc cả buổi.",
                    images: [
                        "https://picsum.photos/seed/cmt002a/600/750"
                    ],
                    replies: [
                        Comment(
                            id: "cmt_002_1_r1",
                            authorName: "The Workshop Coffee",
                            authorAvatarURL: "https://picsum.photos/seed/place002owner/100/100",
                            date: "2 ngày trước",
                            text: "Cảm ơn Ngọc Hà, chúc bạn làm việc năng suất! ☕️"
                        )
                    ]
                ),
                Comment(
                    id: "cmt_002_2",
                    authorName: "Đức Huy",
                    authorAvatarURL: "https://picsum.photos/seed/avatar004/100/100",
                    rating: 5,
                    date: "5 ngày trước",
                    text: "Wifi mạnh, nhiều ổ cắm, rất phù hợp cho dân freelancer như mình.",
                    images: [
                        "https://picsum.photos/seed/cmt002b/600/500",
                        "https://picsum.photos/seed/cmt002c/600/650"
                    ]
                ),
                Comment(
                    id: "cmt_002_3",
                    authorName: "Lan Phương",
                    authorAvatarURL: "https://picsum.photos/seed/avatar005/100/100",
                    rating: 4,
                    date: "2 tuần trước",
                    text: "Không gian đẹp, hơi ồn vào giờ cao điểm buổi sáng.",
                    images: []
                )
            ]
        ),
        Places(
            id: "place_003",
            name: "Cocoon Bistro & Drinks",
            type: .DRINK,
            description: "Không gian ấm cúng phục vụ mocktail và cocktail sáng tạo, nhạc acoustic vào cuối tuần.",
            participants: 89,
            rating: 4,
            images: [
                "https://picsum.photos/seed/place003a/800/600"
            ],
            address: "45 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh",
            timeOpen: "17:00 - 00:00",
            suitedFor: ["Hẹn hò", "Bạn bè", "Sinh nhật"],
            utilities: ["Nhạc sống", "Wifi miễn phí", "Khu vực ngoài trời"],
            latitude: 10.7745,
            longitude: 106.7038,
            comments: [
                Comment(
                    id: "cmt_003_1",
                    authorName: "Gia Bảo",
                    authorAvatarURL: "https://picsum.photos/seed/avatar006/100/100",
                    rating: 4,
                    date: "1 ngày trước",
                    text: "Mocktail sáng tạo, ban nhạc acoustic cuối tuần chơi rất hay.",
                    images: [
                        "https://picsum.photos/seed/cmt003a/600/800"
                    ]
                )
            ]
        ),
        Places(
            id: "place_004",
            name: "Lush Rooftop Club",
            type: .CLUB,
            description: "Rooftop bar view thành phố, DJ quốc tế mỗi tối thứ Sáu, khu VIP riêng tư.",
            participants: 210,
            rating: 4,
            images: [
                "https://picsum.photos/seed/place004a/800/600",
                "https://picsum.photos/seed/place004b/800/600"
            ],
            address: "8 Tôn Đức Thắng, Quận 1, TP. Hồ Chí Minh",
            timeOpen: "19:00 - 02:00",
            suitedFor: ["Tiệc nhóm", "Sinh nhật", "Sự kiện công ty"],
            utilities: ["Khu VIP", "Bãi đỗ xe", "Đặt bàn trước", "Thanh toán thẻ"],
            latitude: 10.7815,
            longitude: 106.7057,
            comments: [
                Comment(
                    id: "cmt_004_1",
                    authorName: "Anh Khoa",
                    authorAvatarURL: "https://picsum.photos/seed/avatar012/100/100",
                    rating: 5,
                    date: "12 giờ trước",
                    text: "View thành phố tuyệt đẹp, DJ tối thứ Sáu chơi rất sung, khu VIP riêng tư đáng tiền.",
                    images: [
                        "https://picsum.photos/seed/cmt004a/600/800"
                    ]
                ),
                Comment(
                    id: "cmt_004_2",
                    authorName: "Thảo My",
                    authorAvatarURL: "https://picsum.photos/seed/avatar013/100/100",
                    rating: 4,
                    date: "4 ngày trước",
                    text: "Không gian sang trọng, giá đồ uống hơi cao nhưng xứng đáng cho dịp đặc biệt.",
                    images: []
                )
            ]
        ),
        Places(
            id: "place_005",
            name: "Nova Nightclub",
            type: .NIGHTCLUB,
            description: "Sàn nhảy lớn nhất khu vực trung tâm, hệ thống âm thanh ánh sáng hiện đại, line-up DJ hàng tuần.",
            participants: 476,
            rating: 4,
            images: [
                "https://picsum.photos/seed/place005a/800/600",
                "https://picsum.photos/seed/place005b/800/600",
                "https://picsum.photos/seed/place005c/800/600"
            ],
            address: "60 Đồng Khởi, Quận 1, TP. Hồ Chí Minh",
            timeOpen: "21:00 - 04:00",
            suitedFor: ["Tiệc nhóm", "Độc thân", "Sự kiện đặc biệt"],
            utilities: ["Bảo vệ 24/7", "Khu VIP", "Giữ đồ", "Đặt bàn trước"],
            latitude: 10.7765,
            longitude: 106.7040,
            comments: [
                Comment(
                    id: "cmt_005_1",
                    authorName: "Thanh Tùng",
                    authorAvatarURL: "https://picsum.photos/seed/avatar007/100/100",
                    rating: 5,
                    date: "4 giờ trước",
                    text: "Âm thanh ánh sáng cực đỉnh, DJ chơi rất máu, đáng để trải nghiệm.",
                    images: [
                        "https://picsum.photos/seed/cmt005a/600/700",
                        "https://picsum.photos/seed/cmt005b/600/900"
                    ]
                ),
                Comment(
                    id: "cmt_005_2",
                    authorName: "Kim Chi",
                    authorAvatarURL: "https://picsum.photos/seed/avatar008/100/100",
                    rating: 4,
                    date: "3 ngày trước",
                    text: "Đông người vào cuối tuần, nên đến sớm để có chỗ đẹp.",
                    images: [
                        "https://picsum.photos/seed/cmt005c/600/600"
                    ]
                )
            ]
        ),
        Places(
            id: "place_006",
            name: "SkyLine Badminton & Pickleball",
            type: .SPORT,
            description: "Cụm sân cầu lông và pickleball trong nhà, sàn gỗ chuẩn thi đấu, có huấn luyện viên hỗ trợ.",
            participants: 65,
            rating: 5,
            images: [
                "https://picsum.photos/seed/place006a/800/600"
            ],
            address: "102 Điện Biên Phủ, Bình Thạnh, TP. Hồ Chí Minh",
            timeOpen: "06:00 - 23:00",
            suitedFor: ["Thể thao", "Đồng nghiệp", "Gia đình"],
            utilities: ["Cho thuê vợt", "Phòng thay đồ", "Nước uống", "Bãi đỗ xe"],
            latitude: 10.8020,
            longitude: 106.7100,
            comments: [
                Comment(
                    id: "cmt_006_1",
                    authorName: "Việt Anh",
                    authorAvatarURL: "https://picsum.photos/seed/avatar009/100/100",
                    rating: 5,
                    date: "6 ngày trước",
                    text: "Sàn gỗ chuẩn thi đấu, huấn luyện viên nhiệt tình chỉ dẫn kỹ thuật.",
                    images: []
                )
            ]
        ),
        Places(
            id: "place_007",
            name: "Mì Cay Sasin",
            type: .RESTAURANT,
            description: "Quán mì cay Hàn Quốc 7 cấp độ, không gian trẻ trung, phù hợp nhóm bạn thử thách độ cay.",
            participants: 156,
            rating: 3,
            images: [
                "https://picsum.photos/seed/place007a/800/600",
                "https://picsum.photos/seed/place007b/800/600"
            ],
            address: "20 Phan Xích Long, Phú Nhuận, TP. Hồ Chí Minh",
            timeOpen: "10:30 - 21:30",
            suitedFor: ["Bạn bè", "Thử thách", "Sinh viên"],
            utilities: ["Wifi miễn phí", "Điều hòa", "Đặt món online"],
            latitude: 10.7975,
            longitude: 106.6890,
            comments: [
                Comment(
                    id: "cmt_007_1",
                    authorName: "Quốc Bảo",
                    authorAvatarURL: "https://picsum.photos/seed/avatar014/100/100",
                    rating: 3,
                    date: "2 ngày trước",
                    text: "Cấp độ 7 cay xé lưỡi thật sự, không gian trẻ trung hợp đi nhóm bạn.",
                    images: [
                        "https://picsum.photos/seed/cmt007a/600/450",
                        "https://picsum.photos/seed/cmt007b/600/800"
                    ]
                )
            ]
        ),
        Places(
            id: "place_008",
            name: "Chill Garden Café",
            type: .COFFEE,
            description: "Cà phê sân vườn nhiều cây xanh, tiểu cảnh sống ảo, đồ uống trái cây tươi.",
            participants: 203,
            rating: 4,
            images: [
                "https://picsum.photos/seed/place008a/800/600",
                "https://picsum.photos/seed/place008b/800/600"
            ],
            address: "15 Trần Não, Quận 2, TP. Hồ Chí Minh",
            timeOpen: "06:30 - 22:30",
            suitedFor: ["Chụp ảnh", "Gia đình", "Hẹn hò"],
            utilities: ["Bãi đỗ xe", "Khu vực ngoài trời", "Wifi miễn phí", "Pet friendly"],
            latitude: 10.8020,
            longitude: 106.7350,
            comments: [
                Comment(
                    id: "cmt_008_1",
                    authorName: "Phương Linh",
                    authorAvatarURL: "https://picsum.photos/seed/avatar010/100/100",
                    rating: 5,
                    date: "8 giờ trước",
                    text: "Sân vườn xanh mát, chụp ảnh cực đẹp, nước ép trái cây tươi ngon.",
                    images: [
                        "https://picsum.photos/seed/cmt008a/600/800",
                        "https://picsum.photos/seed/cmt008b/600/500",
                        "https://picsum.photos/seed/cmt008c/600/700"
                    ]
                ),
                Comment(
                    id: "cmt_008_2",
                    authorName: "Hoàng Nam",
                    authorAvatarURL: "https://picsum.photos/seed/avatar011/100/100",
                    rating: 4,
                    date: "1 tuần trước",
                    text: "Pet friendly nên mang bé cún theo được, không gian rất thân thiện.",
                    images: [
                        "https://picsum.photos/seed/cmt008d/600/600"
                    ]
                )
            ]
        )
    ]
}

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
            longitude: 106.7009
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
            longitude: 106.7048
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
            longitude: 106.7038
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
            longitude: 106.7057
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
            longitude: 106.7040
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
            longitude: 106.7100
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
            longitude: 106.6890
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
            longitude: 106.7350
        )
    ]
}

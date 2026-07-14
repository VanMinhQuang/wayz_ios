//
//  MapLibreMapView.swift
//  wayz_ios
//
//  SwiftUI wrapper around MapLibre Native (MLNMapView), rendering the
//  MapVina vector tile style, place pins (with photo thumbnails), and an
//  optional route line between two points.
//

import CoreLocation
import MapLibre
import SwiftUI
import UIKit

/// Per-category visuals for place pins: a color (border + badge background)
/// and an SF Symbol shown in the badge.
enum PlaceTypeStyle {
    static func style(for type: PlaceType) -> (color: UIColor, symbolName: String) {
        switch type {
        case .RESTAURANT:
            return (.systemRed, "fork.knife")
        case .COFFEE:
            return (.systemBrown, "cup.and.saucer.fill")
        case .DRINK:
            return (.systemPurple, "wineglass.fill")
        case .CLUB:
            return (.systemIndigo, "party.popper.fill")
        case .NIGHTCLUB:
            return (.systemPink, "music.note")
        case .SPORT:
            return (.systemGreen, "sportscourt.fill")
        }
    }
}

/// A single point + route to render on the map: start (A), end (B), and the
/// path coordinates connecting them (straight line, or a decoded route from
/// a directions provider — either way, this view just draws whatever it's given).
struct MapRoute: Equatable {
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    /// Ordered coordinates from `start` to `end`. Defaults to a straight line
    /// (`[start, end]`) if no richer path (e.g. from a directions API) is available.
    var pathCoordinates: [CLLocationCoordinate2D]

    init(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, pathCoordinates: [CLLocationCoordinate2D]? = nil) {
        self.start = start
        self.end = end
        self.pathCoordinates = pathCoordinates ?? [start, end]
    }

    static func == (lhs: MapRoute, rhs: MapRoute) -> Bool {
        lhs.start.latitude == rhs.start.latitude &&
        lhs.start.longitude == rhs.start.longitude &&
        lhs.end.latitude == rhs.end.latitude &&
        lhs.end.longitude == rhs.end.longitude &&
        lhs.pathCoordinates.count == rhs.pathCoordinates.count
    }
}

/// SwiftUI wrapper for `MLNMapView` using the MapVina style.
struct MapLibreMapView: UIViewRepresentable {
    var styleURL: URL = AppConfig.current.mapVinaStreetsStyleURL
    var centerCoordinate: CLLocationCoordinate2D
    var zoomLevel: Double = 13
    var route: MapRoute?
    var lineColor: UIColor = .systemBlue
    var lineWidth: Double = 4
    /// Places rendered as photo pins, e.g. `mapViewModel.places` / `Places.mockData`.
    var places: [Places] = []
    /// Called when a place pin is tapped.
    var onSelectPlace: ((Places) -> Void)?

    /// Shows the native "blue dot" user location puck (`MLNMapView.showsUserLocation`).
    var showsUserLocation: Bool = false
    /// `.none` for a static map, `.followWithHeading` for a Google-Maps-style
    /// guided navigation camera that follows and rotates with the user.
    var userTrackingMode: MLNUserTrackingMode = .none
    /// Tilts the camera for a 3D "driving" perspective, used in navigation mode.
    var navigationPitch: Double = 0
    /// Called when the map's tracking mode changes — including when MapLibre
    /// itself drops back to `.none` because the user panned/rotated the map
    /// by hand. Lets the caller (e.g. a "recenter" button) know following is
    /// no longer active.
    var onUserTrackingModeChange: ((MLNUserTrackingMode) -> Void)?

    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView(frame: .zero, styleURL: styleURL)
        mapView.delegate = context.coordinator
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.setCenter(centerCoordinate, zoomLevel: zoomLevel, animated: false)
        mapView.showsUserLocation = showsUserLocation
        mapView.userTrackingMode = userTrackingMode
        return mapView
    }

    func updateUIView(_ mapView: MLNMapView, context: Context) {
        context.coordinator.route = route
        context.coordinator.lineColor = lineColor
        context.coordinator.lineWidth = lineWidth
        context.coordinator.onSelectPlace = onSelectPlace
        context.coordinator.onUserTrackingModeChange = onUserTrackingModeChange
        context.coordinator.syncPlaceAnnotations(places, on: mapView)

        if mapView.showsUserLocation != showsUserLocation {
            mapView.showsUserLocation = showsUserLocation
        }
        if mapView.userTrackingMode != userTrackingMode {
            mapView.userTrackingMode = userTrackingMode
        }
        if navigationPitch > 0, mapView.camera.pitch != navigationPitch {
            let camera = mapView.camera
            camera.pitch = navigationPitch
            mapView.setCamera(camera, animated: true)
        }

        // Style may not be loaded yet on first pass; draw once it is (see delegate),
        // and redraw here on subsequent SwiftUI updates.
        if mapView.style != nil {
            context.coordinator.drawRouteIfNeeded(on: mapView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, MLNMapViewDelegate {
        var route: MapRoute?
        var lineColor: UIColor = .systemBlue
        var lineWidth: Double = 4
        var onSelectPlace: ((Places) -> Void)?
        var onUserTrackingModeChange: ((MLNUserTrackingMode) -> Void)?

        private var placeAnnotationsByID: [String: PlaceAnnotation] = [:]

        private let routeSourceIdentifier = "wayz.route.source"
        private let routeLayerIdentifier = "wayz.route.line-layer"
        private let startSourceIdentifier = "wayz.route.start-source"
        private let startLayerIdentifier = "wayz.route.start-layer"
        private let endSourceIdentifier = "wayz.route.end-source"
        private let endLayerIdentifier = "wayz.route.end-layer"

        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            drawRouteIfNeeded(on: mapView, forceRedraw: true)
        }

        /// Fires whenever tracking mode changes, including MapLibre's own
        /// automatic drop to `.none` when the user drags/rotates the map by
        /// hand — this is how we detect "user took over the camera" so a
        /// recenter control can be shown.
        func mapView(_ mapView: MLNMapView, didChange mode: MLNUserTrackingMode, animated: Bool) {
            onUserTrackingModeChange?(mode)
        }

        // MARK: - Place pins (annotation views, so we can show a photo thumbnail)

        /// Add/remove annotations so the map always matches `places`, without
        /// tearing down and re-adding pins that haven't changed.
        func syncPlaceAnnotations(_ places: [Places], on mapView: MLNMapView) {
            let newIDs = Set(places.map(\.id))
            let currentIDs = Set(placeAnnotationsByID.keys)

            let idsToRemove = currentIDs.subtracting(newIDs)
            if !idsToRemove.isEmpty {
                let annotationsToRemove = idsToRemove.compactMap { placeAnnotationsByID[$0] }
                mapView.removeAnnotations(annotationsToRemove)
                idsToRemove.forEach { placeAnnotationsByID.removeValue(forKey: $0) }
            }

            let idsToAdd = newIDs.subtracting(currentIDs)
            guard !idsToAdd.isEmpty else { return }
            let placesToAdd = places.filter { idsToAdd.contains($0.id) }
            let annotationsToAdd = placesToAdd.map { PlaceAnnotation(place: $0) }
            annotationsToAdd.forEach { placeAnnotationsByID[$0.place.id] = $0 }
            mapView.addAnnotations(annotationsToAdd)
        }

        func mapView(_ mapView: MLNMapView, viewFor annotation: MLNAnnotation) -> MLNAnnotationView? {
            guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }

            let identifier = "wayz.place-pin"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? PlaceAnnotationView
                ?? PlaceAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
            annotationView.annotation = placeAnnotation
            annotationView.configure(with: placeAnnotation.place)
            return annotationView
        }

        func mapView(_ mapView: MLNMapView, annotationCanShowCallout annotation: MLNAnnotation) -> Bool {
            false
        }

        func mapView(_ mapView: MLNMapView, didSelect annotation: MLNAnnotation) {
            guard let placeAnnotation = annotation as? PlaceAnnotation else { return }
            onSelectPlace?(placeAnnotation.place)
            // Deselect immediately so the pin can be tapped again to re-trigger the action.
            mapView.deselectAnnotation(annotation, animated: false)
        }

        // MARK: - Route

        func drawRouteIfNeeded(on mapView: MLNMapView, forceRedraw: Bool = false) {
            guard let style = mapView.style else { return }
            guard let route = route else {
                removeRoute(from: style)
                return
            }

            let coordinates = route.pathCoordinates
            guard coordinates.count >= 2 else { return }

            // MARK: Line (path)
            let polyline = MLNPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))

            if let source = style.source(withIdentifier: routeSourceIdentifier) as? MLNShapeSource {
                source.shape = polyline
            } else {
                let source = MLNShapeSource(identifier: routeSourceIdentifier, shape: polyline, options: nil)
                style.addSource(source)

                let lineLayer = MLNLineStyleLayer(identifier: routeLayerIdentifier, source: source)
                lineLayer.lineColor = NSExpression(forConstantValue: lineColor)
                lineLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
                lineLayer.lineCap = NSExpression(forConstantValue: "round")
                lineLayer.lineJoin = NSExpression(forConstantValue: "round")
                style.addLayer(lineLayer)
            }

            // MARK: Start / End markers (separate source+layer each, kept simple & explicit)
            upsertPointMarker(
                coordinate: route.start,
                sourceIdentifier: startSourceIdentifier,
                layerIdentifier: startLayerIdentifier,
                color: .systemGreen,
                style: style
            )
            upsertPointMarker(
                coordinate: route.end,
                sourceIdentifier: endSourceIdentifier,
                layerIdentifier: endLayerIdentifier,
                color: .systemRed,
                style: style
            )
        }

        private func upsertPointMarker(
            coordinate: CLLocationCoordinate2D,
            sourceIdentifier: String,
            layerIdentifier: String,
            color: UIColor,
            style: MLNStyle
        ) {
            let feature = MLNPointFeature()
            feature.coordinate = coordinate

            if let source = style.source(withIdentifier: sourceIdentifier) as? MLNShapeSource {
                source.shape = feature
            } else {
                let source = MLNShapeSource(identifier: sourceIdentifier, shape: feature, options: nil)
                style.addSource(source)

                let circleLayer = MLNCircleStyleLayer(identifier: layerIdentifier, source: source)
                circleLayer.circleRadius = NSExpression(forConstantValue: 7)
                circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
                circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
                circleLayer.circleColor = NSExpression(forConstantValue: color)
                style.addLayer(circleLayer)
            }
        }

        private func removeRoute(from style: MLNStyle) {
            if let layer = style.layer(withIdentifier: routeLayerIdentifier) { style.removeLayer(layer) }
            if let source = style.source(withIdentifier: routeSourceIdentifier) { style.removeSource(source) }
            if let layer = style.layer(withIdentifier: startLayerIdentifier) { style.removeLayer(layer) }
            if let source = style.source(withIdentifier: startSourceIdentifier) { style.removeSource(source) }
            if let layer = style.layer(withIdentifier: endLayerIdentifier) { style.removeLayer(layer) }
            if let source = style.source(withIdentifier: endSourceIdentifier) { style.removeSource(source) }
        }
    }
}

// MARK: - PlaceAnnotation

/// Wraps a `Places` value as a map annotation so MapLibre can position + select it.
final class PlaceAnnotation: NSObject, MLNAnnotation {
    let place: Places

    init(place: Places) {
        self.place = place
    }

    var coordinate: CLLocationCoordinate2D { place.coordinate }
    var title: String? { place.name }
    var subtitle: String? { place.address }
}

// MARK: - PlaceAnnotationView

/// A photo "pin": a circular thumbnail (first image of the place) with a
/// white ring and a small tail, matching the app's marker style elsewhere.
final class PlaceAnnotationView: MLNAnnotationView {
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    private let tailView = TailShapeView()

    private static let pinSize: CGFloat = 44
    private static let tailSize = CGSize(width: 12, height: 8)

    private let badgeContainer = UIView()
    private let badgeImageView = UIImageView()
    private static let badgeSize: CGFloat = 18

    private var currentImageURLString: String?

    override init(annotation: MLNAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let totalHeight = Self.pinSize + Self.tailSize.height
        frame = CGRect(x: 0, y: 0, width: Self.pinSize, height: totalHeight)
        centerOffset = CGVector(dx: 0, dy: -totalHeight / 2)
        backgroundColor = .clear
        scalesWithViewingDistance = false

        imageContainer.frame = CGRect(x: 0, y: 0, width: Self.pinSize, height: Self.pinSize)
        imageContainer.layer.cornerRadius = Self.pinSize / 2
        imageContainer.layer.borderWidth = 2.5
        imageContainer.backgroundColor = UIColor.systemGray4
        imageContainer.layer.shadowColor = UIColor.black.cgColor
        imageContainer.layer.shadowOpacity = 0.25
        imageContainer.layer.shadowRadius = 3
        imageContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageContainer.clipsToBounds = false

        imageView.frame = imageContainer.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Self.pinSize / 2
        imageContainer.addSubview(imageView)

        tailView.frame = CGRect(
            x: (Self.pinSize - Self.tailSize.width) / 2,
            y: Self.pinSize - 2,
            width: Self.tailSize.width,
            height: Self.tailSize.height
        )

        // Category badge — small colored circle + icon, bottom-right of the pin,
        // so the marker still reads clearly even before the thumbnail loads.
        badgeContainer.frame = CGRect(
            x: Self.pinSize - Self.badgeSize + 4,
            y: Self.pinSize - Self.badgeSize + 4,
            width: Self.badgeSize,
            height: Self.badgeSize
        )
        badgeContainer.layer.cornerRadius = Self.badgeSize / 2
        badgeContainer.layer.borderWidth = 1.5
        badgeContainer.layer.borderColor = UIColor.white.cgColor
        badgeContainer.layer.shadowColor = UIColor.black.cgColor
        badgeContainer.layer.shadowOpacity = 0.2
        badgeContainer.layer.shadowRadius = 2
        badgeContainer.layer.shadowOffset = CGSize(width: 0, height: 1)

        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.tintColor = .white
        badgeImageView.frame = badgeContainer.bounds.insetBy(dx: 3.5, dy: 3.5)
        badgeContainer.addSubview(badgeImageView)

        addSubview(imageContainer)
        addSubview(tailView)
        addSubview(badgeContainer)
    }

    func configure(with place: Places) {
        imageView.image = nil
        currentImageURLString = place.images.first
        loadThumbnail(urlString: place.images.first)

        let style = PlaceTypeStyle.style(for: place.type)
        imageContainer.layer.borderColor = style.color.cgColor
        badgeContainer.backgroundColor = style.color
        badgeImageView.image = UIImage(systemName: style.symbolName)
    }

    private func loadThumbnail(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }

        if let cached = ThumbnailCache.shared.image(for: url) {
            imageView.image = cached
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            ThumbnailCache.shared.setImage(image, for: url)
            DispatchQueue.main.async {
                // Guard against the view having been recycled for another place
                // by the time the network response comes back.
                guard self?.currentImageURLString == urlString else { return }
                self?.imageView.image = image
            }
        }.resume()
    }
}

/// Small in-memory thumbnail cache shared across annotation views.
private final class ThumbnailCache {
    static let shared = ThumbnailCache()
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? { cache.object(forKey: url as NSURL) }
    func setImage(_ image: UIImage, for url: URL) { cache.setObject(image, forKey: url as NSURL) }
}

/// Draws the small triangular "tail" beneath a pin, pointing at the coordinate.
private final class TailShapeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.white.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.closePath()
        context.fillPath()
    }
}

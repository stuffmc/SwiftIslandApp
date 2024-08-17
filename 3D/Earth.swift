/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model of the Earth.
*/

import SwiftUI
import RealityKit
import WorldAssets

/// The model of the Earth.
struct Earth: View {
    var earthConfiguration: EarthEntity.Configuration = .init()
    var animateUpdates: Bool = false
    var axCustomActionHandler: ((_: AccessibilityEvents.CustomAction) -> Void)? = nil

    // Magic Numbers for the Rotation of the Globe to map Coordinates...
    private let rotationX: Float = 20
    private let rotationY: Float = 110
    private let rotationZ: Float = 30

    /// The Earth entity that the view creates and stores for later updates.
    @State private var earthEntity: EarthEntity?

    var body: some View {
        RealityView { content, attachments in
            let earthEntity = await EarthEntity(configuration: earthConfiguration)
            if let entity = earthEntity.findEntity(named: "Globe") {
                content.add(entity)
                if let attachment = attachments.entity(for: "country"),
                   let radius = entity.components[CollisionComponent.self]?.shapes.first?.bounds.boundingRadius
                {
                    let coordinate = coordinatesToCartesian(latitude: 50, longitude: 6, radius: radius / 1500)
                    attachment.position = coordinate
                    content.add(attachment)
                }
            }
        } update: { content, attachments in
            // Reconfigure everything when any configuration changes.
            earthEntity?.update(
                configuration: earthConfiguration,
                animateUpdates: animateUpdates)
            if let entity = content.entities.first(where: { $0.name == "Globe" }) {
                // Apply rotation using the Euler angles from sliders
                entity.transform.rotation =
                simd_quatf(angle: rotationX * .pi / 180, axis: [1, 0, 0])
                * simd_quatf(angle: rotationY * .pi / 180, axis: [0, 1, 0])
                * simd_quatf(angle: rotationZ * .pi / 180, axis: [0, 0, 1])
                print(rotationX, rotationY, rotationZ)
            }
        } attachments: {
            Attachment(id: "country") {
                Button("GERMANY") {}
                    .glassBackgroundEffect()
            }
        }
    }
    
    func coordinatesToCartesian(latitude: Float, longitude: Float, radius: Float) -> SIMD3<Float> {
        // lat & lon in radians
        let lat = Float(latitude) * .pi / 180
        let lon = Float(longitude) * .pi / 180
        return SIMD3<Float> (
            radius * cos(lat) * cos(lon),
            (radius * cos(lat) * sin(lon)),
            radius * sin(lat)
        )
    }

}

#Preview {
    Earth(earthConfiguration: EarthEntity.Configuration.orbitEarthDefault)
}

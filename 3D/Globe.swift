/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 The model of the Earth.
 */

import SwiftUI
import RealityKit
import WorldAssets

#if os(visionOS)
import SwiftIslandLocalDataLogic
#else
import Firebase
import SwiftIslandDataLogic
#endif

/// The model of the Earth.
struct Globe: View {
    // Magic Numbers for the Rotation of the Globe to map Coordinates...
    private let rotationX: Float = 90
    private let rotationY: Float = 160
    private let rotationZ: Float = 0

    var body: some View {
        RealityView { content, attachments in
            guard let earthEntity = await WorldAssets.entity(named: "Globe") else { return }
            if let entity = earthEntity.findEntity(named: "Globe") {
                content.add(entity)

                for mentor in Mentor.forWorkshop {
                    if let attachment = attachments.entity(for: mentor.name),
                       let radius = entity.components[CollisionComponent.self]?.shapes.first?.bounds.boundingRadius
                    {
                        let coordinate = coordsToCartesian(latitude: mentor.latitude, longitude: mentor.longitude, radius: radius / 1600)
                        attachment.position = coordinate
                        print("\(mentor.name): \(mentor.latitude), \(mentor.longitude)")
                        content.add(attachment)
                    }
                }
            }
        } update: { content, attachments in
            if let entity = content.entities.first(where: { $0.name == "Globe" }) {
                // Apply rotation using the Euler angles from sliders
                entity.transform.rotation =
                simd_quatf(angle: rotationX * .pi / 180, axis: [1, 0, 0])
                * simd_quatf(angle: rotationY * .pi / 180, axis: [0, 1, 0])
                * simd_quatf(angle: rotationZ * .pi / 180, axis: [0, 0, 1])
                print(rotationX, rotationY, rotationZ)
            }
        } attachments: {
            ForEach(Mentor.forWorkshop) { mentor in
                Attachment(id: mentor.name) {
                    Text(mentor.name)
                        .padding(.horizontal, 5)
                        .font(.caption)
                        .glassBackgroundEffect()
                }
            }
        }
        .dragRotation(
            pitchLimit: .degrees(90)
        )
    }

    func coordsToCartesian(latitude: Float, longitude: Float, radius: Float) -> SIMD3<Float> {
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
    Globe()
}

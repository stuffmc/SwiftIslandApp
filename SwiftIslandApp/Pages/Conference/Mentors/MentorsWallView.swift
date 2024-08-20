#if os(visionOS)
import SwiftUI
import RealityKit
import SwiftIslandLocalDataLogic
import ARKit

struct MentorsWallView: View {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    let wall = AnchorEntity(
        .plane(
            .vertical,
            classification: .wall,
            minimumBounds: [1, 1]
        ),
        trackingMode: .predicted
    )

    let floor = AnchorEntity(
        .plane(
            .horizontal,
            classification: .floor,
            minimumBounds: [1, 1]
        ),
        trackingMode: .predicted
    )
    
    @State private var mentors: [String:AnchorEntity] = [:]

    var body: some View {
        RealityView { content, attachments in
            var translate: Float = -2
            for mentor in Mentor.forWorkshop {
                
                if let attachment = attachments.entity(for: "HUD") {
                    floor.addChild(attachment)
                    move(attachment, to: [0, 2, 0])
                    content.add(floor)
                }
                if let attachment = attachments.entity(for: mentor.id) {
                    wall.addChild(attachment)
                    move(attachment, to: [translate, 0, 0])
                    translate += 0.5
                    content.add(wall)
                }
                if let attachment = attachments.entity(for: mentor.firstName) {
                    mentors[mentor.firstName] = AnchorEntity()
                    if let anchor = mentors[mentor.firstName] {
                        anchor.addChild(attachment)
                        content.add(anchor)
                    }
                }
            }
        } attachments: {
            ForEach(Mentor.forWorkshop) { mentor in
                Attachment(id: mentor.id) {
                    MentorImageView(mentor: mentor)
                }
                
                Attachment(id: mentor.firstName) {
                    Text(mentor.name)
                        .font(.extraLargeTitle)
                        .paddedGlassBackgroundEffect()
                        .rotation3DEffect(.degrees(90), axis: (1, 0, 0))
                }
            }
            Attachment(id: "HUD") {
                HStack {
                    Button("Clean the wall") {
                        Task {
                            await dismissImmersiveSpace()
                            openWindow(id: "App")
                        }
                    }
                    .padding()
                    Button("Spot the Mentor") {
                        Task {
                            if ImageTrackingProvider.isSupported {
                                let session = ARKitSession()
                                let imageInfo = ImageTrackingProvider(referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "ARMentors"))
                                
                                Task {
                                    try await session.run([imageInfo])
                                    for await update in imageInfo.anchorUpdates {
                                        if let name = update.anchor.referenceImage.name, name.starts(with: "speaker-") {
                                            updateImage(update.anchor)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .paddedGlassBackgroundEffect()
                .font(.extraLargeTitle)
                .scaleEffect(2)
            }
        }
    }

    func updateImage(_ anchor: ImageAnchor) {
        if let mentorComponemts = anchor.referenceImage.name?.split(separator: "-"), mentorComponemts.count > 1, anchor.isTracked, let mentor = mentors[mentorComponemts[1].description] {
            mentor.transform = Transform(matrix: anchor.originFromAnchorTransform)
        }
    }

    func move(_ entity: Entity, to xyz: SIMD3<Float>) {
        var currentTransform = entity.transform
        let rotation = simd_quatf(angle: -90 * Float.pi / 180.0, axis: [1, 0, 0])
        currentTransform.rotation = rotation * currentTransform.rotation
        entity.transform = currentTransform
        entity.transform.translation = xyz
    }
}

#Preview {
    MentorsWallView()
}
#endif

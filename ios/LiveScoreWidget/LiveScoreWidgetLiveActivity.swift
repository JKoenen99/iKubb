import ActivityKit
import SwiftUI
import WidgetKit

// Attributes contract used by the `live_activities` Flutter plugin: data
// travels through the shared app-group UserDefaults, keyed by the prefix
// stored in the content state.
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState

  public struct ContentState: Codable, Hashable {}

  var id = UUID()
}

private let sharedDefault = UserDefaults(suiteName: "group.nl.jasperkoenen.ikubb")!

private struct ScoreData {
  let names: [String]
  let scores: [String]
  let activeIndex: Int
  let target: String

  init(prefix: String) {
    let count = Int(sharedDefault.string(forKey: "\(prefix)sideCount") ?? "2") ?? 2
    var names: [String] = []
    var scores: [String] = []
    for i in 0..<count {
      names.append(sharedDefault.string(forKey: "\(prefix)name\(i)") ?? "–")
      scores.append(sharedDefault.string(forKey: "\(prefix)score\(i)") ?? "0")
    }
    self.names = names
    self.scores = scores
    self.activeIndex = Int(sharedDefault.string(forKey: "\(prefix)activeIndex") ?? "0") ?? 0
    self.target = sharedDefault.string(forKey: "\(prefix)target") ?? "50"
  }
}

// Brand palette.
private let birch = Color(red: 0.961, green: 0.937, blue: 0.902)
private let forestDeep = Color(red: 0.118, green: 0.200, blue: 0.165)
private let oak = Color(red: 0.725, green: 0.541, blue: 0.306)

struct LiveScoreWidgetLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      // Lock Screen banner.
      let data = ScoreData(prefix: context.attributes.prefixedKey)
      HStack {
        ForEach(data.names.indices, id: \.self) { i in
          VStack {
            Text(data.names[i])
              .font(.caption)
              .fontWeight(i == data.activeIndex ? .bold : .regular)
            Text(data.scores[i])
              .font(.system(size: 34, weight: .heavy, design: .rounded))
              .monospacedDigit()
          }
          .frame(maxWidth: .infinity)
        }
      }
      .padding()
      .foregroundColor(birch)
      .activityBackgroundTint(forestDeep)
    } dynamicIsland: { context in
      let data = ScoreData(prefix: context.attributes.prefixedKey)
      return DynamicIsland {
        // Expanded.
        DynamicIslandExpandedRegion(.leading) {
          scoreColumn(data, index: 0)
        }
        DynamicIslandExpandedRegion(.trailing) {
          scoreColumn(data, index: min(1, data.names.count - 1))
        }
        DynamicIslandExpandedRegion(.center) {
          Text("→ \(data.target)")
            .font(.caption2)
            .foregroundColor(oak)
        }
      } compactLeading: {
        Text(data.scores.first ?? "0")
          .fontWeight(.heavy).monospacedDigit().foregroundColor(oak)
      } compactTrailing: {
        Text(data.scores.count > 1 ? data.scores[1] : "0")
          .fontWeight(.heavy).monospacedDigit().foregroundColor(birch)
      } minimal: {
        Text(data.scores[min(data.activeIndex, data.scores.count - 1)])
          .fontWeight(.heavy).monospacedDigit().foregroundColor(oak)
      }
    }
  }

  @ViewBuilder
  private func scoreColumn(_ data: ScoreData, index: Int) -> some View {
    VStack {
      Text(data.names.indices.contains(index) ? data.names[index] : "–")
        .font(.caption2)
        .fontWeight(index == data.activeIndex ? .bold : .regular)
      Text(data.scores.indices.contains(index) ? data.scores[index] : "0")
        .font(.system(size: 26, weight: .heavy, design: .rounded))
        .monospacedDigit()
    }
  }
}

extension LiveActivitiesAppAttributes {
  // The plugin stores every value under "<activityId>_<key>"; it exposes
  // the prefix through UserDefaults under the activity id.
  var prefixedKey: String { "\(id)_" }
}

@main
struct LiveScoreWidgetBundle: WidgetBundle {
  var body: some Widget {
    LiveScoreWidgetLiveActivity()
  }
}

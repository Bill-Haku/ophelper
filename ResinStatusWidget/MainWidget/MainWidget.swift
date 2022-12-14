//
//  WidgetView.swift
//  WidgetView
//
//  Created by 戴藏龙 on 2022/7/13.
//  Widget主View

import WidgetKit
import SwiftUI

struct MainWidget: Widget {
    let kind: String = "WidgetView"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectAccountIntent.self, provider: MainWidgetProvider()) { entry in
            WidgetViewEntryView(entry: entry)
        }
        .configurationDisplayName("原神状态")
        .description("查询树脂恢复状态")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])

    }
}

struct WidgetViewEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: MainWidgetProvider.Entry
    var result: FetchResult { entry.result }
    var viewConfig: WidgetViewConfiguration { entry.viewConfig }
    var accountName: String? { entry.accountName }
    
    @ViewBuilder
    var body: some View {
        ZStack {
            if #available(iOSApplicationExtension 16.0, *) {
                if family != .accessoryCircular {
                    WidgetBackgroundView(background: viewConfig.background, darkModeOn: viewConfig.isDarkModeOn)
                }
            } else {
                // Fallback on earlier versions
                WidgetBackgroundView(background: viewConfig.background, darkModeOn: viewConfig.isDarkModeOn)
            }
            
            switch result {
            case .success(let userData):
                WidgetMainView(userData: userData, viewConfig: viewConfig, accountName: accountName)
            case .failure(let error):
                WidgetErrorView(error: error, message: viewConfig.noticeMessage ?? "")
            }
        }
    }
}

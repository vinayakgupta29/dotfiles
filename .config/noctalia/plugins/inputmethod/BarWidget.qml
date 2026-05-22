import QtQuick 2.15
import qs.Commons
import qs.Services.UI
import qs.Widgets
import Quickshell

NIconButton {
    id: root
    property var pluginApi
    property ShellScreen screen
    icon: "language"

    applyUiScale: false
    tooltipText: pluginApi && pluginApi.pluginSettings
        ? (pluginApi.pluginSettings.currentIm || "Input Method")
        : "Input Method"
    tooltipDirection: BarService.getTooltipDirection(screen?.name)
    baseSize: Style.getCapsuleHeightForScreen(screen?.name)
    customRadius: Style.radiusL
    colorBg: Style.capsuleColor
    colorFg: Color.mOnSurface
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    onClicked: {
        PanelService.showContextMenu(contextMenu, root, screen)
    }

    NPopupContextMenu {
        id: contextMenu
        model: ((pluginApi && pluginApi.pluginSettings && pluginApi.pluginSettings.ims) || []).map(function(im) {
            const currentIm = pluginApi && pluginApi.pluginSettings
                ? pluginApi.pluginSettings.currentIm
                : ""

            return {
                label: im,
                action: im,
                icon: im === currentIm ? "keyboard" : "language"
            }
        })

        onTriggered: function(action) {
            if (!action || !pluginApi || !pluginApi.pluginSettings) return
            contextMenu.close()
            PanelService.closeContextMenu(screen)
            if (typeof pluginApi.pluginSettings.setInputMethod === "function") {
                pluginApi.pluginSettings.setInputMethod(action)
            } else {
                pluginApi.pluginSettings.currentIm = action
                pluginApi.saveSettings()
            }
        }
    }

    onRightClicked: {
        PanelService.showContextMenu(contextMenu, root, screen)
    }
}

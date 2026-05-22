import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
    id: panelRoot

    property var pluginApi
    property string currentIM: ""
    property var inputMethods: []

    // Keep widget compact

  // Preferred dimensions
  property real contentPreferredWidth: 320 * Style.uiScaleRatio
  property real contentPreferredHeight: 115 * Style.uiScaleRatio
  
Component.onCompleted: {
  console.log("Panel Root",panelRoot.height)
        if (pluginApi) {
            initConnections()
        }
    }

    onPluginApiChanged: {
        if (pluginApi) {
            initConnections()
        }
    }

    function initConnections() {
        currentIM = pluginApi.pluginSettings.currentIm
        inputMethods = pluginApi.pluginSettings.ims
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            if (!pluginApi) return;
            currentIM = pluginApi.pluginSettings.currentIm
            inputMethods = pluginApi.pluginSettings.ims
        }
    }

    Rectangle {
        id: panelContainer
        color: "transparent"
        radius: 8

        implicitWidth: grid.implicitWidth + 10
        implicitHeight: grid.implicitHeight + 10

        GridLayout {
            id: grid
            anchors.fill: parent
            anchors.margins: 5   // ✅ 5px padding on all sides

            columns: 2
            columnSpacing: 5
            rowSpacing: 5

            Repeater {
                model: inputMethods

                Button {
                    text: modelData.toUpperCase()
                    checkable: true
                    checked: currentIM === modelData
                    font.pixelSize: 12
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 30
                    palette.buttonText: checked ? "#E6EDF3" : "#C9D1D9"

                    background: Rectangle {
                        radius: 8
                        color: checked ? "#1F2937" : "#111827"
                        border.width: checked ? 2 : 1
                        border.color: checked ? "#58A6FF" : "#2D3748"
                    }

                    onClicked: {
                      if (pluginApi && pluginApi.pluginSettings) {
                        console.log("Requested IM:", modelData)
                            if (pluginApi.closePanel && pluginApi.panelOpenScreen !== undefined) {
                                pluginApi.closePanel(pluginApi.panelOpenScreen)
                            }

                            if (typeof pluginApi.pluginSettings.setInputMethodDelayed === "function") {
                                pluginApi.pluginSettings.setInputMethodDelayed(modelData, 120)
                            } else if (typeof pluginApi.pluginSettings.setInputMethod === "function") {
                                pluginApi.pluginSettings.setInputMethod(modelData)
                            } else {
                                pluginApi.pluginSettings.currentIm = modelData
                                pluginApi.saveSettings()
                            }
                        }
                    }
                }
            }
        }
    }

    readonly property var geometryPlaceholder: panelContainer
}

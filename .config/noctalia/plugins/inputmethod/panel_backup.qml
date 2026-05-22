import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
    id: panelRoot
    property var pluginApi   // will be injected automatically
    property string currentIM: ""
    property var inputMethods: []

    Component.onCompleted: {
        // pluginApi may not yet exist, so check it
        if (pluginApi) {
        pluginApiChangedHandler();
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

        // Dynamically create Connections
        var conn = Qt.createQmlObject('import QtQuick 2.15; Connections { target: pluginApi.pluginSettings; onCurrentImChanged: currentIM = pluginApi.pluginSettings.currentIm; onImsChanged: inputMethods = pluginApi.pluginSettings.ims }',
                                      panelRoot)
    }

    // Safe way to react to pluginSettings changes
    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            if (!pluginApi) return;
            currentIM = pluginApi.pluginSettings.currentIm
            inputMethods = pluginApi.pluginSettings.ims
            running = false   // stop timer once initialized
        }
    }

    // OR using Connections safely after pluginApi exists
    Connections {
        // Wait for pluginApi to exist first
        target: pluginApi ? pluginApi.pluginSettings : null

        function onCurrentIMChanged(newVal) {
            currentIM = newVal
        }

        function onInputMethodsChanged(newVal) {
            inputMethods = newVal
        }
    }
    implicitWidth: panelContainer.implicitWidth
    implicitHeight: panelContainer.implicitHeight

    Rectangle {
        id: panelContainer
        color: "transparent"
        radius: 8
        anchors.centerIn: parent

        // Let content define size instead of forcing it
        implicitWidth: grid.implicitWidth + 12
        implicitHeight: grid.implicitHeight + 12

        GridLayout {
            id: grid
            anchors.centerIn: parent
            columns: 3
            columnSpacing: 4
            rowSpacing: 4

            Repeater {
                model: inputMethods

                Button {
                    text: modelData.toUpperCase()
                    checkable: true
                    checked: currentIM === modelData

                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 30

                    onClicked: {
                        if (pluginApi) {
                            pluginApi.pluginSettings.currentIM = modelData
                            pluginApi.saveSettings()
                        }
                    }
                }
            }
        }
    }
 // Expose this container as the panel size reference
    readonly property var geometryPlaceholder: panelContainer
}

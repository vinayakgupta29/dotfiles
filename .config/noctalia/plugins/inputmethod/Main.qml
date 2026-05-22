import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    required property var pluginApi

    property string currentInputMethod: "unknown"
    property var inputMethods: []
    property string pendingInputMethod: ""
    property int pendingSwitchDelay: 0

    // ---- Fetch current input method ----
    Process {
        id: getCurrent
        command: ["/usr/bin/fcitx5-remote", "-n"]

        stdout: StdioCollector {
            onStreamFinished: {
              const method = text.trim()
              root.currentInputMethod = method

              if (pluginApi && pluginApi.pluginSettings && pluginApi.pluginSettings.currentIm !== method) {
                pluginApi.pluginSettings.currentIm = method
                pluginApi.saveSettings()
              }

                console.log("Current IM:", root.currentInputMethod)
            }
        }
    }

    // ---- Fetch available methods ----
    Process {
        id: getAll
        command: ["sh", "-c",
                  "awk -F= 'BEGIN { IGNORECASE=1 } /^Name=/ && $0 !~ /Default/ { print $2 }' \"$HOME/.config/fcitx5/profile\""
        ]

        stdout: StdioCollector {
            onStreamFinished: {
              root.inputMethods = text.trim().split("\n").filter(function(e){ return e.length > 0 })

              if (pluginApi && pluginApi.pluginSettings) {
                pluginApi.pluginSettings.ims = root.inputMethods
                pluginApi.saveSettings()
              }

                console.log("Available IMs:", root.inputMethods)
            }
        }
    }

    // ---- Switch input method ----
    Process {
        id: setProcess
        stdout: StdioCollector {}
        onExited: function(exitCode) {
            if (exitCode === 0) {
                console.log("Switched IM to:", root.pendingInputMethod || root.currentInputMethod)
                refreshCurrentTimer.restart()
            } else {
                console.warn("Failed to switch IM:", root.pendingInputMethod || root.currentInputMethod, "exit code:", exitCode)
            }

            root.pendingInputMethod = ""
        }
    }

    Timer {
        id: refreshCurrentTimer
        interval: 150
        repeat: false
        onTriggered: getCurrent.running = true
    }

    Timer {
        id: delayedSwitchTimer
        repeat: false
        interval: Math.max(0, root.pendingSwitchDelay)
        onTriggered: {
            if (!root.pendingInputMethod)
                return

            setProcess.command = [
                "/bin/sh",
                "-c",
                "/usr/bin/fcitx5-remote -o >/dev/null 2>&1 && /usr/bin/fcitx5-remote -s \"$1\"",
                "inputmethod-switch",
                root.pendingInputMethod
            ]
            setProcess.running = true
        }
    }

    function setInputMethod(method) {
        if (!method || method === root.currentInputMethod)
            return

        root.pendingInputMethod = method
        root.pendingSwitchDelay = 0
        delayedSwitchTimer.restart()

        if (pluginApi && pluginApi.pluginSettings && pluginApi.pluginSettings.currentIm !== method) {
            pluginApi.pluginSettings.currentIm = method
            pluginApi.saveSettings()
        }
    }

    function setInputMethodDelayed(method, delayMs) {
        if (!method)
            return

        if (pluginApi && pluginApi.pluginSettings && pluginApi.pluginSettings.currentIm !== method) {
            pluginApi.pluginSettings.currentIm = method
            pluginApi.saveSettings()
        }

        root.pendingInputMethod = method
        root.pendingSwitchDelay = delayMs || 0
        delayedSwitchTimer.restart()
    }

    Component.onCompleted: {
        getCurrent.running = true
        getAll.running = true

        // expose properties & functions to pluginApi
        if (pluginApi) {
            if (pluginApi.pluginSettings.currentIm) {
                root.currentInputMethod = pluginApi.pluginSettings.currentIm
            } else {
                pluginApi.pluginSettings.currentIm = root.currentInputMethod
            }

            if (pluginApi.pluginSettings.ims && pluginApi.pluginSettings.ims.length) {
                root.inputMethods = pluginApi.pluginSettings.ims
            } else {
                pluginApi.pluginSettings.ims = root.inputMethods
            }

            pluginApi.pluginSettings.setInputMethod = setInputMethod
            pluginApi.pluginSettings.setInputMethodDelayed = setInputMethodDelayed

            if (pluginApi.pluginSettings.panelWidth === undefined) {
                pluginApi.pluginSettings.panelWidth = 600
                pluginApi.saveSettings()
            }

            if (pluginApi.pluginSettings.panelHeight === undefined) {
                pluginApi.pluginSettings.panelHeight = 400
                pluginApi.saveSettings()
            }

            console.log(pluginApi.pluginSettings.panelHeight, "  Panel Width :  " , pluginApi.pluginSettings.panelWidth)
        }
    }
}

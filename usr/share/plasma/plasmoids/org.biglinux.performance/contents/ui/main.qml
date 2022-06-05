/*
 * SPDX-FileCopyleftText: 2022 Bruno Gonçalves <bigbruno@gmail.com> and Rafael Ruscher <rruscher@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.5
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kwindowsystem 1

Item {
    id: root

    KWindowSystem {
        id: kwindowsystem
    }
    property bool compActive: kwindowsystem.compositingActive

    Plasmoid.icon: kwindowsystem.compositingActive ? 'big-performance-off' : 'big-performance-on'
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    // Active = in systray and Passive in notification area
    Plasmoid.status: {
        //return PlasmaCore.Types.ActiveStatus;
        return PlasmaCore.Types.PassiveStatus;
     }

    function toggleCompositing() {
        if (kwindowsystem.compositingActive) {
            executable.exec('qdbus org.kde.KWin /Compositor suspend')
            executable.exec('kwriteconfig5 --file ~/.config/kwinrc --group Compositing --key "Enabled" "false"')
        } else {
            executable.exec('qdbus org.kde.KWin /Compositor resume')
            executable.exec('kwriteconfig5 --file ~/.config/kwinrc --group Compositing --key "Enabled" "true"')
        }
    }


    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        active: compactMouseArea.containsMouse
        source: plasmoid.icon
        
        MouseArea {
            id: compactMouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: toggleCompositing()
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName) // cmd finished

        function exec(cmd) {
            connectSource(cmd)
        }
    }

}

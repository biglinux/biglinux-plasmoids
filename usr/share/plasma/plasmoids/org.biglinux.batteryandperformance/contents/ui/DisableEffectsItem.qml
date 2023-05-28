 
/*
 * SPDX-FileCopyleftText: 2022 Bruno Gonçalves <bigbruno@gmail.com> and Rafael Ruscher <rruscher@gmail.com>
 * SPDX-FileCopyleftText: 2023 Douglas Guimarães <dg2003gh@gmail.com>
 * SPDX-License-Identifier: GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kquickcontrolsaddons 2.1
import org.kde.kwindowsystem 1.0
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.1 as PlasmaCore

import "Handler/logic.js" as Logic


Item {
    id: root

    KWindowSystem {
        id: kwindowsystem
    }
    property bool compActive: kwindowsystem.compositingActive
    property alias cfg_toggleDesktopEffect: disableEffectsCheckBox.checked
            
    PlasmaComponents3.CheckBox {
        id: disableEffectsCheckBox
        Layout.fillWidth: true
        onCheckedChanged: Logic.toggleCompositing()
        checked: Plasmoid.configuration.toggleDesktopEffect 
        text: i18n("Disable desktop effects")
        focus: true
        KeyNavigation.down: pmSwitch.pmCheckBox
        KeyNavigation.backtab: dialog.KeyNavigation.backtab
        KeyNavigation.tab: KeyNavigation.down
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

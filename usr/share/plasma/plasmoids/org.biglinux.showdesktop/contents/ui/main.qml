/*
 * SPDX-FileCopyleftText: 2022 Bruno Gonçalves <bigbruno@gmail.com> and Rafael Ruscher <rruscher@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

// Import necessary QtQuick modules for UI components
import QtQuick
// Import QtQuick.Layouts for layout management
import QtQuick.Layouts
// Import Plasma specific modules for Plasmoid development
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.core as PlasmaCore
// Import Kirigami for KDE's cross-platform UI framework
import org.kde.kirigami as Kirigami

// Main PlasmoidItem which acts as the root item of this plasmoid
PlasmoidItem {
    id: root // Identifier for the root item
    property string outputText // Custom property to store output text
    // Readonly property to check if plasmoid is in a horizontal form factor
    readonly property bool horizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal

    // Minimum width and height for the layout
    Layout.minimumWidth:  6
    Layout.minimumHeight: 6

    // Set the preferred representation of the plasmoid
    preferredRepresentation: fullRepresentation

    // DataSource for executing external commands
    Plasma5Support.DataSource {
        id: "executable" // Identifier for the data source
        // Function to execute a command
        function exec(cmd) {
            connectSource(cmd); // Connects to the source to execute the command
        }

        engine: "executable" // Set the engine type to executable
        // Handler for new data from the source
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName); // Disconnects the source after receiving data
        }
    }

    // Full representation of the plasmoid when it is not in compact mode
    fullRepresentation: PlasmoidItem {
        
        // Rectangle to act as a visual indicator or separator
        Rectangle {
            id: verticalBar // Identifier for the rectangle
            color: Kirigami.Theme.textColor // Set the color to the theme's text color

            width: horizontal ? 1 : parent.width // Conditional width based on orientation
            height: !horizontal ? 1 : parent.height // Conditional height based on orientation
            // Opacity changes based on mouse hover state
            opacity: mouseArea.containsMouse ? 0.6 : 0.3
        }

        // MouseArea to capture mouse events
        MouseArea {
            id: mouseArea // Identifier for the mouse area
            anchors.fill: parent // Fill the entire parent item
            hoverEnabled: true // Enable mouse hover detection
            // Action to perform on mouse click
            onClicked: {
                // Executes a command to show the desktop using dbus-send
                executable.exec('dbus-send --type=method_call --dest=org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut string:"Show Desktop"')
            }
        }
    }
}

// c-model standard styles and properties. Paste inside `views { ... }`
// (replace any existing `styles` block wholesale; merge `properties`).
//
// Verified against structurizr-cli v2025.11.09 -> C4-PlantUML export:
// - Without "c4plantuml.tags" "true" the exporter emits NO AddElementTag /
//   AddRelTag lines, so none of these styles and no tag legend appear.
// - Structurizr's default relationship line is dashed; the "Relationship"
//   rule below makes it solid so the dashed Unverified lines stand out.
// - Element `border dashed` -> $borderStyle="dashed"; relationship
//   `style dashed` -> $lineStyle=DashedLine(). Both survive the export.
// - Element `border dotted` does NOT show in the render; Planned uses a
//   grey dashed border instead (relationship `style dotted` does show).
// - SHOW_LEGEND(true) is emitted for every view by default; the legend
//   lists each tag that has a style, so keep tag names human-readable.

        styles {
            element "Person" {
                shape Person
                background "#08427b"
                color "#ffffff"
            }
            element "Software System" {
                background "#1168bd"
                color "#ffffff"
            }
            element "Container" {
                background "#438dd5"
                color "#ffffff"
            }
            element "Component" {
                background "#85bbf0"
                color "#000000"
            }
            element "External" {
                background "#999999"
                color "#ffffff"
            }
            element "Database" {
                shape Cylinder
            }
            element "Queue" {
                shape Pipe
            }
            element "Infrastructure Node" {
                background "#ffffff"
                color "#000000"
            }
            element "Planned" {
                border dashed
                stroke "#9e9e9e"
                strokeWidth 2
                opacity 60
            }
            element "Unverified" {
                border dashed
                stroke "#c62828"
                strokeWidth 3
            }
            relationship "Relationship" {
                style solid
            }
            relationship "Planned" {
                style dotted
            }
            relationship "Unverified" {
                style dashed
                color "#c62828"
            }
        }

        properties {
            "c4plantuml.tags" "true"
        }

-- Basic Framework Plugin
-- by RJB
-- April 2026

-- Information block for the plugin
require('info')

-- Define the color of the plugin object in the design
require('color')

-- The name that will initially display when dragged into a design
require('pretty_name')

-- Optional function used if plugin has multiple pages
require('pages')

-- Optional function to define model if plugin supports more than one model
require('model')

-- Define User configurable Properties of the plugin
require('properties')

-- Optional function to define pins on the plugin that are not connected to a Control
require('pins')

-- Optional function to update available properties when properties are altered by the user
require('rectify_properties')

-- Optional function to define components used within the plugin
require('components')

-- Optional function to define wiring of components used within the plugin
require('wiring')

-- Defines the Controls used within the plugin
require('controls')

--Layout of controls and graphics for the plugin UI to display
require('layout')

--Start event based logic
if Controls then
  require('runtime')
end
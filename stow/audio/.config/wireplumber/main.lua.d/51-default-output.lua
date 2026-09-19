-- WirePlumber 0.4 (Ubuntu 24.04). Sound out of the DELL S2722QC (Radeon HDMI 2).
-- A profile you pick by hand is remembered and still wins; this is the fallback
-- for a fresh install / wiped state.
table.insert(alsa_monitor.rules, {
  matches = { { { "device.name", "equals", "alsa_card.pci-0000_0b_00.1" } } },
  apply_properties = { ["device.profile"] = "output:hdmi-stereo-extra1" },
})

table.insert(alsa_monitor.rules, {
  matches = { { { "node.name", "equals", "alsa_output.pci-0000_0b_00.1.hdmi-stereo-extra1" } } },
  apply_properties = { ["priority.session"] = 1500 }, -- highest sink → default output
})

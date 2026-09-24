-- Mac-style shortcuts for the Swiss German Mac layout (ch/de_mac + lv3:lalt_switch):
--   * Option sends ISO_Level3_Shift (MOD5), not ALT, so Option bindings use MOD5.
--   * [ and ] are not plain keys on this layout, so the tab keys are bound by
--     position (code:34/35, the ü and ¨ keys).
-- Super + C/V/X are Omarchy's universal copy/paste/cut and stay as they are.
--
-- Omarchy actions displaced by these keys move to Super + Option + same key.
-- Close window moves from Super + W to Super + Q.

local key_press_milliseconds = 50

local function send_chords(chords)
  for index, chord in ipairs(chords) do
    local start = (index - 1) * key_press_milliseconds * 2

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = chord[1], key = chord[2], state = "down" }))
    end, { timeout = math.max(start, 1), type = "oneshot" })

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = chord[1], key = chord[2], state = "up" }))
    end, { timeout = start + key_press_milliseconds, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function mac_shortcut(keys, description, app_chords, terminal_chords)
  hl.unbind(keys)
  o.bind(keys, description, function()
    if active_window_is_terminal() then
      send_chords(terminal_chords)
    else
      send_chords(app_chords)
    end
  end)
end

local function same_everywhere(keys, description, chords)
  mac_shortcut(keys, description, chords, chords)
end

-- Omarchy actions that the shortcuts below take over
o.bind("SUPER + MOD5 + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + MOD5 + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + MOD5 + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + MOD5 + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + MOD5 + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + MOD5 + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + MOD5 + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

mac_shortcut("SUPER + Z", "Mac Undo", { { "CTRL", "Z" } }, { { "CTRL SHIFT", "Z" } })
same_everywhere("SUPER + A", "Mac Select all", { { "CTRL", "A" } })

hl.unbind("SUPER + T")
o.bind("SUPER + T", "Mac New tab, or new terminal in a terminal", function()
  if active_window_is_terminal() then
    hl.exec_cmd("omarchy-launch-terminal")
  else
    send_chords({ { "CTRL", "T" } })
  end
end)
mac_shortcut("SUPER + W", "Mac Close tab", { { "CTRL", "W" } }, { { "CTRL SHIFT", "W" } })
mac_shortcut("SUPER + L", "Mac Address bar", { { "CTRL", "L" } }, { { "CTRL SHIFT", "L" } })
mac_shortcut("SUPER + R", "Mac Reload", { { "CTRL", "R" } }, { { "CTRL SHIFT", "R" } })

same_everywhere("SUPER + SHIFT + code:34", "Mac Previous tab", { { "CTRL SHIFT", "Tab" } })
same_everywhere("SUPER + SHIFT + code:35", "Mac Next tab", { { "CTRL", "Tab" } })

same_everywhere("SUPER + LEFT", "Mac Line start", { { "", "Home" } })
same_everywhere("SUPER + RIGHT", "Mac Line end", { { "", "End" } })
same_everywhere("SUPER + UP", "Mac Document start", { { "CTRL", "Home" } })
same_everywhere("SUPER + DOWN", "Mac Document end", { { "CTRL", "End" } })
mac_shortcut("SUPER + BACKSPACE", "Mac Delete to line start", { { "SHIFT", "Home" }, { "", "BackSpace" } }, { { "CTRL", "U" } })

same_everywhere("MOD5 + LEFT", "Mac Word left", { { "CTRL", "Left" } })
same_everywhere("MOD5 + RIGHT", "Mac Word right", { { "CTRL", "Right" } })
mac_shortcut("MOD5 + BACKSPACE", "Mac Delete word left", { { "CTRL", "BackSpace" } }, { { "CTRL", "W" } })

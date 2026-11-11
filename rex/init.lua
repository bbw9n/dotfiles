
-- Ghostty -> Rex
-- Source: github.com/bbw9n/dotfiles/blob/master/ghostty/config
--
-- Preserve exact terminal input bytes for TUI Emacs.
--
-- NOTE: Rex documents the terminal.write method, but its
-- exact argument schema must be checked against your version:
-- rex api describe com.superlogical.terminal.write
--
-- This configuration assumes its string argument is "text".

local function send_bytes(key, bytes)
  rex.bind(key, "com.superlogical.terminal.write", {
    data = bytes,
  })
end

-- ---------------------------------------------------------
-- Option / Alt: Emacs Meta key
-- ---------------------------------------------------------

send_bytes("alt+b", "\27b")
send_bytes("alt+f", "\27f")
send_bytes("alt+d", "\27d")

-- ---------------------------------------------------------
-- Backspace
-- ---------------------------------------------------------

-- Ctrl+Backspace -> Ctrl+W (backward-kill-word)
send_bytes("ctrl+backspace", "\23")

-- Cmd+Backspace -> Ctrl+U (kill line)
send_bytes("cmd+backspace", "\21")

-- ---------------------------------------------------------
-- Cmd shortcuts for terminal Emacs
-- Ghostty: esc:[1;8<key>
-- ---------------------------------------------------------

local command_keys = {
  "a",
  "c",
  "x",
  "k",
  "s",
  "l",
  "w",
  "z",
  "q",
}

for _, key in ipairs(command_keys) do
  send_bytes("cmd+" .. key, "\27[1;8" .. key)
end

-- Cmd+V was commented out in Ghostty.
-- send_bytes("cmd+v", "\27[1;8v")

-- ---------------------------------------------------------
-- Ctrl+Shift shortcuts
-- Ghostty: text:\x1bZ<key>
-- ---------------------------------------------------------

local control_shift_keys = {
  "e",
  "n",
  "p",
  "a",
  "f",
  "b",
}

for _, key in ipairs(control_shift_keys) do
  send_bytes("ctrl+shift+" .. key, "\27Z" .. key)
end


-- Emacs M-< and M->
-- Explicitly send ESC + < or ESC + >

local function send_emacs_key(key, bytes)
  rex.bind(key, function(ctx, ev)
    local result, err = rex.block.call(
      "com.superlogical.terminal",
      "write",
      { data = bytes }
    )
    if err then error(err, 0) end
    return true
  end)
end

send_emacs_key("alt+shift+,", "\27<")
send_emacs_key("alt+shift+.", "\27>")

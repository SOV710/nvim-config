return {
  -- ── copilot toggle ───────────────────────────────────────────────────

  {
    '<M-c>',
    function()
      vim.g.blink_copilot_disabled = not vim.g.blink_copilot_disabled
      vim.notify('Copilot: ' .. (vim.g.blink_copilot_disabled and 'OFF' or 'ON'))
    end,
    desc = 'Toggle Copilot completion source',
    mode = { 'i', 'n' },
  },
}

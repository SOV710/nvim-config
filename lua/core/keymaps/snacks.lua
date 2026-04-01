return {
  -- ── Buffer ───────────────────────────────────────────────────────

  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
  { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
  { "<leader>bD", function() Snacks.bufdelete({ force = true }) end, desc = "Force delete buffer" },

  -- ── File ─────────────────────────────────────────────────────────

  { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
  { "<leader>fs", function() Snacks.scratch.open() end, desc = "Scratch buffer" },
  { "<leader>fS", function() Snacks.scratch.select() end, desc = "Select scratch" },
}

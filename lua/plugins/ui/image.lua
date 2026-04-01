return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
      doc = {
        enabled = true,            -- render images in documents (markdown etc.)
        inline = true,             -- render inline images
        float = true,              -- render floating images
        max_width = 80,            -- max image width in columns
        max_height = 40,           -- max image height in rows
      },
    },
  },
}

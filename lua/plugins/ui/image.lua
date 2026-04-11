-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'folke/snacks.nvim',
  opts = {
    image = {
      enabled = true,
      formats = {
        'png',
        'jpg',
        'jpeg',
        'gif',
        'bmp',
        'webp',
        'tiff',
        'heic',
        'avif',
        'svg',
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
        'icns',
        'pdf',
      },
      doc = {
        enabled = true, -- render images in documents (markdown etc.)
        inline = true, -- render inline images
        float = true, -- render floating images
        max_width = 60, -- max image width in columns
        max_height = 30, -- max image height in rows
      },
      convert = {
        notify = true,
      },
      math = {
        enabled = true,
        typst = {
          tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
        },
      },
    },
  },
}

#!/usr/bin/env ruby

# A4" => [0, 0, 595.28, 841.89]
# add_image_from_file(image, x, y, width = nil, height = nil, link = nil)
require "rubygems"
require "pdf/writer"
require "fosso"
require "fosso_pdf"

pdf = PDF::Writer.new

pdf.copertina
pdf.start_new_page
pdf.introduzione
pdf.start_new_page
pdf.note

# SETTORI
Fosso.settori.each do |s|
  # (s == 'nochances') or next
  pdf.settore_page(s)
end

# RIASSUNTO

pdf.start_new_page
pdf.riassunto_vie

pdf.scrivi

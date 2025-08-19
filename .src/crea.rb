#!/usr/bin/env ruby

BASEDIR = "/fossoraibano"

require "./fosso"

# esempio belvedere
name = ARGV[0] or raise "Manca il nome della pagina"

link_settori = ""

Fosso.settori.each do |settore|
  actual = (settore == name) ? "bg-info-subtle" : ""
  link_settori << "<li><a class=\"dropdown-item #{actual}\" href=\"#{BASEDIR}/#{settore}.html\"> #{Fosso.nome_settore(settore)}</a></li>"
end

top = File.open("html/top.html").readlines.join
menu = File.open("html/menu.html").readlines.join
body = File.open("html/#{name}.html").readlines.join
footer = "<hr/></body></html>"

menu.gsub!("__LINK_SETTORI__", link_settori)
body.gsub!("__MENU__", menu)

if File.exist?("xml/#{name}.xml")
  settore = Settore.new("xml/#{name}.xml")
  top.gsub!("__TITOLO__", "Guida di fossoraibano: settore #{settore.nome}")
end

top.gsub!("__TITOLO__", "Guida di fossoraibano: #{name}")

File.open("../#{name}.html", "w") do |f|
  f.puts top
  if File.exist?("xml/#{name}.xml")
    settore = Settore.new("xml/#{name}.xml")
    lr = ["viandante", "canyon", "spaccato", "baby", "pulpito", "george", "nochances", "fosso"].include?(name) ? "right" : "left"
    tb = ["baby", "inutile"].include?(name) ? "bottom" : "top"
    f.puts "<body style=\"background: url(bg/#{name}.jpg) #{settore.bg_color} no-repeat #{tb} #{lr}; border: 20px; background-attachment: fixed;\">"
    f.puts menu
    f.puts "<div class=\"container mb-4\">"
    f.puts settore.dl_vie
    f.puts settore.note
    f.puts "<div class=\"text-end\">"
    f.puts "nella foto: #{settore.note}"
    f.puts "</div>"
    f.puts "</div>"
  else
    f.puts "<body style=\"background: #ffffff url(/fossoraibano/bg/nolimits.jpg) no-repeat top left; background-attachment: fixed;\">"
    f.puts menu
    f.puts File.open("html/#{name}.html").readlines.join
  end
  f.puts footer
end

#!/usr/bin/env ruby

BASEDIR = "/fossoraibano"

nome = ARGV[0] or raise "Manca il nome del personaggio"

titolo = {vanni: "Andrea Vanni: il premier",
          benni: "Benni: l'eremita",
          spiro: "Spiro: Introduzione alle storie di Fosso Raibano",
          genova: "Stfano Bentola: il certosino",
          pietro: "Mocassini Lumberjack"}

require "./fosso"

link_settori = Fosso.settori.inject("") do |res, settore|
  res += "<li><a class=\"dropdown-item\" href=\"#{BASEDIR}/#{settore}.html\"> #{Fosso.nome_settore(settore)}</a></li>"
  res
end

top = File.open("html/top.html").readlines.join
menu = File.open("html/menu.html").readlines.join
body = File.open("html/storie/#{nome}.html").readlines.join

top.gsub!("__TITOLO__", titolo[nome.to_sym])
menu.gsub!("__LINK_SETTORI__", link_settori)
body.gsub!("__MENU__", menu)

File.open("../storie/#{nome}.html", "w") do |f|
  f.puts top
  f.puts "<body>"
  f.puts body
  f.puts "<body></html>"
end

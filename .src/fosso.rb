#!/usr/bin/env ruby

require "rexml/document"

class Fosso
  @@s_v = {
    "fosso"      => "fosso vecchio",
    "george"     => "George's dream",
    "nochances"  => "no chances",
    "belvedere"  => "il belvedere",
    "jurassic"   => "jurassic park",
    "meraviglie" => "placca delle meraviglie",
    "inutile"    => "tempio dell'inutile",
    "nolimits"   => "no limits",
    "canyon"     => "gran canyon",
    "pulpito"    => "il pulpito",
    "baby"       => "baby school",
    "spaccato"   => "spaccato d'onda",
    "viandante"  => "sogno di un viandante",
    "sblisgo"    => "placca dello sblisgo"
  }

  @@chiodatori = {
    "benni"       => "Benni",
    "ferioli"     => "Marcello Ferioli", 
    "corticelli"  => "Alberto Corticelli",
    "vanni"       => "Andrea Vanni",
    "bonfiglioli" => "Carlo Bonfiglioli",
    "bengaglia"   => "Denis Bengaglia",
    "bertotti"    => "Roberto Bertotti",
    "genova"      => "Genova",
    "tagliarini"  => "Gianni Taglianini",
    "balestra"    => "Gi&ograve; Balestra",
    "gferioli"    => "Giorgio Ferioli",
    "acorticelli" => "Andrea Corticelli",
    "mazzetti"    => "Jonny Mazzetti",
    "finotti"     => "Lorenzo Finotti", 
    "lustre"      => "Lustre alias Stefano Trebbi",
    "vanzi"       => "Pietro Vanzi",
    "zanna"       => "Stefano \"Doc\" Zanna",
  }

  def self.settori
    ["nolimits", "belvedere", "jurassic", "meraviglie", "inutile", "viandante", "sblisgo", "pulpito", "canyon", "spaccato", "baby", "george", "nochances", "fosso"]
  end

  def self.nome_settore(nome)
    @@s_v[nome]
  end

  def self.nome_chiodatore(chiodatore)
    @@chiodatori.has_key?(chiodatore) and return @@chiodatori[chiodatore]
    chiodatore
  end
end

class Settore
  attr_reader :nome, :note, :foto, :bg_color

  def self.elenco
    @@s_k
  end

  def initialize(xmlfile)
    @xmlfile = xmlfile

    File.open(@xmlfile) do |f|
      @xml = REXML::Document.new(f).root.elements["settore"]
    end

    @nome = @xml.attributes["nome"]
    @note = @xml.elements["note"] ? @xml.elements["note"][0].to_s : ""
    @foto = @xml.elements["foto"] ? @xml.elements["foto"][0].to_s : ""
    @bg_color = @xml.elements["bg_color"] ? @xml.elements["bg_color"][0].to_s : ""
    @via = []
    leggi_vie
  end

  def leggi_vie
    @xml.each_element("via") do |e|
      @via << Via.new(e)
    end
  end

  def each_via
    @xml.each_element("via") do |e|
      yield Via.new(e)
    end
  end

  def dl_vie
    m = "<ol>\n"
    @via.each do |v|
      m << "<li value=\"#{v.num}\"> <b>#{v.nome}</b> (#{v.chiodatore}) - #{v.grado} / #{v.metri} m / #{v.rinvii} rinvii / #{v.bellezza}"
      m << "<dl>"
      m << "<dd>#{v.note}.</dd>\n"
      m << "<dd style=\"color: darkred;\">#{v.storia}.</dd>\n" if v.storia
      m << "<dd style=\"color: darkred; font-style: italic;\">#{v.note2}.</dd>\n" if v.note2
      m << "</dl>\n"
      m << "</li>\n"
    end
    m << "</ol>"
  end

  def table_vie
    t = "<table>\n"
    @via.each do |v|
      t << "<tr>\n"
      t << "<td><b>#{v.nome}</b> (#{v.grado} di #{v.chiodatore} - #{v.metri} m - #{v.rinvii} rinvii)</td>\n"
      t << "<td>#{v.bellezza}</td>\n"
      t << "</tr>\n"
      t << "<tr>\n"
      t << "<td colspan=\"2\">#{v.note}</td>\n"
      t << "</tr>\n"
    end
    t << "</table>"
  end

  def txt_vie
    t = "-------\n"
    @via.each do |v|
      t << "#{v.num} \t"
      t << "#{v.nome} (#{v.grado} di #{v.chiodatore} - #{v.metri} m - #{v.rinvii} rinvii)"
      t << " - #{v.bellezza} -\n"
      t << "#{v.note}\n"
      t << "#{v.storia}\n" if v.storia
    end
    t
  end

  def pdf_vie(pdf)
    @via.each do |v|
      pdf.select_font("Helvetica")
      pdf.text "%3d.  %5s " % [v.num, v.bellezza] + pulisci("<b>#{v.nome}</b> (<i>#{v.grado} di #{v.chiodatore} - #{v.metri} m - #{v.rinvii} rinvii</i>) " ), :font_size => 10
      pdf.text pulisci(v.note) + ".", :font_size => 10, :left => 30
      if v.storia 
        # pdf.select_font("Palatino")      
        pdf.text pulisci("<i>#{v.storia}.</i>"), :font_size => 10, :left => 30
      end
      pdf.text " ", :font_size => 4
    end
  end
end

class Via
  attr_reader :num, :nome, :grado, :metri, :rinvii, :bellezza, :chiodatore, :note, :note2, :storia

  def initialize(xml_element)
    @num = xml_element.attributes["num"]
    @nome = xml_element.elements["nome"].text
    @grado = xml_element.elements["grado"].text
    @metri = xml_element.elements["metri"].text
    @rinvii = xml_element.elements["rinvii"].text
    @bellezza = xml_element.elements["bellezza"].text
    @chiodatore = Fosso.nome_chiodatore(xml_element.elements["chiodatore"].text)
    @note = xml_element.elements["note"].text
    if xml_element.elements["storia"]
      @storia = xml_element.elements["storia"].text
    end
    if xml_element.elements["note2"]
      @note2 = xml_element.elements["note2"].text
    end
  end
end

def accenti(str)
  str and str.gsub!(/&(.)grave;/, '\\\\\'\1')
end

def pulisci(str)
  str ? str.gsub(/&(.)grave;/, '\1\'').gsub(/\s+/, ' ') : " "
end

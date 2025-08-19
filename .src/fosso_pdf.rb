# A4" => [0, 0, 595.28, 841.89]
# add_image_from_file(image, x, y, width = nil, height = nil, link = nil)
class PDF::Writer
  def title(title)
    save_state
    text " "
    fill_color(Color::RGB::DarkRed)
    bordo = 30
    rounded_rectangle(left_margin + bordo, y, page_width - right_margin - left_margin - 2 * bordo, 30, 5).fill
    fill_color(Color::RGB::White)
    text title, :font_size => 16, :justification => :center
    text " "
    restore_state
  end

  def copertina
    add_image_from_file('img/cover.jpg', 0, 0)
    move_pointer(500)
    fill_color(Color::RGB::DarkRed)
    text "Fosso Raibano", :font_size => 40, :justification => :right, :right => 30
    move_pointer(20)
    text "Guida di arrampicata", :font_size => 35, :justification => :right, :right => 30
    fill_color(Color::RGB::Black)
  end

  def introduzione
    move_pointer(500)
    fill_color(Color::RGB::DarkRed)
    text "Introduzione", :font_size => 25, :justification => :right, :right => 30
    fill_color(Color::RGB::Black)
    move_pointer(50)
    text "Questa guida e' ancora in costruzione. Che dire? Speriamo che a Benni piaccia :-)", :font_size => 10, :justification => :right, :right => 30
  end

  def note
    title "Introduzione di Benni alla guida del 2000:"

    text "
  Informazioni utili
  ", :font_size => 12, :justification => :left, :left => 30

    text "
  In ombra fin verso le 11 (a seconda del settore), sole fino al tramonto.
  A parte la concatenazione dei quattro tiri delle \"Tre querce\", sono tutti monotiri.
  Per il settore \"La placca delle meraviglie\", \"Il tempio dell'inutile\" e \"Il gran canyon\" occorrono fino a tradici rinvii e corda da sessanta metri.
  Arrampicare qui nel Bosco, per i non addetti, non e' un'esperienza eclatante. Le vie si sviluppano in gran parte su placca appoggiata, per cui in caso di pioggia, vento o per lo stesso esercizio della moulinette le conche e le tacche si riempiono di sabbia.
  Tenendo conto di questo, e anche per ammorbidire l'impatto con un on-sight, nella quasi totalita' dei settori e' stato steso un cavo d'acciaio che unisce le diverse catene d'arrivo.
  Il top e' munirsi di uno scopino in setole, calarsi e... scopare.
  ", :font_size => 10, :justification => :left

  text "
  Come ci si arriva
  ", :font_size => 12, :justification => :left, :left => 30

  text "
  All'uscita del casello di Sasso Marconi dell'A1 Bologna-Firenze, seguire dopo la rotonda la strada per Badolo. Superata la prima serie di tornanti e la piccola frazione di Battedizzo, la strada s'adagia in leggera discesa per circa 1,5 km, fino a giungere ad una stretta curva su un ponte in pietra.
  100 metri prima di detto ponte, a sinistra, il sentiero in ripida salita porta alle pareti (5 minuti, classici segnavia sui fusti delle piante). 
  Per chi invece proviene da Pieve del Pino (collinare) o da Pian di Macina (Pianolo), passato Badolo e la successiva serie dei tornanti, nell'ultima discesa prima del suddetto ponticello si ha di fronte, in bella evidenza, la parete di Fosso.
  ", :font_size => 10, :justification => :left

  add_image_from_file('img/mappa.png', 110, 50, width = 360)

  end

  def settore_page(s)
    start_new_page

    settore = Settore.new("xml/#{s}.xml")

    # TITOLO
    fill_color(Color::RGB::DarkRed)
    code = File.read("./pdf/#{s}.pdf")
    eval code
    linea = PDF::Writer::StrokeStyle.new(5)
    linea.cap = :round
    stroke_style(linea)
    stroke_color(Color::RGB::DarkRed)
    move_to(80, 720).line_to(500, 720).stroke
    stroke_color(Color::RGB::Black)
    fill_color(Color::RGB::Black)

    if settore.note
      text " ", :font_size => 16
      text pulisci(settore.note), :font_size => 10, :justification => :right
    end

    text " ", :font_size => 16

    settore.pdf_vie(self)
  end

  def riassunto_vie
    riassunto = {}

    Fosso.settori.each do |s|
      settore = Settore.new("xml/#{s}.xml")
      settore.each_via do |via|
        grado ||= "?"
        grado.delete!("+")
        case grado
        when "-"
          grado = "?"
        when "5c/6b/2/6a"
          grado = "6b"
        when "N.L.(8b?)"
          grado = "?"
        when "4a"
          grado = "4a - 5b"
        when "5a"
          grado = "4a - 5b"
        when "5b"
          grado = "4a - 5b"
        when "7b/c"
          grado = "7b"
        end

        riassunto[grado] ||= []
        riassunto[grado] << "#{via.nome} (#{settore.nome})"
      end
    end

    fill_color(Color::RGB::DarkRed)
    text "Elenco di tutte le vie di Fosso Raibano", :font_size => 20, :justification => :center
    fill_color(Color::RGB::Black)
    move_pointer(10)

    riassunto.keys.sort.each do |grado|
      fill_color(Color::RGB::DarkRed)
      move_pointer(10)
      text "#{grado}", :font_size => 12, :left => 50
      move_pointer(5)
      fill_color(Color::RGB::Black)

      riassunto[grado].sort.each do |via|
        text via, :font_size => 8, :justification => :left
      end
    end
  end

  def scrivi
    File.open("../fosso.pdf", "w") do |f|
      f.write render
    end
  end
end

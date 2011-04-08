# encoding: utf-8

Allora /^(?:|Io )devo vedere "([^"]*)"(?: dentro "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Allora /^(?:|Io )non devo vedere "([^"]*)"(?: dentro "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should_not
      page.should_not have_content(text)
    else
      assert !page.has_content?(text)
    end
  end
end

Quando /^seguo il link "([^"]*)"$/ do |link|
  click_link(link)
end

Quando /^compilo il campo "([^"]*)" con "([^"]*)"$/ do |label, value|
  fill_in(label, :with => value)
end

Quando /^premo il bottone "([^"]*)"$/ do |bottone|
  click_button(bottone)
end

Allora /^(pagina|mostra la pagina)$/ do |arg|
  save_and_open_page
end

Allora /^deve esserci il link "([^"]*)"$/ do |link|
  l = find_link(link)
  assert !l.nil? && l.visible?
end

Allora /^non deve esserci il link "([^"]*)"$/ do |link|
  l = find_link(link)
  assert l.nil? || !find_link(link).visible?
end

Allora /^non deve esserci il bottone "([^"]*)"$/ do |bottone|
  l = find_button(bottone)
  assert l.nil? || !l.visible?
end

Quando /^seleziono il checkbox "([^"]*)"$/ do |field|
  check(field)
end

Quando /^deseleziono il checkbox "([^"]*)"$/ do |field|
  uncheck(field)
end

Quando /^compilo il campo data "([^"]*)" con "([^"]*)"$/ do |datetime_id_prefix, date|
  date = DateTime.strptime(date, "%d/%m/%Y")

  id_prefix = datetime_id_prefix

  select date.year.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:year]}"
  select ['~', 'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'][date.month], :from => "#{id_prefix}_#{date_and_time_suffixes[:month]}"
  select date.day.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:day]}"
end

Quando /^compilo il campo data e ora "([^"]*)" con "([^"]*)"$/ do |datetime_id_prefix, datetime|
  date = DateTime.strptime(datetime, "%d/%m/%Y %H:%M")

  id_prefix = datetime_id_prefix

  select date.year.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:year]}"
  select ['~', 'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'][date.month], :from => "#{id_prefix}_#{date_and_time_suffixes[:month]}"
  select date.day.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:day]}"
  select date.hour.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:hour]}"
  select date.min.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:minute]}"
end

Quando /^compilo il campo mese "([^"]*)" con "([^"]*)"$/ do |datetime_id_prefix, mese|
  id_prefix = datetime_id_prefix
  if !mese.blank?
    date = DateTime.strptime("01/#{mese}", "%d/%m/%Y")
    select date.year.to_s, :from => "#{id_prefix}_#{date_and_time_suffixes[:year]}"
    select ['~', 'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'][date.month], :from => "#{id_prefix}_#{date_and_time_suffixes[:month]}"
  else
    select '', :from => "#{id_prefix}_#{date_and_time_suffixes[:year]}"
    select '', :from => "#{id_prefix}_#{date_and_time_suffixes[:month]}"
  end
end

def date_and_time_suffixes
   {
    :year   => '1i',
    :month  => '2i',
    :day    => '3i',
    :hour   => '4i',
    :minute => '5i'
  }
end

Quando /^seleziono "([^"]*)" in "([^"]*)"$/ do |opzione, campo|
  select(opzione, :from => campo)
end

Allora /^il campo "([^"]*)" deve contenere "([^"]*)"$/ do |field, value|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  if field_value.respond_to? :should
    field_value.should =~ /#{value}/
  else
    assert_match(/#{value}/, field_value)
  end
end

Quando /^allego il file "([^"]*)" in "([^"]*)"(?: all'interno di "([^"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, File.join(Rails.root, path))
  end
end

# step specifico per inibire la finestra di conferma e considerala come chiusa
# con conferma positiva.
Quando /^mi preparo per confermare l'alert del prossimo step$/ do
  page.evaluate_script("window.alert = function(msg) { return true; }")
  page.evaluate_script("window.confirm = function(msg) { return true; }")
end

Quando /^esco dall'applicativo$/ do
  click_link('esci')
end

Allora /^il campo "([^"]*)" deve essere disabilitato$/ do |label|
  #field_labeled(label).should be_disabled
  assert field_labeled(label)['disabled'] =~ /disabled|true/
end

Allora /devo poter scaricare il documento odt "([^"]*)"/ do |label|
  click_link(label)
  page.response_headers['Content-Type'].should == 'application/vnd.oasis.opendocument.text'
end

Allora /devo poter scaricare il documento pdf "([^"]*)"/ do |label|
  click_link(label)
  page.response_headers['Content-Type'].should == 'application/pdf'
end

=begin
Allora /posso scaricare il documento pdf "([^"]*)"/ do |label|
  click_link(label)
  puts response.content_type
  #temp_pdf = Tempfile.new("pdf")
  #temp_pdf << response.body
  #temp_pdf.close
  #temp_txt = Tempfile.new("txt")
  #temp_txt.close
  #`pdftotext -q #{temp_pdf.path} #{temp_txt.path}`
  #response.body = File.read temp_txt.path
end
=end

Quando /scarico il documento pdf "([^"]*)"/ do |label|
  click_link(label)
  #temp_pdf = Tempfile.new("pdf")
  #temp_pdf << response.body
  #temp_pdf.close
  #temp_txt = Tempfile.new("txt")
  #temp_txt.close
  #`pdftotext -q #{temp_pdf.path} #{temp_txt.path}`
  #response.body = File.read temp_txt.path
end

Quando /^attendi (\d+) secondi$/ do |sec|
  sleep sec.to_i
end

Allora /^il campo "([^"]*)" non deve contenere l'opzione "([^"]*)"$/ do |campo,opzione|
  # l'opzione non deve esistere
  test = field_labeled(campo).find(:xpath, ".//option[.='#{opzione}']").nil?
  test.should be_true
end

Dato /^che oggi è il "([^"]*)"$/ do |data|
  # Sovrascrio il metodo Date#today utilizzato per ottenere la data di oggi
  # in modo da far credere al sistema che oggi sia il giorno <data>
  $OGGI = Date.parse(data)
  Date.class_eval do
    def self.today
      $OGGI
    end
  end
end

Dato /^che ora sono le "(\d\d\:\d\d)" del "([^"]*)"$/ do |ora, data|
  # Sovrascrio il metodo Date#today utilizzato per ottenere la data di oggi
  # in modo da far credere al sistema che oggi sia il giorno <data>
  $OGGI = Date.parse(data)
  hh, mm = ora.split(/\:/)
  $ORA = Time.mktime($OGGI.year, $OGGI.month, $OGGI.day, hh.to_i, mm.to_i)
  Date.class_eval do
    def self.today
      $OGGI
    end
  end
  Time.class_eval do
    def self.now
      $ORA
    end
  end
end

Allora /^(?:|io )devo essere in (.+)$/ do |page_path|
  assert_equal send(page_path), URI.parse(current_url).path
end

# es: Quando vado alla pagina root_path
# usa i metodi di routing definiti nel file routes.rb
Quando /visito la pagina ([^\b]*)_path$/ do |path_name|
  visit send("#{path_name}_path")
end


# View: app/views/reports/index.pdf.prawn
pdf.fill_color "0000ff"
pdf.text "Clients", :at => [200,720], :size => 32
pdf.font "Times-Roman"
pdf.fill_color "000000"
@customers.each do |customer|
  pdf.text customer.name
end
pdf.text "Powered by Rails", :at => [288,50]


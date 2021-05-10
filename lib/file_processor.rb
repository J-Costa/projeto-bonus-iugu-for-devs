require 'json'
require_relative '../invoice'
class FileProcessor
  @invoices = JSON.parse(Invoice.all.to_json, symbolize_names: true)

  @bills = @invoices.select { |i| i[:payment_method] == "Boleto"}
  @pixs =  @invoices.select { |i| i[:payment_method] == "Pix"}
  @credit_cards = @invoices.select { |i| i[:payment_method] == "Cartão de crédito"}
  @invoices = []
  @invoices << @bills
  @invoices << @pixs
  @invoices << @credit_cards

  def self.name_file(name)
    file_name =
    "#{Time.now.year}"\
    "#{'%02d' % Time.now.month}#{'%02d' % Time.now.day}"\
    "_#{name.upcase.gsub(' ', '_')}_EMISSAO.txt"
  end

  def self.write_file
    @invoices.each do |invoice|
      head(invoice.count, invoice[0][:payment_method])
      body(invoice)
    end
  end

  def self.head(count, name)
    Dir.mkdir("./output") unless File.exists?("./output")
    payment_method_file_path = "./output/#{name_file(name)}"
    invoice_file = File.open(payment_method_file_path, "a+")
  
    invoice_file.write("H#{'%05d' % count}")
  end

  def self.body(invoice_array)
    invoice_array.each do |invoice|
      "B#{invoice[:token]}"\
      " #{invoice[:due_date]}"\
      " 00000000 "\
      "#{'%010d' % invoice[:value]} 01"
    end
  end
end

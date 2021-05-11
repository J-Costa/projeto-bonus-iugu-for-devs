require 'json'
require_relative '../invoice'
class FileProcessor
  @invoices = JSON.parse(Invoice.all.to_json, symbolize_names: true)

  @bills = @invoices.select { |i| i[:payment_method] == "Boleto"}
  @pixs =  @invoices.select { |i| i[:payment_method] == "Pix"}
  @credit_cards = @invoices.select { |i| i[:payment_method] == "Cartão de crédito"}
  @invoices, @totals = [], []
  @invoices << @bills
  @invoices << @pixs
  @invoices << @credit_cards
  
  def self.get_total(invoices)
    invoices.inject(0) { |sum, hash| sum + hash[:value] }
  end

  @totals << get_total(@bills)
  @totals << get_total(@pixs)
  @totals << get_total(@credit_cards)
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
      footer(invoice, )
    end
  end

  def self.head(count, name)
    invoice_file = create_file(name)

    if invoice_file.size == 0
      invoice_file.write("H#{'%05d' % count}")
    else
      return
    end
  end

  def self.body(invoice_array)
    invoice_array.each do |invoice|
      invoice_file = create_file(invoice[:payment_method])
      invoice_file.write("\nB#{invoice[:token]}"\
      " #{invoice[:due_date]}"\
      " 00000000 "\
      "#{'%010d' % invoice[:value]} 01")
    end
  end

  def self.footer(invoice_array)
    invoice_array.each_with_index do |invoice, index|
      invoice_file = create_file(invoice[:payment_method])
      invoice_file.write("\nF#{'%015d' % @totals[index]}")
    end
  end

  def self.create_file(name)
    Dir.mkdir("./output") unless File.exists?("./output")
    payment_method_file_path = "./output/#{name_file(name)}"
    invoice_file = File.open(payment_method_file_path, "a+")
  end
end

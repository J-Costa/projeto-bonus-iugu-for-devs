require 'faraday'
require 'fileutils'
require_relative 'invoice'
require 'json'
require 'sidekiq'
require_relative 'lib/support'

invoices = JSON.parse(Invoice.all.to_json, symbolize_names: true)

bill_quantity =  invoices.select { |i| i[:payment_method] == "Boleto"}.count
pix_quantity =  invoices.select { |i| i[:payment_method] == "Pix"}.count
credit_card_quantity = invoices.select { |i| i[:payment_method] == "Cartão de crédito"}.count

def head(file_name)
  payment_method_file_path = "./output/#{file_name}"
  invoice_file = File.open(payment_method_file_path, "a+")
  Dir.mkdir("./output") unless File.exists?("./output")

  invoice_file.write("H#{'%05d' % bill_quantity}")
  invoice_file.write("H#{'%05d' % pix_quantity}")
  invoice_file.write("H#{'%05d' % credit_card_quantity}")
end

invoices.each do |invoice|
  file_name = name_file(invoice[:payment_method])
  File.open(file_name, 'a+')
end

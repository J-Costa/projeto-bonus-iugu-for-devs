
def name_file(name)
  file_name =
  "#{Time.now.year}"\
  "#{'%02d' % Time.now.month}#{'%02d' % Time.now.day}"\
  "_#{name.upcase.gsub(' ', '_')}_EMISSAO.txt"
end

def write_file
  
end

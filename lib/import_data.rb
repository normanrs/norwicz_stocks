require 'json'
module ImportData

  def import_json(path)
    file = File.read(path)
    JSON.parse(file, :symbolize_names => true)
  end

end

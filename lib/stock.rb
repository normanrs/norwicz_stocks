class Stock 
  
  def initialize(hash_in)
    hash_in.each do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.send(:attr_reader, key) 
    end
  end
  
end
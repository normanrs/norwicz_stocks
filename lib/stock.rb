class Stock 
  
  def initialize(hash_in)
    hash_in.each do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.send(:attr_reader, key) 
    end
  end

  def ffo 
    require 'pry'; binding.pry
    #FFO is net_income + depreciation_and_amortization - gain_from_sale_of_real_estate
    net = self.NetIncome.to_f
  end

end
# frozen_string_literal: true

require 'csv'
require 'yaml'

module DataHelper
  def stock_list
    if env_config == 'dev'
      ['AAPL']
    else
      stocks
    end
  end

  def stocks
    @stocks ||= CSV.read('stocks.csv', 'r:bom|utf-8').flatten
  end

  def config
    yaml_file = YAML.safe_load(File.read('config.yml'), aliases: true)
    @config ||= yaml_file.dig(env_config)
  end

  def env_config
    @env_config ||= ENV['CONFIG'] || 'dev'
  end

  def aws_creds
    !ENV['AWS_ACCESS_KEY_ID'].nil?
  end

  def top_reit?(hash_in)
    hash_in.dig('dividendyieldpercentagettm').to_f > 4.5 &&
      hash_in.dig('freecashflowpersharettm').to_f.positive? &&
      hash_in.dig('interestcoveragettm').to_f > 1.2 &&
      hash_in.dig('netcurrentassetvaluettm').to_f > -50.0 &&
      hash_in.dig('netdebttoebitdattm').to_f.between?(-1.0, 15.0) &&
      hash_in.dig('netincomepersharettm').to_f.positive? &&
      hash_in.dig('payoutratiottm').to_f.between?(0.2, 2.1)
  end

  def top_reits(data)
    data.select do |_key, value|
      top_reit?(value)
    end.keys
  end
end

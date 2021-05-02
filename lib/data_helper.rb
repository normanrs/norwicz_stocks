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
    @stocks ||= CSV.read('data/stocks.csv', 'r:bom|utf-8').flatten
  end

  def config
    yaml_file = YAML.safe_load(File.read('config.yml'), aliases: true)
    @config ||= yaml_file.dig(env_config)
  end

  def env_config
    @env_config ||= ENV['CONFIG'] || 'dev'
  end

  def top_reit?(hash_in)
    hash_in.dig('netIncomePerShareTTM').to_f.positive? &&
      hash_in.dig('freeCashFlowPerShareTTM').to_f.positive? &&
      hash_in.dig('netCurrentAssetValueTTM').to_f > -50.0 &&
      hash_in.dig('netDebtToEBITDATTM').to_f.between?(-1.0, 15.0) &&
      hash_in.dig('dividendYieldPercentageTTM').to_f > 4.8 &&
      hash_in.dig('payoutRatioTTM').to_f.between?(0.2, 2.1) &&
      hash_in.dig('interestCoverageTTM').to_f > 1.3
  end

  def top_reits(data)
    data.select do |_key, value|
      top_reit?(value)
    end.keys
  end
end

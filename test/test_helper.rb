# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

def safe_delete(path_to_file)
  File.delete(path_to_file) if File.exist?(path_to_file)
end

def sample_fmp_data
  { 'SMPL' =>
    {
      "revenuePerShareTTM": 5.747571915123095,
      "netIncomePerShareTTM": 0.46137636777201,
      "operatingCashFlowPerShareTTM": 2.1181445430776824,
      "freeCashFlowPerShareTTM": 1.0591473327700405,
      "cashPerShareTTM": 2.2907520142889894,
      "bookValuePerShareTTM": 21.208000426347795,
      "tangibleBookValuePerShareTTM": 46.51154179021537,
      "shareholdersEquityPerShareTTM": 21.208000426347795,
      "interestDebtPerShareTTM": 24.356385388046967,
      "marketCapTTM": 2_046_729_017.7,
      "enterpriseValueTTM": 3_316_147_017.7,
      "peRatioTTM": 73.99598762472885,
      "priceToSalesRatioTTM": 5.939899579189316,
      "pocfratioTTM": 16.117880203961096,
      "pfcfRatioTTM": 32.233475876025636,
      "pbRatioTTM": 1.6097698657901816,
      "ptbRatioTTM": 1.6097698657901816,
      "evToSalesTTM": 9.623931700104187,
      "enterpriseValueOverEBITDATTM": 16.844092474336247,
      "evToOperatingCashFlowTTM": 26.114478227349686,
      "evToFreeCashFlowTTM": 52.22525501519757,
      "earningsYieldTTM": 0.013514246273345343,
      "freeCashFlowYieldTTM": 0.031023647708554203,
      "debtToEquityTTM": 1.0284385760420058,
      "debtToAssetsTTM": 0.5551052440467127,
      "netDebtToEBITDATTM": 6.44790296282375,
      "currentRatioTTM": 0.7829579389583439,
      "interestCoverageTTM": 1.6575785928143714,
      "incomeQualityTTM": 4.590925524222704,
      "dividendYieldTTM": 0.028705330990041005,
      "dividendYieldPercentageTTM": 2.8705330990041005,
      "payoutRatioTTM": 2.12407931670282,
      "salesGeneralAndAdministrativeToRevenueTTM": 0.0771418538306832,
      "researchAndDevelopementToRevenueTTM": 0.0,
      "intangiblesToTotalAssetsTTM": 0.010255531075930968,
      "capexToOperatingCashFlowTTM": -2.0001417590725805,
      "capexToRevenueTTM": -5.427372101814516,
      "capexToDepreciationTTM": -1.7057081653225807,
      "stockBasedCompensationToRevenueTTM": 0.018303813705658888,
      "grahamNumberTTM": 14.837775426233902,
      "roicTTM": 0.03381291037007885,
      "returnOnTangibleAssetsTTM": 0.009919610273359499,
      "grahamNetNetTTM": -23.708782105669368,
      "workingCapitalTTM": -42_881_000,
      "tangibleAssetValueTTM": 1_224_513_000,
      "netCurrentAssetValueTTM": -23.50607508074712,
      "investedCapitalTTM": 1.1064216849844508,
      "averageReceivablesTTM": 9_478_000.0,
      "averagePayablesTTM": 65_549_500,
      "averageInventoryTTM": nil,
      "daysSalesOutstandingTTM": 7.349298987442429,
      "daysPayablesOutstandingTTM": 178.58989919005276,
      "daysOfInventoryOnHandTTM": 0.0,
      "receivablesTurnoverTTM": 49.664600749495534,
      "payablesTurnoverTTM": 2.0437885997772605,
      "inventoryTurnoverTTM": nil,
      "roeTTM": 0.021451937887100453,
      "capexPerShareTTM": -1.0589972103076417,
      "dividendPerShareTTM": 0.98
    } }
end

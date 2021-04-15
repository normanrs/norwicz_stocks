# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

require 'csv'
require 'json'
require 'net/http'
require_relative 'request_helper'

class WriteFinanacials
  include RequestHelper

  FILENAME = "data/reit_data.json"
  FMP_RATIOS = '/ratios-ttm/'
  FMP_METRICS = '/key-metrics-ttm/'

  def write_statements
    files = Dir.foreach("data/")
    reit_data = files.find { |item| item.include?('reit_data.json') }
    update_reit_data({}) unless reit_data
    file = File.open(FILENAME, 'w')
    file_age = Time.now - file.mtime
    # Do not update financials less than 1 day old
    require 'pry'; binding.pry
    if file_age < 1
      puts 'Financial statements are up-to-date'
    else
      existing_financials = JSON.parse(File.read(FILENAME), {})
      update_reit_data(existing_financials)
    end
  end

  private

  def update_reit_data(hash_in)
    # FMP site limits calls with free membership, so this will
    # write half the data one day and the rest another day
    new_financials = {}
    if Date.today.day.odd?
      new_financials = financials(FMP_RATIOS)
    else
      new_financials = financials(FMP_METRICS)
    end
    write_hash = hash_in.merge(new_financials)
    require 'pry'; binding.pry
    write_json(write_hash)
  end

  def write_json(hash_in)
    filename = "data/reit_data.json"
    File.open(filename, 'w') do |f|
      f.write(JSON.pretty_generate(hash_in, indent: "\t", object_nl: "\n"))
    end
  end

  def stocks
    stock_list.join(',')
  end

  def financials(call)
    @financials ||= begin
      responses = []
      stock_list.each do |stock|
        new_hash = { stock => financial_update(stock, call) }
        responses << new_hash
      rescue StandardError => e
        puts "Error building #{stock} data: #{e.message}"
      end
      responses
    end
  end

  def financial_update(stock, call)
    call_fmp(call, stock) || {}
  end

  def stock_list
    %w[
    AAT
    ACC
    ADC
    AFCG
    AFIN
    AHH
    AHT
    AIRC
    AIV
    AKR
    ALEX
    ALX
    AMH
    AMT
    APLE
    APTS
    ARE
    AVB
    BDN
    BFS
    BHR
    BNL
    BPYU
    BRG
    BRT
    BRX
    BXP
    CCI
    CDOR
    CDR
    CHCT
    CIO
    CLDT
    CLI
    CLNY
    CLPR
    CMCT
    COLD
    CONE
    COR
    CORR
    CPLG
    CPT
    CSR
    CTRE
    CTT
    CUBE
    CUZ
    CXP
    CXW
    DEA
    DEI
    DHC
    DLR
    DOC
    DRE
    DRH
    EGP
    ELS
    EPR
    EQC
    EQIX
    EQR
    ESRT
    ESS
    EXR
    FCPT
    FPI
    FR
    FRT
    FSP
    GEO
    GLPI
    GMRE
    GNL
    GOOD
    GTY
    HIW
    HMG
    HPP
    HR
    HST
    HT
    HTA
    IIPR
    ILPT
    INN
    INVH
    IRM
    IRT
    JBGS
    KIM
    KRC
    KRG
    LAMR
    LAND
    LSI
    LTC
    LXP
    MAA
    MAC
    MDRR
    MGP
    MNR
    MPW
    NHI
    NNN
    NSA
    NTST
    NXRT
    NYC
    O
    OFC
    OHI
    OLP
    OPI
    OUT
    PCH
    PDM
    PEAK
    PEB
    PEI
    PGRE
    PINE
    PK
    PLD
    PSA
    PSB
    PW
    QTS
    REG
    REXR
    RHP
    RLJ
    ROIC
    RPAI
    RPT
    RVI
    RYN
    SAFE
    SBAC
    SBRA
    SELF
    SHO
    SITC
    SKT
    SLG
    SOHO
    SPG
    SQFT
    SRC
    SRG
    STAG
    STOR
    SUI
    SVC
    TRNO
    UBA
    UBP
    UDR
    UE
    UHT
    UMH
    UNIT
    VER
    VICI
    VNO
    VTR
    WELL
    WHLR
    WPC
    WPG
    WPTIF
    WRE
    WRI
    WSR
    WY
    XHR
  ]
  end

end
# rubocop:enable Metrics/PerceivedComplexity

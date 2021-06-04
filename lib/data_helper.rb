# frozen_string_literal: true

require 'yaml'

module DataHelper
  def stock_list
    if env_config == 'dev'
      ['AAPL']
    else
      stocks
    end
  end

  def config
    yaml_file = YAML.safe_load(File.read('config.yml'), aliases: true)
    @config ||= yaml_file.dig(env_config)
  end

  def env_config
    ENV['CONFIG'] || 'dev'
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

  def deep_dup(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def stocks
    %w[
      AAT
      AB
      ABR
      ACC
      ACRE
      ADC
      AFIN
      AHH
      AIV
      ALX
      ANH
      APTS
      ARCC
      ARE
      ARI
      ARR
      AVB
      BANX
      BDN
      BFS
      BNL
      BPYU
      BRG
      BRMK
      BRT
      BXMT
      BXP
      CCI
      CEQP
      CGBD
      CHCT
      CHMI
      CIK
      CIO
      CLM
      CLNY
      CLPR
      CMCT
      COLD
      CONE
      COR
      CORR
      CPLG
      CPT
      CRF
      CSR
      CTRE
      CTT
      CUBE
      CUZ
      CXP
      DEA
      DEI
      DHY
      DLR
      DOC
      DRE
      DX
      EAD
      EARN
      ECF
      ELS
      EPD
      EQC
      EQR
      ESS
      EXR
      FCPT
      FDUS
      FR
      FRT
      FSP
      FTF
      GBDC
      GEO
      GGN
      GILT
      GLO
      GLPI
      GLQ
      GMRE
      GNL
      GOOD
      GTY
      HIW
      HMG
      HPP
      HR
      HRZN
      HTA
      IFN
      IIPR
      ILPT
      IRCP
      IRM
      IRT
      JBGS
      KIM
      KRC
      KREF
      KRG
      LAMR
      LAND
      LFT
      LOAN
      LSI
      LTC
      LXP
      MAA
      MAC
      MGP
      MITT
      MMP
      MNDO
      MNR
      MPLX
      MPW
      NEWT
      NHI
      NHS
      NLY
      NMFC
      NNN
      NREF
      NSA
      NTST
      NXRT
      NYC
      O
      OCCI
      OFC
      OFS
      OHI
      OLP
      OPI
      OXSQ
      PAGP
      PCH
      PDM
      PEAK
      PFLT
      PGRE
      PINE
      PLD
      PLYM
      PMT
      PNNT
      PSA
      PSB
      PSEC
      QTS
      RC
      REG
      RYN
      SACH
      SBRA
      SCM
      SELF
      SKT
      SLG
      SLRC
      SPG
      SQFT
      SRC
      STAG
      STAY
      STOR
      STWD
      SUNS
      TCPC
      TPVG
      TRMT
      TSLX
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
      WHF
      WPC
      WRE
      WRI
      WSR
    ]
  end
end

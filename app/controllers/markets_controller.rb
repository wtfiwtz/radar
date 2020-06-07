class MarketsController < ApplicationController
  def index
    @watchlist = watchlist
    date_to = DateTime.new(2020,01,31)
    date_from = date_to - 30.days
    dailies = DailySummary.includes(:company).where(symbol: @watchlist)
                           .where('date >= ? AND date <= ?', date_from, date_to).to_a
    sort_dailies_by_percent(dailies, date_to)
    @dailies, @last_date = symbol_date_hash(dailies)
    @first_date = @last_date - (date_to - date_from).to_i * 1.day.to_i
  end

  def show
    start_at = 6.months.ago
    @company = Company.find_by(symbol: params[:id]) # .includes(:dailies, :daily_summaries, :chains)
    @dailies = @company.dailies.where('date >= ?', start_at).order(date: :desc)
    @daily_summaries = @company.daily_summaries.where('date >= ?', start_at).order(date: :desc)
    @chains = @company.chains.where('start_at >= ? or finish_at >= ?', start_at, start_at)
  end

  def crypto_market_cap
    start_at = 6.months.ago
    @cryptos = CryptoCurrency.includes(:cryptos).joins(:cryptos)
                             .where('cryptos.date >= ?', start_at)
                             .where('cryptos.rank <= ?', 150)
                             .order('cryptos.date DESC, cryptos.rank ASC')
  end

  private

  def watchlist
    %w[QAN RRL MTS LVH DTC BRN DSE NEC
                              WSP CKF Z1P TYR
                              ADH PCK
                              KGN AQG NXT REA PPH EVN AKP OGC CDD MML PRX EQT PRU
                              SZL SWF MA1 OPY IXC APT JIN JBH JHG RZI
                              DXB HVM XTE IFL VRX G1A

                              MEM FXL PPE CXO PPK PDN PDL SUL AQZ SLK HAW RHT PNI
                              HM1 PMV QVE CAN HMC VMT EZL PIC MOT MDI RKN EGG INA
                              ALL CMP WTC CTD CDV AGH ATL MOE FHS MMJ AZY EOF 14D
                              AVN TAH BGA CQE SCG LIC MVP WES BTI ORG GNE LSF PPT
                              HLO TCL WPL MFF SEK MME TLX STO HPI PBH SKC BRV AMX RMC

                              LON PFP CGB PAR AVL PWG BUB HIT TIE CBR SND AEF
                              CGF FLN MFG YAL KWR TLT PSQ APX RBL OBM TNE PL8
                              BCN BCB CYL OKU AHZ WND CAM ALU CUP NXS MXT IRE
                              IRI TDI NAN BRG HTA HRL MDR EVO S2R CZR ENR HGO
                              UBN POS WQG WEC NAG PAB TAM PAA PG1 EBO STG ELO
                              ELS M7T TGG MAU FML BRB PWH SPL TD1 CUV IDT TPW
                              TGA ANP TTB NVX DMP AUI UWL SMR GOZ WHC WMI CDM
                              HAV WBT TNY ALG THC GCI AMP SIQ LCL SOR AEG SPT
                              UBI AHF NOV GMD CCV SPX ARV BSX AGG ZEN PNR TBR
                              MSB IMC CLQ CT1 ALQ SGF BIN FAR MCA RAP ICE IMU
                            ]
  end

  def sort_dailies_by_percent(dailies, date_to)
    dailies.sort_by! do |x|
      next 2**16.to_f * (date_to - x.date.to_datetime).to_i if x.date < date_to
      -x.change_pct
    end
  end

  def symbol_date_hash(source)
    dailies = {}
    last_date = 0
    source.each do |daily|
      last_date = (daily.date.to_i) if daily.date.to_i >= last_date
      dailies[daily.symbol] ||= {}
      dailies[daily.symbol][daily.date.to_i] = daily
    end
    [dailies, last_date]
  end
end

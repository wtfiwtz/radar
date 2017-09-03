class MarketsController < ApplicationController
  def show
    start_at = 90.days.ago
    @company = Company.includes(:dailies, :daily_summaries, :chains).find_by(symbol: params[:id])
    @dailies = @company.dailies.where('date >= ?', start_at)
    @daily_summaries = @company.daily_summaries.where('date >= ?', start_at)
    @chains = @company.chains.where('start_at >= ? or finish_at >= ?', start_at, start_at)
  end

  def crypto_market_cap
    start_at = 90.days.ago
    @cryptos = CryptoCurrency.includes(:cryptos).joins(:cryptos)
                             .where('cryptos.date >= ?', start_at)
                             .where('cryptos.rank <= ?', 150)
                             .order('cryptos.rank ASC, cryptos.date DESC')
  end
end

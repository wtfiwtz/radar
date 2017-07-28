class MarketsController < ApplicationController
  def show
    @company = Company.includes(:dailies, :daily_summaries).find_by(symbol: params[:id])
    @dailies = @company.dailies.where('date >= ?', 90.days.ago)
    @daily_summaries = @company.daily_summaries.where('date >= ?', 90.days.ago)
  end
end

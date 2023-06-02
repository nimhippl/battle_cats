class StatisticController < ApplicationController
  def index

  end

  def statistic
    @stat_list = Record.where(user_id: session[:current_user])
  end
end

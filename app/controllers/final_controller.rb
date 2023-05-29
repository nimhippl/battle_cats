class FinalController < ApplicationController
    def index
      @winner = params[:winner]
    end
  end
  
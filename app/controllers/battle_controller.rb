class BattleController < ApplicationController
  include GameHelper

  @@battles = {}

  def index

  end

  def start_battle
    @left = create_Samewrai
    @right = create_Bulk
    @@battles[session.id.to_s] = {first: @left, second: @right, turn: 1}
  end

  def battle
    if params.has_key? :move_id
      turn params[:move_id].to_i
    else
      start_battle
    end
    id = session.id.to_s
    @left = @@battles[id][:first]
    @right = @@battles[id][:second]
    @turn = @@battles[id][:turn]
    @current = if @turn == 1
                 @left
               else
                 @right
               end

    end

  def turn(move_id)
    id = session.id.to_s
    turn = @@battles[id][:turn]
    first = @@battles[id][:first]
    second = @@battles[id][:second]
    if turn == 1
      first.take_turn1(move_id, second)
      @@battles[id][:turn] = 2
    else
      second.take_turn1(move_id, first)
      @@battles[id][:turn] = 1
    end

  end

end

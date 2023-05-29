class BattleController < ApplicationController
  include GameHelper

  @@battles = {}

  def index

  end

  def choose1
    @@battles[session.id.to_s] = {first: nil , second: nil, turn: 1}
  end

  def choose2
    cat = params[:cat]
    case cat
    when "Voyka"
      @@battles[session.id.to_s][:first] = create_Voyaka
    when "Samewrai"
      @@battles[session.id.to_s][:first] = create_Samewrai
    when "Kogtic"
      @@battles[session.id.to_s][:first] = create_Kogtic
    when "Bulk"
      @@battles[session.id.to_s][:first] = create_Bulk
    when "Mewlitvenik"
      @@battles[session.id.to_s][:first] = create_Mewlitvenik
    when "Mewg"
      @@battles[session.id.to_s][:first] = create_Mewg
    end
  end

  def start_battle
    cat = params[:cat]
    case cat
    when "Voyka"
      @@battles[session.id.to_s][:second] = create_Voyaka
    when "Samewrai"
      @@battles[session.id.to_s][:second] = create_Samewrai
    when "Kogtic"
      @@battles[session.id.to_s][:second] = create_Kogtic
    when "Bulk"
      @@battles[session.id.to_s][:second] = create_Bulk
    when "Mewlitvenik"
      @@battles[session.id.to_s][:second] = create_Mewlitvenik
    when "Mewg"
      @@battles[session.id.to_s][:second] = create_Mewg
    end
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

    if first.current_hp <= 0
      redirect_to "/final?winner=2"
    elsif second.current_hp <= 0
      redirect_to "/final?winner=1"
    end

  end

end

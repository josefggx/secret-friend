class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    @game = GameCreator.new(game_params).create_game

    if @game.save
      render 'games/create', status: :created
    else
      render 'errors/error', locals: { object: @game }, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:year_game)
  end
end

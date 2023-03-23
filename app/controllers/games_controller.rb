class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    @game = GameCreator.new(game_params).create_game

    if @game.save
      @game
    else
      @errors = @game.errors.full_messages.first
      render json: { "error": { "message": @errors, "code": 002, "object": "game", "index": 0 } },
             status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:year_game)
  end

  def actual_year
    game_params[:year_game].to_i
  end

  def last_year
    (game_params[:year_game].to_i - 1).to_s
  end

  def next_year
    (game_params[:year_game].to_i + 1).to_s
  end
end

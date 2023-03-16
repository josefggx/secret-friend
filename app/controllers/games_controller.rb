class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    @game = Game.create(game_params) do |game|
      game.available_workers = Worker.order("random()").all
    end

    puts "year game: #{game_params[:year_game]}"

    last_year = (game_params[:year_game].to_i - 1).to_s
    last_worker_without_play = Game.where(year_game: last_year).first&.worker_without_play
    next_year = (game_params[:year_game].to_i + 1).to_s
    next_worker_without_play = Game.where(year_game: next_year).first&.worker_without_play

    puts "last year without play: #{last_worker_without_play}"
    puts "next year without play: #{next_worker_without_play}"
    # puts  Game.where(year_game: [last_year, next_year])

    # TODO: Tenemos que hacer que last y next worker_without_play sean los primeros
    #       cuando recorremos @game.available_workers

    available_workers_ids = @game.available_workers.map { |worker| worker.id }
    game_couples = []
    workers_already_coupled = []
    not_play = nil

    @game.available_workers.each_with_index do |worker, index|

      puts "worker_id: #{worker.id}"
      puts "already coupled #{index}: #{workers_already_coupled.to_s}"
      next if workers_already_coupled.include?(worker.id)

      couple_options = available_workers_ids - ([worker.id] + workers_already_coupled)
      puts "options #{index}: #{couple_options.to_s}"
      if couple_options.size > 0
        couple_pick = @game.available_workers.find(couple_options.sample)
        couple = {
          first_player_name: worker.name, first_player_id: worker.id,
          second_player_name: couple_pick.name, second_player_id: couple_pick.id }
        workers_already_coupled.push(worker.id, couple_pick.id)
        @game.couples << couple
      else
        @game.worker_without_play_id = worker.id
      end
    end

    if @game.save
      @game
    else
      @errors = @game.errors.full_messages.first
      render json: {
        "error": {
          "message": @errors,
          "code": 002,
          "object": "game",
          "index": 0
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:year_game)
  end
end

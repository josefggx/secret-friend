class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    @game = Game.create(game_params) do |game|
      puts "year game: #{game_params[:year_game]}"

      @last_worker_without_play_id = Game.where(year_game: last_year).first&.worker_without_play_id
      @next_worker_without_play_id = Game.where(year_game: next_year).first&.worker_without_play_id

      # @last_worker_without_play_id = 1
      # @next_worker_without_play_id = 3

      puts "last year without play: #{@last_worker_without_play_id}"
      puts "next year without play: #{@next_worker_without_play_id}"

      # game.available_workers = Worker.order("random()").all

      prepended_ids = [@last_worker_without_play_id.to_i, @next_worker_without_play_id.to_i]
      available_workers = Worker.order(Arel.sql("ARRAY_POSITION(ARRAY#{prepended_ids}, id),
          CASE WHEN id IN (#{prepended_ids.join(',')}) THEN 0 ELSE random() END")).all

      available_workers_ids = available_workers.map(&:id)
      puts "List: #{available_workers_ids}"
      workers_already_coupled = []

      available_workers.each_with_index do |worker, index|
        puts "worker_id: #{worker.id}"
        puts "already coupled #{index}: #{workers_already_coupled.to_s}"
        next if workers_already_coupled.include?(worker.id)

        couple_options = available_workers_ids -
                         ([worker.id] + workers_already_coupled + worker.find_restricted_partner_ids(actual_year))
        puts "options #{index}: #{couple_options.to_s}"
        puts "Clase de las opciones: #{couple_options[0]} #{couple_options[0].class}"
        puts "Clase de del next year: #{@next_worker_without_play_id} #{@next_worker_without_play_id.class}"

        if couple_options.size.positive?
          couple_pick = if @next_worker_without_play_id.in?(couple_options)
                          puts 'ELEGI AL DEL AÑO SIGUIENTE'
                          available_workers.find(@next_worker_without_play_id)
                        else
                          puts 'ELEGI AL AZAR'
                          available_workers.find(couple_options.sample)
                        end
          puts "pick #{couple_pick.to_json}"
          # couple = { first_player_name: worker.name, first_player_id: worker.id,
          #   second_player_name: couple_pick.name, second_player_id: couple_pick.id }
          workers_already_coupled.push(worker.id, couple_pick.id)
          # @game.couples << couple
          couple = Couple.create(first_worker: worker, second_worker: couple_pick, game_id: game.id, year_game: game.year_game)
          game.couples << couple
        else
          game.worker_without_play_id = worker.id
          # @game.includes(:worker_without_play)
          # NotPlayingWorker.create(game_id: @game.id, worker_id: worker.id).save
        end
      end
    end

    puts "PAREJAS: #{@game.couples.to_a}"


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

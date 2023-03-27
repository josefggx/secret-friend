# frozen_string_literal: true

class GameCreator
  def initialize(game_params)
    @game_params = game_params
    @workers_already_coupled = []
    @available_workers = find_available_workers
    @available_workers_ids = @available_workers.map(&:id)
  end

  def create_game
    game = Game.new(game_params)
    generate_all_couples(game)

    game
  end

  private

  attr_reader :game_params

  def find_available_workers
    last_and_next_worker_without_play_ids = [last_worker_without_play_id.to_i, next_worker_without_play_id.to_i]
    Worker.order(Arel.sql("ARRAY_POSITION(ARRAY#{last_and_next_worker_without_play_ids}, id),
    CASE WHEN id IN (#{last_and_next_worker_without_play_ids.join(',')}) THEN 0 ELSE random() END")).all
  end

  def generate_all_couples(game)
    @available_workers.each do |worker|
      next if @workers_already_coupled.include?(worker.id)

      couple_options = @available_workers_ids -
                       ([worker.id] + @workers_already_coupled + worker.find_restricted_partner_ids(actual_year))

      if couple_options.any?
        generate_couple_for_worker(worker, game, couple_options)
      else
        game.worker_without_play_id = worker.id
      end
    end
  end

  def generate_couple_for_worker(worker, game, couple_options)
    couple_pick = pick_partner(couple_options)
    @workers_already_coupled.push(worker.id, couple_pick.id)
    couple = Couple.create(first_worker: worker, second_worker: couple_pick, game_id: game.id)
    game.couples << couple
  end

  def pick_partner(couple_options)
    if next_worker_without_play_id.in?(couple_options)
      @available_workers.find(next_worker_without_play_id)
    else
      @available_workers.find(couple_options.sample)
    end
  end

  def next_worker_without_play_id
    Game.where(year_game: next_year).first&.worker_without_play_id
  end

  def last_worker_without_play_id
    Game.where(year_game: last_year).first&.worker_without_play_id
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

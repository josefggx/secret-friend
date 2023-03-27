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
    workers_without_play_ids = [last_worker_without_play_id, next_worker_without_play_id]
    Worker.order_by_without_play_first(workers_without_play_ids).all
  end

  def generate_all_couples(game)
    @available_workers.each do |worker|
      next if @workers_already_coupled.include?(worker.id)

      couple_options = find_couple_options(worker)

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

  def find_couple_options(worker)
    @available_workers_ids - ([worker.id] + @workers_already_coupled + worker.find_restricted_partners_ids(actual_year))
  end

  def next_worker_without_play_id
    Game.where(year_game: actual_year + 1).first&.worker_without_play_id.to_i
  end

  def last_worker_without_play_id
    Game.where(year_game: actual_year - 1).first&.worker_without_play_id.to_i
  end

  def actual_year
    game_params[:year_game].to_i
  end
end

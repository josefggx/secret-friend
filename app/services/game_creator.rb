# frozen_string_literal: true

class GameCreator
  def initialize(game_params)
    @game_params = game_params
    @workers_already_coupled = []
    @all_workers = find_and_order_all_workers
    @all_workers_ids = @all_workers.map(&:id)
  end

  def create_game
    game = Game.new(game_params)
    generate_all_couples(game)

    game
  end

  private

  attr_reader :game_params

  def find_and_order_all_workers
    workers_without_play_ids = [last_without_play_id, next_without_play_id]
    Worker.order_by_without_play_first(workers_without_play_ids).all
  end

  def generate_all_couples(game)
    @all_workers.each do |worker|
      next if @workers_already_coupled.include?(worker.id)

      pairing_options = find_pairing_options(worker)

      pairing_options.any? ? generate_couple(worker, pairing_options, game) : assign_without_play(game, worker)
    end
  end

  def find_pairing_options(worker)
    @all_workers_ids - ([worker.id] + @workers_already_coupled + worker.find_restricted_partners_ids(actual_year))
  end

  def assign_without_play(game, worker)
    game.worker_without_play = worker
  end

  def generate_couple(worker, pairing_options, game)
    partner = pick_partner(pairing_options)
    @workers_already_coupled.push(worker.id, partner.id)
    couple = Couple.create(first_worker: worker, second_worker: partner, game_id: game.id)
    game.couples << couple
  end

  def pick_partner(couple_options)
    return @all_workers.find(next_without_play_id) if next_without_play_id.in?(couple_options)

    @all_workers.find(couple_options.sample)
  end

  def next_without_play_id
    Game.where(year_game: actual_year + 1).first&.worker_without_play_id.to_i
  end

  def last_without_play_id
    Game.where(year_game: actual_year - 1).first&.worker_without_play_id.to_i
  end

  def actual_year
    game_params[:year_game].to_i
  end
end

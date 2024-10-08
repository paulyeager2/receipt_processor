class ReceiptsController < ApplicationController
  def create 
    id = SecureRandom.uuid
    Rails.cache.write(id, calculate_points(params), expires_in: 1.day)
    render json: params.merge(id: id), status: 201
  end

  def points 
    points = Rails.cache.read(params[:id])
    if points
      render json: { points: points }, status: 200
    else
      render json: { error: "Receipt not found" }, status: 404
    end
  end

  private 

  def calculate_points(receipt)
    points = 0
    points += receipt[:retailer].gsub(/[^0-9a-z]/i, '').length
    points += receipt[:total].to_f % 1 == 0 ? 50 : 0
    points += receipt[:total].to_f % 0.25 == 0 ? 25 : 0
    points += receipt[:items].length / 2 * 5
    receipt[:items].each do |item|
      points += item[:shortDescription].strip.length % 3 == 0 ? (item[:price].to_f * 0.2).ceil : 0
    end
    points += receipt[:purchaseDate].split("-")[2].to_i.odd? ? 6 : 0
    points += receipt[:purchaseTime] > "14:00" && receipt[:purchaseTime] < "16:00" ? 10 : 0
    points
  end
end
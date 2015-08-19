class PinsController < ApplicationController
  before_action :find_pin, only: [:show]

  def index
    @pins = Pin.all.order('created_at DESC')
  end

  def new
    @pin = Pin.new
  end

  def create
    @pin = Pin.new(pin_params)
    if @pin.save
      redirect_to :root, success: 'Pin was created successfully'
    else
      render 'new', error: 'Pin was not created'
    end
  end

  def show
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end
end

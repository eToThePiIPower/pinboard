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
      flash[:success] = 'Pin was created successfully'
      redirect_to :root
    else
      flash[:error] = 'Pin was not created'
      render 'new'
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

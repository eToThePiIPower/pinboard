class PinsController < ApplicationController
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

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end
end

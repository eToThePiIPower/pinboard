class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update]

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
      flash[:warning] = 'Pin was not created'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @pin.update(pin_params)
      flash[:success] = 'Pin was updated successfully'
      redirect_to @pin
    else
      flash[:warning] = 'Pin was not updated'
      render 'edit'
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end
end

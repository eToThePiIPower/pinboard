class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pins = Pin.all.order('created_at DESC')
  end

  def new
    @pin = current_user.pins.build
  end

  def create
    @pin = current_user.pins.build(pin_params)
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

  def destroy
    @pin.delete
    redirect_to :root
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end
end

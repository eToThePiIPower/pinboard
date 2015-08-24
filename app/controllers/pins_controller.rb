class PinsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_pin, only: [:show, :upvote]
  before_action :find_users_pin, only: [:edit, :update, :destroy]

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
      render :new, status: 400
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
      render :edit, status: 400
    end
  end

  def destroy
    @pin.delete
    redirect_to :root
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

  def find_users_pin
    begin
      @pin = current_user.pins.find(params[:id])
    rescue
      flash[:warning] = 'Invalid pin, or you are not the owner'
      @pin = Pin.find(params[:id])
      redirect_to @pin
    end
  end
end

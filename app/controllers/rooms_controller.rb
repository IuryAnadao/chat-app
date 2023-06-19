class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(:rooms, partial: 'shared/room', locals: { room: @room }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:room_form, partial: 'rooms/form', locals: { room: @room }) }
      end
    end
  end

  def edit
  end

  def show
  end

  def update
    @room.update(room_params)
  end

  def destroy
    @room.destroy
  end

  private

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:name)
    end

end

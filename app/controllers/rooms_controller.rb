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
        UserRoom.create(user: current_user, room: @room)
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("user_#{current_user.id}_rooms", partial: 'shared/room', locals: { room: @room }) }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def show
    @room
  end

  def update
    respond_to do |format|
      if @room.update(room_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("room_#{@room.id}", partial: 'shared/room', locals: { room: @room }) }
      else
        format.html { render :edit }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace("room_#{@room.id}", partial: 'rooms/form', locals: { room: @room }) }
      end
    end
  end

  def destroy
    @room.destroy
  end

  def add_user
    room_id = params[:room_id]
    UserRoom.create(user_id: params[:user_id], room_id: room_id)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("room_show_#{room_id}", partial: 'rooms/room', locals: { room: Room.find(room_id) }) }
    end
  end

  private

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:name)
    end

end

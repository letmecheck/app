class LeaderBoardsController < ApplicationController
  def index
    @users = User.order('wins DESC').all
  end
end

module GameHelper
  def display_game_pieces(x, y)
    @game = Game.find(params[:id])
    @piece = @game.pieces.where(x_coord: x, y_coord: y).first
    image_tag(@piece.img, class: "img-responsive draggable") if @piece.present?
  end
end

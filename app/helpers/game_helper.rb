module GameHelper
  def display_game_pieces(x, y)
    @game = Game.find(params[:id])
    @piece = @game.pieces.where(x_coord: x, y_coord: y).first
    #link_to image_tag(@piece.img, class: "img-responsive"), piece_path(@piece) if @piece.present?
    image_tag(@piece.img, class: "img-responsive") if @piece.present?
  end
end

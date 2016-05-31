module GameHelper
  def display_game_pieces(x, y)
    @piece = @game.pieces.find_by(x_coord: x, y_coord: y)
    # link_to image_tag(@piece.img, class: "img-responsive"), piece_path(@piece) if @piece.present?
  end
end

module PieceHelper
  def display_piece_pieces(x, y)
    if @piece == @piece.game.pieces.where(x_coord: x, y_coord: y).first
      link_to image_tag(@piece.img, class: "img-responsive active selected-piece"), piece_path(@piece) if @piece.present?
    else
      @other_piece = @piece.game.pieces.where(x_coord: x, y_coord: y).first
      link_to image_tag(@other_piece.img, class: "img-responsive"), piece_path(@other_piece) if @other_piece.present?
    end
  end    
end

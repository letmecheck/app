module GameHelper
  def display_pieces(x, y)
    @piece = @game.pieces.where(x_coord: x, y_coord: y).first
    #image_tag(link_to @piece.img, class: "img-responsive") if @piece.present?
    link_to image_tag(@piece.img, class: "img-responsive"), piece_path(@piece) if @piece.present?
  end
end

class NotificationMailer < ApplicationMailer
  default from: "letmecheck.firehose@gmail.com"

  def notify_move_made(piece)
    @game = piece.game
    @player = @game.current_player == "white" ? User.find(@game.black_player_id) : User.find(@game.white_player_id)
    mail(to: @player.email,
         subject: "Your opponent has moved a #{piece.piece_type} to #{(piece.x_coord + 96).chr}#{piece.y_coord}")
  end
end

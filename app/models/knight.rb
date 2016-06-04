class Knight < Piece
  def valid_move?(new_x, new_y)
      return false if off_board?(new_x, new_y)
      return false if current_square?(new_x, new_y)
  
      x_offset, y_offset = movement_by_axis(new_x, new_y)

      return true if x_offset.abs == 2 && y_offset.abs == 1 
      return true if x_offset.abs == 1 && y_offset.abs == 2
      
      false        
  end    
end

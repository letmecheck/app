class Piece < ActiveRecord::Base

  def check_obstruction(intended_x, intended_y)

    @pieces = Piece.all
    
    composite_self = y_coord * 10 + x_coord #if y_coord is 3 and x_coord is 6, composite_self will be 36
    composite_intended = intended_y * 10 + intended_x

    @pieces.each do |piece|

      next if piece == self #skip to next iteration if the instance of the current iteration is the piece whose move is being evaluated 

      composite_piece = piece.y_coord * 10 + piece.x_coord

      case
    
      when composite_self == composite_intended #if the current position of the piece is the intended position after the move 
        return true                             #there is an obstruction 

      when intended_x != x_coord && intended_y != y_coord #diagonal move

        number = [composite_self, composite_intended].min  #number is the minimum of the numeric representation of the current and intended positions
        sequence = [number]                                #the sequence array will store all the values between (diagonally) the current and intended positons

        if ([composite_self, composite_intended].max - [composite_self, composite_intended].min) % 9 == 0  #in downward-slopping diagonal moves, the difference
        #between two adjacent positions is equal to 9. The .max and .min methods are used because the sign of the change (+ or -) varies according to the direction of of play
      
          until number == [composite_self, composite_intended].max  #store all the relevant values (positions) between the current position (represented by the
            #variable number) and the intended one
            number += 9
            sequence.push(number)
          end 

          return true if sequence.include?(composite_piece) #if any of the pieces in the board have a numeric position equal to the positions between the current
          #and intended positions (ie, the values in the sequence array), there is an obstruction

        elsif ([composite_self, composite_intended].max - [composite_self, composite_intended].min) % 11 == 0  #in upward-slopping diagonal moves, the difference
        #between two adjacent positions is equal to 11
      
          until number == [composite_self, composite_intended].max
            number += 11
            sequence.push(number)
          end

          return true if sequence.include?(composite_piece)

        end

      when intended_x != x_coord #horizontal move 

        next if piece.y_coord != y_coord #do not check pieces that are on a different row
        return true if ([x_coord, intended_x].min..[x_coord, intended_x].max).include?(piece.x_coord)

      when intended_y != y_coord #vertical move
        
        next if piece.x_coord != x_coord #do not check pieces that are on a different column
        return true if ([y_coord, intended_y].min..[y_coord, intended_y].max).include?(piece.y_coord)

      end

    end

    return false #if no obstruction has been found, return false

  end


  def obstructed?(destination_x, destination_y)
    # Start at the piece's original location.
    current_x = x_coord
    current_y = y_coord

    # Determine the magnitude of movement along each axis.
    x_movement = (destination_x - current_x).abs
    y_movement = (destination_y - current_y).abs

    # Do we need to verify that the destination is on the board, and not the same
    # as the piece's current location? If so...
    board_range = (0..7)
    unless board_range.include?(destination_x) && board_range.include?(destination_y)
      raise 'Destination square is not on the board'
    end
    if x_movement == 0 && y_movement == 0
      raise 'Piece is already on destination square'
    end

    # If a move is along a rank or file, either x_movement or y_movement will be zero.
    # If a move is along a diagonal, x_movement and y_movement will be equal.
    # Otherwise, the move is invalid.

    unless x_movement == 0 || y_movement == 0 || x_movement == y_movement
      raise 'Destination is not on the same rank, file, or diagonal as origin'
    end

    # Set delta_x and delta_y to -1, 0, or 1, such that adding them to
    # current_x and current_y will move one square toward the destination.

    delta_x = destination_x <=> current_x
    delta_y = destination_y <=> current_y
    
    # Move toward the destination one square at a time, stopping and returning
    # true if an obstructing piece is present. Return false upon successfully
    # reaching the destination.
    @pieces = Piece.all

    loop do
      current_x += delta_x
      current_y += delta_y

      @pieces.each do |piece|
        return true if current_x == piece.x_coord && current_y == piece.y_coord
      end

      return false if current_x == destination_x && current_y == destination_y
    end
  end

  
end

class Piece < ActiveRecord::Base

  def check_obstruction(intended_x, intended_y)

    @pieces = Piece.all
    
    composite_self = self.y_coord * 10 + self.x_coord #if self.y_coord is 3 and self.x_coord is 6, composite_self will be 36
    composite_intended = intended_y * 10 + intended_x

    @pieces.each do |piece|

      next if piece == self #skip to next iteration if the instance of the current iteration is the piece whose move is being evaluated 

      composite_piece = piece.y_coord * 10 + piece.x_coord

      case
    
      when composite_self == composite_intended #if the current position of the piece is the intended position after the move 
        return true                             #there is an obstruction 

      when intended_x != self.x_coord && intended_y != self.y_coord #diagonal move

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

      when intended_x != self.x_coord #horizontal move 

        next if piece.y_coord != self.y_coord #do not check pieces that are on a different row
        return true if ([self.x_coord, intended_x].min..[self.x_coord, intended_x].max).include?(piece.x_coord)

      when intended_y != self.y_coord #vertical move
        
        next if piece.x_coord != self.x_coord #do not check pieces that are on a different column
        return true if ([self.y_coord, intended_y].min..[self.y_coord, intended_y].max).include?(piece.y_coord)

      end

    end

    return false #if no obstruction has been found, return false

  end

  
end

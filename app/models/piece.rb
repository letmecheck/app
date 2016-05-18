class Piece < ActiveRecord::Base

  def check_obstruction(intended_x, intended_y)

    @pieces = Piece.all
    
    composite_self = self.x_coord * 10 + self.y_coord
    composite_intended = intended_x * 10 + intended_y

    @pieces.each do |piece|

      next if piece == self 
      composite_piece = piece.x_coord * 10 + piece.y_coord

      if composite_self == composite_intended
        return true

      elsif intended_x != self.x_coord && intended_y != self.y_coord #diagonal move

        number = [composite_self, composite_intended].min
        sequence = [number]

        if ([composite_self, composite_intended].max - [composite_self, composite_intended].min) % 9 == 0  #downward-slopping diagonal move
=begin          next if piece == self

          number = [composite_self, composite_intended].min
          sequence = [number]
=end

          until number == [composite_self, composite_intended].max
            number += 9
            sequence.push(number)
          end 

          puts "here 1"
          puts sequence.inspect
          return true if sequence.include?(composite_piece)

        elsif ([composite_self, composite_intended].max - [composite_self, composite_intended].min) % 11 == 0  #upward-slopping diagonal move
=begin          next if piece == self

          number = [composite_self, composite_intended].min
          sequence = [number]
=end
          until number == [composite_self, composite_intended].max
            number += 11
            sequence.push(number)
          end

          puts "here 2"
          puts "composite_piece is #{composite_piece}"
          puts sequence.inspect
          return true if sequence.include?(composite_piece)

        end

      elsif intended_x != self.x_coord #horizontal move
        puts "here 3"
        puts "obstructing piece is #{piece.id} and x_coord is #{piece.x_coord}"
        #next if piece == self #do not check the position of the piece which the player intends to move
        next if piece.y_coord != self.y_coord #do not check pieces that are on a different column
        return true if ([self.x_coord, intended_x].min..[self.x_coord, intended_x].max).include?(piece.x_coord)

      elsif intended_y != self.y_coord #vertical move
        puts "here 4"
        puts "obstructing piece is #{piece.id} and y_coord is #{piece.y_coord}"
        #next if piece == self #do not check the position of the piece which the player intends to move
        next if piece.x_coord != self.x_coord #do not check pieces that are on a different row
        return true if ([self.y_coord, intended_y].min..[self.y_coord, intended_y].max).include?(piece.y_coord)

      end

    end

    return false

  end

  
end

class Knight < Piece
    def valid_move?(new_x, new_y)
        return false if off_board?(new_x, new_y)

        x_offset, y_offset = movement_by_axis(new_x, new_y)
        x_offset.abs == 2 && y_offset.abs == 1 || x_offset.abs == 1 && y_offset.abs == 2
    end
end

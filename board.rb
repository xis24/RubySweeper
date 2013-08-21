module RubySweeper
  class Board
  
    attr_accessor :cells
  
    def initialize
      @cells = Array.new($board_size) { Array.new($board_size) { Cell.new } }
      set_adjecent_mines
      print_board
    end
    
    
    def set_adjecent_mines
      (0...$board_size).each do |i|
        (0...$board_size).each do |j|
           @cells[i][j].adjecent_mines = get_adjecent_mines(i, j)
        end
      end
    end
  
    def get_adjecent_mines(x,y)
      mine_count = 0
      -1.upto(1).each do |i|
        -1.upto(1).each do |j|
          unless (i == 0 and j == 0) or out_of_range?(x+i,y+j)
            if @cells[x+i][y+j].mine  
              mine_count += 1 
            end
          end
        end
      end
      mine_count      
    end
  
    def sweep(x,y)  
      return if out_of_range?(x,y) or @cells[x][y].status == :checked
      if @cells[x][y].mine
        print_losing_board
        abort("You exploded!") 
      end
      @cells[x][y].status = :checked
      if @cells[x][y].adjecent_mines == 0 
        (-1..1).each do |i|
          (-1..1).each do |j|
            unless out_of_range?(x+i,y+j) or @cells[x+i][y+j].mine  
              sweep(x+i,y+j)
            end
          end
        end
      end
    end
  
    def print_board
      print_top_index
      @cells.each_with_index do |row, n|
        print ('a'..'z').to_a[n] + " |"
        row.each do |cell|
          case cell.status
          when :unchecked then print "X "
          when :checked then print cell.adjecent_mines.to_s + " "
          end
        end
        print "\n"
      end
    end
    
    def print_losing_board
      print_top_index
      @cells.each_with_index do |row, n|
        print ('a'..'z').to_a[n] + " |"
        row.each do |cell|
          if cell.mine
             print "M " 
          else 
            print cell.adjecent_mines.to_s + " "
          end
        end
        print "\n"
      end
    end
       
    def print_top_index
      print '   '
      print ('a'..'z').to_a.join(' ')
      print "\n"
      print '   ' + '-' * (26 * 2)
      print "\n"
    end
  
    def out_of_range?(x,y)
      x < 0 or y < 0 or x >= $board_size or y >= $board_size  
    end
    
    def win? 
      @cells.each do |row|
        row.each do |cell|
          if cell.status == :unchecked && !cell.mine
            return false 
          end
        end
      end
      true
    end
  end
end
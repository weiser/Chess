require 'set'

class ChessAnalysis
  def analyzeBoard(boardConfig)
    boardPlayers = getConfigByPlayer(boardConfig)

    locationOf_k = boardPlayers[:k][0]
    locationOf_K = boardPlayers[:K][0]

    #remove the location of the kings so we only focus on where attacking players are
    boardPlayers.delete(:k)
    boardPlayers.delete(:K)

    #for each player, generate a list of all places they can attack
    kingsInCheck = {:k => {}, :K => {}}
    boardPlayers.each{|playerType, playerAddresses|
      playerAddresses.each{ |address|
        possibleMoves = generateMoves(playerType, address)

        if playerType.to_s.match('[a-z]') and possibleMoves.include? locationOf_K
          if kingsInCheck[:K][playerType].nil?
            puts "K in check from #{address}"
            kingsInCheck[:K][playerType] = [address]
          else
            kingsInCheck[:K][playerType].push(address)
          end
        end
        if playerType.to_s.match('[A-Z]') and possibleMoves.include? locationOf_k
        if kingsInCheck[:k][playerType].nil?
            kingsInCheck[:k][playerType] = [address]
          else
            kingsInCheck[:k][playerType].push(address)
          end
        end
      }

    }
    return kingsInCheck
  end

  def generateMoves(playerType, address)
    moves = []
    case playerType
    #:Ps can attack at [row-1, col-1] and [row-1, col+1]
    when :P
      moves.unshift(makeMove(address, -1, -1))
      moves.unshift(makeMove(address, -1, 1))
    #:ps can attack at [row+1, col-1] and [row+1, col+1]
    when :p
      moves.unshift(makeMove(address, 1, -1))
      moves.unshift(makeMove(address, 1, 1))
    #knights attack at [row+-2, col+-1] and at [row+-1, col+-2]
    when :N, :n
      moves.unshift(makeMove(address, 2, 1))
      moves.unshift(makeMove(address, 2, -1))
      moves.unshift(makeMove(address, -2, 1))
      moves.unshift(makeMove(address, -2, -1))
    #rooks attack on row or column
    when :R, :r
      (1..8).each{|column|
        moves.unshift(makeMove(address, address[0], column))
      }
      (1..8).each{|row|
        moves.unshift(makeMove(address, row, address[1]))
      }
    #bishops attack on diagonal
    when :B, :b
      (1..8).each{|n|
        moves.unshift(makeMove(address, address[0]+n, address[1]+n))
        moves.unshift(makeMove(address, address[0]+n, address[1]-n))
        moves.unshift(makeMove(address, address[0]-n, address[1]+n))
        moves.unshift(makeMove(address, address[0]-n, address[1]-n))
      }
    #queens attack on row, column or diagonal
    when :Q, :q
      (1..8).each{|column|
        moves.unshift(makeMove(address, address[0], column))
      }
      (1..8).each{|row|
        moves.unshift(makeMove(address, row, address[1]))
      }
      (1..8).each{|n|
        moves.unshift(makeMove(address, address[0]+n, address[1]+n))
        moves.unshift(makeMove(address, address[0]+n, address[1]-n))
        moves.unshift(makeMove(address, address[0]-n, address[1]+n))
        moves.unshift(makeMove(address, address[0]-n, address[1]-n))
      }
    end
    removeInvalidMoves(moves)
  end
  
  def makeMove(address, rowOffset, colOffset)
    return [address[0]+rowOffset, address[1]+colOffset]
  end

  def removeInvalidMoves(moves)
    moves.each{|move|
      moves.delete(move) if move[0] > 8 or move[0] < 1 or move[1] > 8 or move[1] < 1
    }
  end

  def getConfigByPlayer(boardConfig)
    boardRows = boardConfig.split
    rowNum=1

    boardPlayers = {}
    boardRows.each { |row|
      colNum = 0
      row.split("").each{ |space|
        colNum +=1
        next unless space != '.'
        if not  boardPlayers[space.to_sym].nil?
          boardPlayers[space.to_sym].push([rowNum, colNum])
        else

          boardPlayers[space.to_sym] = [[rowNum, colNum]]
        end

      }
      rowNum +=1

    }
    return boardPlayers
  end
end
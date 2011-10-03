require 'set'

class ChessAnalysis
  def determineKingsInCheckmate(boardConfig)
    boardPlayers = getConfigByPlayer(boardConfig)

    #a king is in checkmate if they are in check and have no where to run.
    kingsInCheck = determineKingsInCheck(boardConfig)

    #get the list of all the places where the king is in checkmate at.  if there is a place where the kings is not in checkmate at, return nil
    unionCheckmatePositions!(kingsInCheck,boardPlayers,:k)
    unionCheckmatePositions!(kingsInCheck,boardPlayers,:K)
    
    return kingsInCheck
  end

  def unionCheckmatePositions!(kingsInCheck,boardPlayers, kingType)
    if kingsInCheck[kingType] != {}
      possibleMoves = generateMoves(kingType, boardPlayers[kingType][0])
      possibleMoves.each{|move|
        checkmatePositions = discoverKingsInCheck(boardPlayers, move, move)
        if checkmatePositions[kingType] != {}
          checkmatePositions[kingType].keys.each{|playerType|
            if kingsInCheck[kingType][playerType] = {}
            kingsInCheck[kingType][playerType] = checkmatePositions[kingType][playerType]
          else
            kingsInCheck[kingType][playerType] |= checkmatePositions[kingType][playerType]
          end
          }
        end
      }
    end
  end
  #returns a hash, {:k=>{:playerType => [list of addresses the player type puts the kings in check]}, :K=>{:playerType => [list of addresses the player type puts the kings in check]}}
  #The value of hash[:k] will be {} if the king is not in check.
  def determineKingsInCheck(boardConfig)
    boardPlayers = getConfigByPlayer(boardConfig)

    locationOf_k = boardPlayers[:k][0]
    locationOf_K = boardPlayers[:K][0]

    #remove the location of the kings so we only focus on where attacking players are
    boardPlayers.delete(:k)
    boardPlayers.delete(:K)

    #for each player, generate a list of all places they can attack
    kingsInCheck = discoverKingsInCheck(boardPlayers, locationOf_k, locationOf_K)
    return kingsInCheck
  end

  #based on a board configuration and the location of each of the kings, this method returns a hash which contains a hash of all player types which put the king in check and the address of the player
  def discoverKingsInCheck(boardPlayers, locationOf_k, locationOf_K)
    kingsInCheck = {:k=>{}, :K=>{}}
    boardPlayers.each{|playerType, playerAddresses|
      playerAddresses.each{ |address|
        possibleMoves = generateMoves(playerType, address)

        if playerType.to_s.match('[a-z]') and possibleMoves.include? locationOf_K
          if kingsInCheck[:K][playerType].nil?
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
        moves.unshift(makeMove(address, n, n))
        moves.unshift(makeMove(address, n, -n))
        moves.unshift(makeMove(address, -n, n))
        moves.unshift(makeMove(address, -n, -n))
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
        moves.unshift(makeMove(address, n, n))
        moves.unshift(makeMove(address, n, -n))
        moves.unshift(makeMove(address, -n, n))
        moves.unshift(makeMove(address, -n,-n))
      }
    #kings attack one in any direction
    when :k, :K
      moves.unshift(makeMove(address, 1, 1))
      moves.unshift(makeMove(address, 1, -1))
      moves.unshift(makeMove(address, 1, 0))
      moves.unshift(makeMove(address, 0,1))
      moves.unshift(makeMove(address, 0,-1))
      moves.unshift(makeMove(address, -1, 1))
      moves.unshift(makeMove(address, -1, -1))
      moves.unshift(makeMove(address, -1, 0))
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
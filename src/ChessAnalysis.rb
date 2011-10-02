class ChessAnalysis
  def analyzeBoard(boardConfig)
    boardPlayers = getConfigByPlayer(boardConfig)
    
    locationOf_k = boardPlayers[:k][0]
    locationOf_K = boardPlayers[:K][0]
    
    #remove the location of the kings so we only focus on where attacking players are
    boardPlayers[:k] = nil
    boardPlayers[:K] = nil
    
    #for each player, generate a list of all places they can attack
    kingsInCheck = []
    boardPlayers.each{|playerType, playerAddresses|
      playerAddresses.each{|address|
        possibleMoves = generateMoves(player, address)
        
        if player.match('[a-z]') and possibleMoves.contains(locationOf_K)
          kingsInCheck.push(locationOf_K)
        end
        if player.match('[A-Z]') and possibleMoves.contains(locationOf_k)
          kingsInCheck.push(locationOf_k)
        end
      }
        
    }
    return kingsInCheck
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
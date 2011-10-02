require 'test/unit'
require '../src/ChessAnalysis'

class ChessAnalysis_test < Test::Unit::TestCase
  def getBoardConfig1
    boardConfig = "..k.....\n"+
    "ppp.pppp\n"+
    "........\n"+
    ".R...B..\n"+
    "........\n"+
    "........\n"+
    "PPPPPPPP\n"+
    "K.......\n"
  end
  def testKingInCheck
    
    ca =  ChessAnalysis.new
    kingsInCheck = ca.analyzeBoard(getBoardConfig1())
  
    assert_equal kingsInCheck[:k].empty?, true
    assert_equal kingsInCheck[:K].empty?, false
  end
  
  def testAddressOfKings
    ca = ChessAnalysis.new
    boardConfig = ca.getConfigByPlayer(getBoardConfig1())
    
    assert_equal boardConfig[:k][0],  [1,3]
    assert_equal boardConfig[:K][1],  [8,1]
  end
  
end

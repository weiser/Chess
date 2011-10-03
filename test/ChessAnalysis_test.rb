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
    "PpPPPPPP\n"+
    "K.......\n"
  end

  def getBoardConfig2
    boardConfig="rnbqk.nr\n"+
    "ppp..ppp\n"+
    "....p...\n"+
    "...p....\n"+
    ".bPP....\n"+
    ".....N..\n"+
    "PP..PPPP\n"+
    "RNBQKB.R"
  end

  def testKingInCheck

    ca =  ChessAnalysis.new
    kingsInCheck = ca.analyzeBoard(getBoardConfig1())

    assert_equal kingsInCheck[:k][:B],[[4,6]]

    assert_equal kingsInCheck[:K][:p], [[7,2]]
    
    kingsInCheck = ca.analyzeBoard(getBoardConfig2)
    
    assert_equal kingsInCheck[:k], {}
    assert_equal kingsInCheck[:K][:b], [[5,2]]
  end

  def testAddressOfKings
    ca = ChessAnalysis.new
    boardConfig = ca.getConfigByPlayer(getBoardConfig1())

    assert_equal boardConfig[:k][0],  [1,3]
    assert_equal boardConfig[:K][0],  [8,1]
  end

end

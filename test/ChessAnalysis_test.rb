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

  def testKingInCheck

    ca =  ChessAnalysis.new
    kingsInCheck = ca.analyzeBoard(getBoardConfig1())

    assert_equal kingsInCheck[:k][:B],[[4,6]]

    assert_equal kingsInCheck[:K][:p], [[7,2]]
  end

  def testAddressOfKings
    ca = ChessAnalysis.new
    boardConfig = ca.getConfigByPlayer(getBoardConfig1())

    assert_equal boardConfig[:k][0],  [1,3]
    assert_equal boardConfig[:K][0],  [8,1]
  end

end

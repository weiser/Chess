require 'test/unit'
require '../src/ChessAnalysis'

class ChessAnalysis_test < Test::Unit::TestCase
  def getKingInCheckBoardConfig1
    boardConfig = "..k.....\n"+
    "ppp.pppp\n"+
    "........\n"+
    ".R...B..\n"+
    "........\n"+
    "........\n"+
    "PpPPPPPP\n"+
    "K.......\n"
  end

  def getKingInCheckBoardConfig2
    boardConfig="rnbqk.nr\n"+
    "ppp..ppp\n"+
    "....p...\n"+
    "...p....\n"+
    ".bPP....\n"+
    ".....N..\n"+
    "PP..PPPP\n"+
    "RNBQKB.R"
  end

  def getKingInCheckmateBoardConfig1
    boardConfig = "..k.....\n"+
    "..p.pppp\n"+
    "........\n"+
    ".R...B..\n"+
    "........\n"+
    "nq......\n"+
    ".pPPPPPP\n"+
    "K.......\n"
  end

  def testKingsInCheckmate
    ca = ChessAnalysis.new
    kingsInCheckmate = ca.determineKingsInCheckmate(getKingInCheckmateBoardConfig1)
    
    assert_equal kingsInCheckmate[:K][:p], [[7,2]]
    assert_equal kingsInCheckmate[:K][:q], [[6,2]]
    assert_equal kingsInCheckmate[:K][:n], [[6,1]]
  end

  def testKingInCheck

    ca =  ChessAnalysis.new
    kingsInCheck = ca.determineKingsInCheck(getKingInCheckBoardConfig1())

    assert_equal kingsInCheck[:k][:B],[[4,6]]

    assert_equal kingsInCheck[:K][:p], [[7,2]]

    kingsInCheck = ca.determineKingsInCheck(getKingInCheckBoardConfig2)

    assert_equal kingsInCheck[:k], {}
    assert_equal kingsInCheck[:K][:b], [[5,2]]
  end

  def testAddressOfKings
    ca = ChessAnalysis.new
    boardConfig = ca.getConfigByPlayer(getKingInCheckBoardConfig1())

    assert_equal boardConfig[:k][0],  [1,3]
    assert_equal boardConfig[:K][0],  [8,1]
  end

end

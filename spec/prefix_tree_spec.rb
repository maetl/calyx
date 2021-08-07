describe Calyx::PrefixTree do
  specify 'longest common prefix of strings' do
    tree = Calyx::PrefixTree.new
    expect(tree.common_prefix("a", "b")).to eq("")
    expect(tree.common_prefix("aaaaa", "aab")).to eq("aa")
    expect(tree.common_prefix("aa", "ab")).to eq("a")
    expect(tree.common_prefix("ababababahahahaha", "ababafgfgbaba")).to eq("ababa")
    expect(tree.common_prefix("abab", "abab")).to eq("abab")
  end

  specify "insert single value" do
    tree = Calyx::PrefixTree.new
    tree.add("one", 0)

    expect(tree.lookup("one").index).to eq(0)
    expect(tree.lookup("one!!")).to be_falsey
    expect(tree.lookup("two")).to be_falsey
  end

  specify "lookup with literal string data" do
    tree = Calyx::PrefixTree.new
    tree.add("test", 2)
    tree.add("team", 3)

    expect(tree.lookup("test").index).to eq(2)
    expect(tree.lookup("team").index).to eq(3)
    expect(tree.lookup("teal")).to be_falsey
  end

  specify "lookup with leading wildcard data" do
    tree = Calyx::PrefixTree.new
    tree.add("%es", 111)

    expect(tree.lookup("buses").index).to eq(111)
    expect(tree.lookup("bus")).to be_falsey
    expect(tree.lookup("train")).to be_falsey
    expect(tree.lookup("bushes").index).to eq(111)
  end

  specify "lookup with trailing wildcard data" do
    tree = Calyx::PrefixTree.new
    tree.add("te%", 222)

    expect(tree.lookup("test").index).to eq(222)
    expect(tree.lookup("total")).to be_falsey
    expect(tree.lookup("rubbish")).to be_falsey
    expect(tree.lookup("team").index).to eq(222)
  end

  specify "lookup with anchored wildcard data" do
    tree = Calyx::PrefixTree.new
    tree.add("te%s", 333)

    expect(tree.lookup("tests").index).to eq(333)
    expect(tree.lookup("total")).to be_falsey
    expect(tree.lookup("test")).to be_falsey
    expect(tree.lookup("team")).to be_falsey
    expect(tree.lookup("teams").index).to eq(333)
  end

  specify "lookup with catch all wildcard data" do
    tree = Calyx::PrefixTree.new
    tree.add("%", 444)

    expect(tree.lookup("tests").index).to eq(444)
    expect(tree.lookup("total").index).to eq(444)
    expect(tree.lookup("test").index).to eq(444)
    expect(tree.lookup("team").index).to eq(444)
    expect(tree.lookup("teams").index).to eq(444)
  end

  specify "lookup with cascading wildcard data" do
    tree = Calyx::PrefixTree.new
    tree.add("%y", 555)
    tree.add("%s", 666)
    tree.add("%", 777)

    expect(tree.lookup("ferry").index).to eq(555)
    expect(tree.lookup("bus").index).to eq(666)
    expect(tree.lookup("car").index).to eq(777)
  end
end

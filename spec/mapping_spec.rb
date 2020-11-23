describe Calyx::Mapping do
  it "is substitutable with callable procs" do
    mapping = Calyx::Mapping.new

    expect(mapping.call("key")).to eq("value")
    expect(mapping.call("key!")).to eq("")
  end
end

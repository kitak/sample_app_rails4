
describe Array do

  subject { [] }
  context "空のとき" do
    it "サイズは0" do
      should be_empty
    end
  end
end

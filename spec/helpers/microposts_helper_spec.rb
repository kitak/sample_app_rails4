require 'spec_helper'

describe MicropostsHelper do

  describe "wrap" do
    it "should insert `&#8203`" do
      expect(wrap("a"*31)).to eq "a"*30+'&#8203'+"a"
    end
  end
end

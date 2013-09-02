require "spec_helper"

describe Picture do
  it "has a valid factory" do
    FactoryGirl.create(:picture).should be_valid
  end

  it "should upload a valid picture"

  it "should belong to article after used in article.content"
end
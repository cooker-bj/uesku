require 'spec_helper'

describe "places/show" do
  before(:each) do
    @place = assign(:place, stub_model(Place,
      :title => "Title",
      :street => "Street",
      :province_id => 1,
      :city_id => 2,
      :district_id => 3,
      :website => "Website",
      :description => "MyText",
      :recommendation => "MyText",
      :price => "Price",
      :opening_hours => "Opening Hours",
      :positionx => "Positionx",
      :positiony => "Positiony",
      :direction => "Direction",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Street/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/Website/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Price/)
    rendered.should match(/Opening Hours/)
    rendered.should match(/Positionx/)
    rendered.should match(/Positiony/)
    rendered.should match(/Direction/)
    rendered.should match(/Phone/)
  end
end

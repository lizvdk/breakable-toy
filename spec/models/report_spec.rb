describe Report do
  let(:blank_values) { [nil, ""] }

  describe "#latitude" do
    it { should have_valid(:latitude).when(-90, 0, 90, 42.3603) }
    it do
      should_not have_valid(:latitude).when(-90.1, 90.1,
                                            *blank_values)
    end
  end

  describe "#longitude" do
    it { should have_valid(:longitude).when(-180, 0, 180, 71.0580) }
    it do
      should_not have_valid(:longitude).when(-180.1, 180.1,
                                             *blank_values)
    end
  end

  describe "#description" do
    it { should have_valid(:description).when("#{'x' * 500}", *blank_values) }
    it { should_not have_valid(:description).when("#{'x' * 501}") }
  end

  describe "#status" do
    it { should have_valid(:status).when("Open", "In Progress", "Closed") }
    it { should_not have_valid(:status).when("anything else", *blank_values) }
  end

  it ".geojson" do
    report = FactoryGirl.create(:report)
    expect(Report.geojson).to eq ({
      type: "FeatureCollection",
      features: [
        { type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [report.longitude, report.latitude]
          },
          properties: {
            category: report.category.name,
            url: "/reports/#{report.id}",
            photo: report.photo.small_thumb.url,
            updated_at: report.updated_at.localtime.strftime("%m/%d/%Y at %I:%M%p"),
            id: "report-#{report.id}",
            icon: {
              html: report.iconHTML,
              iconSize: [50, 50],
              iconAnchor: [25, 25],
              popupAnchor: [0, -25],
              className: "#{report.marker_color} map-icon"
            }
          }
        }
      ]
    })
  end

  it { should belong_to(:user) }
  it { should belong_to(:category) }
end
